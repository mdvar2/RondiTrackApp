import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'flavour_config.dart';

/// One answer the [FakeAuthServer] can be told to give instead of its own.
sealed class ServerOverride {
  const new();
}

/// Answer with [status] and a problem body (and `Retry-After` for a 429).
final class Status extends ServerOverride {
  /// Creates the override.
  const new(this.status, {this.retryAfter, this.body});

  /// The status.
  final int status;

  /// `Retry-After`, in seconds.
  final int? retryAfter;

  /// The body, if not the default problem.
  final String? body;
}

/// No answer: the connection was refused.
final class Offline extends ServerOverride {
  const new();
}

/// The RondiTrack API's auth, as README "Contract notes › Auth" writes it
/// down, behind a Dio adapter:
///
/// * `POST /auth/login` answers the access token in the body and the
///   refresh token in `Set-Cookie`, among other cookies;
/// * `POST /auth/refresh` **rotates**: the cookie it is sent is spent, and
///   a spent one sent again is **reuse**: `401`, and the whole family is
///   revoked, the newer token too. There is no grace window;
/// * `POST /auth/logout` revokes the family of the cookie it is sent, and
///   answers `204` whatever it is sent;
/// * every other call needs a good access token, or it is `401`.
class FakeAuthServer implements HttpClientAdapter {
  /// Creates the server. [password] is the only one it accepts.
  new({required this.now, this.password = 'a-test-password-only'});

  /// The server's clock (and the test's).
  DateTime Function() now;

  /// The password every account has here.
  final String password;

  /// How long an access token lasts: the API's 5 minutes.
  static const accessLifetime = Duration(minutes: 5);

  /// Every request, in order.
  final List<RequestOptions> requests = [];

  /// Paths and statuses, one per answer, for reading in a test.
  final List<String> log = [];

  /// How many refreshes were answered `200`.
  int rotations = 0;

  /// How many times reuse was detected.
  int reuses = 0;

  /// Answers the next refresh with this, once, instead of its own.
  ServerOverride? nextRefresh;

  /// Answers every sign-in with this instead of its own.
  ServerOverride? everyLogin;

  /// Answers every register with this instead of its own.
  ServerOverride? everyRegister;

  /// Holds every refresh until the test completes it.
  Completer<void>? refreshGate;

  /// Holds every logout until the test completes it.
  Completer<void>? logoutGate;

  /// Answers every logout with this instead of its own.
  ServerOverride? everyLogout;

  /// Answers every other call (not auth, not `/me`) with this.
  ServerOverride? everyCall;

  /// Holds a call to this path until the test completes it.
  final Map<String, Completer<void>> callGates = {};

  int _serial = 0;
  final Map<String, _Refresh> _refreshTokens = {};
  final Map<String, ({String family, DateTime expires})> _access = {};
  final Set<String> _revoked = {};

  /// Signs [email] in, as the API would: a family, its first refresh token
  /// and an access token. For tests that start signed in.
  ({String access, DateTime expires, String refresh}) signIn(String email) {
    final family = 'family-${++_serial}';
    final refresh = _newRefresh(family);
    final access = _newAccess(family, email);
    return (access: access.token, expires: access.expires, refresh: refresh);
  }

  /// Whether [refreshToken]'s family is still alive.
  bool isAlive(String refreshToken) {
    final token = _refreshTokens[refreshToken];
    return token != null && !token.used && !_revoked.contains(token.family);
  }

  /// Makes [accessToken] stop working on the server (it was spoiled).
  void revokeAccess(String accessToken) => _access.remove(accessToken);

  String _newRefresh(String family) {
    final token = 'refresh-${++_serial}';
    _refreshTokens[token] = _Refresh(family);
    return token;
  }

  ({String token, DateTime expires}) _newAccess(String family, String email) {
    final expires = now().toUtc().add(accessLifetime);
    String part(Map<String, Object?> json) =>
        base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
    final token = [
      part({'alg': 'HS256', 'typ': 'JWT'}),
      part({
        'sub': 'user-$email',
        'jti': 'jti-${++_serial}',
        'exp': expires.millisecondsSinceEpoch ~/ 1000,
      }),
      'not-a-real-signature',
    ].join('.');
    _access[token] = (family: family, expires: expires);
    return (token: token, expires: expires);
  }

  String? _cookie(RequestOptions request) {
    final header = request.headers['Cookie'] as String?;
    if (header == null) return null;
    for (final pair in header.split(';')) {
      final equals = pair.indexOf('=');
      if (equals > 0 && pair.substring(0, equals).trim() == refreshCookieName) {
        return pair.substring(equals + 1).trim();
      }
    }
    return null;
  }

  ResponseBody _json(
    int status,
    Object body, {
    Map<String, List<String>> headers = const {},
  }) => ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: ['application/json; charset=utf-8'],
      ...headers,
    },
  );

  ResponseBody _problem(int status, {int? retryAfter, String? body}) =>
      ResponseBody.fromString(
        body ??
            jsonEncode({
              'status': status,
              'detail': 'Problem $status.',
              'correlationId': '0' * 32,
            }),
        status,
        headers: {
          Headers.contentTypeHeader: ['application/problem+json'],
          if (retryAfter != null) 'retry-after': ['$retryAfter'],
        },
      );

  ResponseBody _tokens(String family, String email) {
    final refresh = _newRefresh(family);
    final access = _newAccess(family, email);
    return _json(
      200,
      {
        'accessToken': access.token,
        'expiresAtUtc': access.expires.toIso8601String(),
      },
      headers: {
        'set-cookie': [
          'unrelated=1; path=/',
          '$refreshCookieName=$refresh; path=/api/v1/auth; secure; httponly',
          'another=2; path=/',
        ],
      },
    );
  }

  Never _offline(RequestOptions request) => throw DioException.connectionError(
    requestOptions: request,
    reason: 'Connection refused',
  );

  ResponseBody _answer(ResponseBody body, String path) {
    log.add('$path ${body.statusCode}');
    return body;
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final path = options.uri.path;
    switch (path) {
      case '/api/v1/auth/login':
        if (everyLogin case Status(
          :final status,
          :final retryAfter,
          :final body,
        )) {
          return _answer(
            _problem(status, retryAfter: retryAfter, body: body),
            path,
          );
        }
        final body = options.data as Map<String, Object?>;
        if (body['password'] != password) {
          return _answer(_problem(401), path);
        }
        final family = 'family-${++_serial}';
        return _answer(_tokens(family, body['email']! as String), path);
      case '/api/v1/auth/refresh':
        await refreshGate?.future;
        final override = nextRefresh;
        nextRefresh = null;
        switch (override) {
          case Offline():
            log.add('$path no answer');
            _offline(options);
          case Status(:final status, :final retryAfter, :final body):
            return _answer(
              _problem(status, retryAfter: retryAfter, body: body),
              path,
            );
          case null:
        }
        final cookie = _cookie(options);
        final token = cookie == null ? null : _refreshTokens[cookie];
        if (token == null || _revoked.contains(token.family)) {
          return _answer(_problem(401), path);
        }
        if (token.used) {
          // Reuse: the family dies, the newer token with it.
          reuses++;
          _revoked.add(token.family);
          return _answer(_problem(401), path);
        }
        token.used = true;
        rotations++;
        return _answer(_tokens(token.family, 'refreshed'), path);
      case '/api/v1/auth/logout':
        await logoutGate?.future;
        if (everyLogout is Offline) {
          log.add('$path no answer');
          _offline(options);
        }
        final cookie = _cookie(options);
        final token = cookie == null ? null : _refreshTokens[cookie];
        if (token != null) _revoked.add(token.family);
        return _answer(
          ResponseBody.fromString(
            '',
            204,
            headers: {
              'set-cookie': ['$refreshCookieName=; expires=Thu, 01 Jan 1970'],
            },
          ),
          path,
        );
      case '/api/v1/auth/register':
        if (everyRegister case Status(
          :final status,
          :final retryAfter,
          :final body,
        )) {
          return _answer(
            _problem(status, retryAfter: retryAfter, body: body),
            path,
          );
        }
        return _answer(
          _json(201, {
            'id': 'new-user',
            'name': 'New Person',
            'email': (options.data as Map)['email'],
            'version': 1,
          }),
          path,
        );
    }

    await callGates[path]?.future;
    if (everyCall case final ServerOverride override) {
      switch (override) {
        case Offline():
          log.add('$path no answer');
          _offline(options);
        case Status(:final status, :final retryAfter, :final body):
          return _answer(
            _problem(status, retryAfter: retryAfter, body: body),
            path,
          );
      }
    }
    final bearer = (options.headers['Authorization'] as String?)?.replaceFirst(
      'Bearer ',
      '',
    );
    final access = bearer == null ? null : _access[bearer];
    if (access == null ||
        _revoked.contains(access.family) ||
        !access.expires.isAfter(now().toUtc())) {
      return _answer(_problem(401), path);
    }
    if (path == '/api/v1/me') {
      return _answer(
        _json(200, {
          'id': '5d0c9a4e-0000-4000-8000-000000000001',
          'name': 'Lerato Mokoena',
          'email': 'lerato@ronditrack.example',
          'version': 1,
        }),
        path,
      );
    }
    return _answer(_json(200, {'ok': true}), path);
  }

  @override
  void close({bool force = false}) {}
}

class _Refresh {
  new(this.family);

  final String family;
  bool used = false;
}
