import 'dart:async';

import 'package:ronditrack_app/core/data/api_values.dart';
import 'package:ronditrack_app/core/data/auth_calls.dart';
import 'package:ronditrack_app/core/data/generated/rondi_track_api.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/core/session/session.dart';
import 'package:ronditrack_app/features/auth/domain/auth_repository.dart';
import 'package:ronditrack_app/features/auth/domain/auth_user.dart';

/// [AuthRepository] on the API (README "The session").
///
/// * Sign-in: `POST /auth/login` ([AuthCalls], with the refresh token read
///   from `Set-Cookie`), the session started, then `GET /me` for who.
/// * Register: `POST /auth/register`, which doesn't sign anyone in, then
///   the same sign-in.
/// * Restore: one refresh with the stored token, then `GET /me`.
/// * Sign-out: the session wiped first, then `POST /auth/logout` with the
///   old cookie, cut off after [logoutTimeout].
class ApiAuthRepository implements AuthRepository {
  /// Creates the repository.
  new(this._calls, this._session, this._api);

  final AuthCalls _calls;
  final Session _session;
  final RondiTrackApi _api;

  /// How long sign-out waits for the API before giving up on telling it.
  static const logoutTimeout = Duration(seconds: 5);

  @override
  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  }) async {
    final result = await guard(() async {
      await _session.start(
        await _calls.login(email: email.trim(), password: password),
      );
      return await _me();
    });
    switch (result) {
      case Ok():
        return result;
      // Signing in, a 401 is the email and password refused, and nothing
      // more: never which of them.
      case Err(failure: UnauthorisedFailure()):
        await _session.end();
        return const Err(UnauthorisedFailure(atSignIn: true));
      case Err(:final failure):
        await _session.end();
        return Err(failure);
    }
  }

  @override
  Future<Result<AuthUser>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final created = await guard(
      () => _calls.register(
        name: name.trim(),
        email: email.trim(),
        password: password,
      ),
    );
    return switch (created) {
      Ok() => await signIn(email: email, password: password),
      Err(:final failure) => Err(failure),
    };
  }

  @override
  Future<Result<AuthUser?>> restore() async {
    if (!await _session.hasStoredSession()) return const Ok(null);
    return await guard(() async {
      await _session.refresh();
      return await _me();
    });
  }

  @override
  Future<void> signOut() async {
    final stored = await _session.end();
    try {
      await _calls
          .logout(stored, timeout: logoutTimeout)
          .timeout(logoutTimeout);
    } on Object {
      // Signed out on this phone already; the API's answer changes
      // nothing. A token the API never heard about expires by itself.
    }
  }

  Future<AuthUser> _me() async {
    final me = (await _api.me.getApiV1Me()).data;
    return AuthUser(id: me.id, name: me.name, email: me.email);
  }
}
