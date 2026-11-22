import 'dart:async';

import 'package:ronditrack_app/core/data/auth_calls.dart';
import 'package:ronditrack_app/core/data/to_failure.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/session/access_token.dart';
import 'package:ronditrack_app/core/session/refresh_token_store.dart';

/// A refresh that was still running when the person signed out (or someone
/// else signed in). Its answer is thrown away: it signs nobody back in.
final class RefreshOutlived extends UnauthorisedFailure {
  /// Creates the failure.
  const new();

  @override
  String toString() => 'RefreshOutlived';
}

/// The session: the access token in memory, the refresh token in the
/// [RefreshTokenStore], and the one refresh that may be running.
///
/// * **Single flight.** However many requests need a refresh at once, one
///   `POST /auth/refresh` is made; every caller awaits that same future.
/// * **Sent with an old token?** A `401` for a request that went out with
///   a token that has since been replaced is answered with the current
///   token, and never refreshes again: the API rotates the refresh token
///   and treats a spent one as stolen, revoking the whole session.
/// * **Only the refresh's own `401` ends the session.** A `403`, a `429`, a
///   `5xx` or no answer leaves it as it was, and the caller gets the
///   failure.
/// * **A late refresh signs nobody in.** Every sign-in and sign-out moves
///   the epoch on; a refresh that finishes in an older epoch stores nothing.
class Session {
  /// Creates the session.
  ///
  /// [margin] is how long before expiry a token is refreshed rather than
  /// sent. `onEnded` is called once when the API refuses the refresh.
  new({
    required this._calls,
    required this._store,
    required this._onEnded,
    this.margin = defaultMargin,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  /// The refresh margin (README "Decisions"): 30 s of the API's 5 minutes.
  static const defaultMargin = Duration(seconds: 30);

  final AuthCalls _calls;
  final RefreshTokenStore _store;
  final void Function() _onEnded;
  final DateTime Function() _clock;

  /// How long before expiry a token is refreshed rather than sent.
  final Duration margin;

  AccessToken? _access;
  Future<AccessToken>? _refreshing;
  int _epoch = 0;

  /// How many refreshes were sent to the API. The tests count them.
  int refreshes = 0;

  /// The access token, or `null` when there is none in memory (signed out,
  /// or just launched).
  AccessToken? get access => _access;

  /// Whether [token] should be refreshed before it is sent.
  bool isNearExpiry(AccessToken token) => token.expiresWithin(margin, _clock());

  /// Starts a session from a sign-in's [tokens]: the refresh token stored,
  /// the access token in memory. Any refresh still running belongs to the
  /// session before, and is ignored.
  Future<void> start(SessionTokens tokens) {
    final epoch = ++_epoch;
    _access = null;
    return _serially(() async {
      await _store.write(tokens.refreshToken);
      if (epoch == _epoch) _access = tokens.access;
    });
  }

  /// Whether a refresh token is stored: someone was signed in when the app
  /// last stopped.
  Future<bool> hasStoredSession() async => await _serially(_store.read) != null;

  /// A good access token, after one refresh shared by every caller.
  ///
  /// [sentWith] is the token a refused request carried. If the session
  /// has moved on since (another caller's refresh), the current token is
  /// returned and nothing is refreshed.
  Future<AccessToken> refresh({String? sentWith}) {
    final current = _access;
    if (sentWith != null &&
        current != null &&
        current.value != sentWith &&
        !isNearExpiry(current)) {
      return Future.value(current);
    }
    return _refreshing ??= _refresh().whenComplete(() => _refreshing = null);
  }

  Future<AccessToken> _refresh() async {
    final epoch = _epoch;
    final stored = await _serially(_store.read);
    if (stored == null) throw const UnauthorisedFailure();
    final SessionTokens tokens;
    try {
      refreshes++;
      tokens = await _calls.refresh(stored);
    } on Object catch (error) {
      final failure = toFailure(error);
      // Only the refresh's own 401 ends the session, and only if it is
      // still the session that asked.
      if (failure is UnauthorisedFailure && epoch == _epoch) {
        await end();
        _onEnded();
      }
      throw failure;
    }
    return await _serially(() async {
      // Signed out (or someone else signed in) while it ran: its answer
      // is thrown away, and the rotated token never written.
      if (epoch != _epoch) throw const RefreshOutlived();
      await _store.write(tokens.refreshToken);
      if (epoch != _epoch) throw const RefreshOutlived();
      return _access = tokens.access;
    });
  }

  /// Ends the session on this phone: the access token forgotten at once,
  /// and the stored refresh token deleted, before anything else. Returns
  /// the refresh token that was stored, for telling the API.
  Future<String?> end() {
    _epoch++;
    _access = null;
    return _serially(() async {
      final stored = await _store.read();
      await _store.delete();
      return stored;
    });
  }

  /// Runs store operations one at a time, in the order asked for, so a
  /// sign-out's delete can't land after the next sign-in's write.
  Future<T> _serially<T>(Future<T> Function() operation) {
    final result = _storeQueue.then((_) => operation());
    _storeQueue = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }

  Future<void> _storeQueue = Future.value();

  /// Dev build only: the access token stops being accepted by the API but
  /// still looks good to the app, so the next request is a `401`.
  void spoilAccessToken() {
    final access = _access;
    if (access == null) return;
    _access = AccessToken('${access.value}x', expiresAt: access.expiresAt);
  }

  /// Dev build only: the access token expires now, so the next request
  /// refreshes first.
  void expireAccessTokenNow() {
    final access = _access;
    if (access == null) return;
    _access = AccessToken(access.value, expiresAt: _clock().toUtc());
  }
}
