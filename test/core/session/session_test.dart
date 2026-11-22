import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/data/to_failure.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/session/session.dart';

import '../../helpers/fake_auth_server.dart';
import '../../helpers/session_rig.dart';

/// Three requests that each need the session, sent at once.
const _three = ['/api/v1/me/home', '/api/v1/stokvels/a', '/api/v1/activity'];

/// Lets every request in flight reach the server, then lets refreshes
/// through: so all three 401s are in before any refresh answers.
Future<void> _releaseAfterAllArrive(Completer<void> gate) async {
  await Future<void>.delayed(const Duration(milliseconds: 50));
  gate.complete();
}

/// The bug, on purpose: refresh on every 401, each with the token in the
/// store at that moment, and send the request again. No single flight, no
/// "was this sent with the current token?".
class _PlainRefreshInterceptor extends Interceptor {
  new(this.rig);

  final SessionRig rig;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final access = rig.session.access;
    if (access != null) {
      options.headers['Authorization'] = 'Bearer ${access.value}';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) return handler.next(err);
    try {
      final stored = await rig.store.read();
      final tokens = await rig.calls.refresh(stored!);
      await rig.store.write(tokens.refreshToken);
      final retry = err.requestOptions.copyWith(
        headers: {
          ...err.requestOptions.headers,
          'Authorization': 'Bearer ${tokens.access.value}',
        },
      );
      handler.resolve(await rig.bare.fetch<Object?>(retry));
    } on DioException catch (error) {
      handler.next(error);
    }
  }
}

void main() {
  group('three requests, one refresh', () {
    test('against a server that rotates and detects reuse: a token it no '
        'longer accepts, three requests at once, three 401s, exactly one '
        'refresh, every request answered, still signed in', () async {
      final rig = SessionRig();
      await rig.signIn();
      final before = rig.store.token;
      rig.server.revokeAccess(rig.session.access!.value);
      final gate = rig.server.refreshGate = Completer<void>();

      final answers = Future.wait([for (final path in _three) rig.get(path)]);
      await _releaseAfterAllArrive(gate);

      expect(await answers, [200, 200, 200]);
      expect(rig.session.refreshes, 1);
      expect(rig.server.rotations, 1);
      expect(rig.server.reuses, 0);
      for (final path in _three) {
        expect(rig.answered(path, 401), 1, reason: path);
        expect(rig.answered(path, 200), 1, reason: path);
      }
      expect(rig.ended, 0);
      expect(rig.store.token, isNot(before));
      expect(rig.server.isAlive(rig.store.token!), isTrue);
    });

    test('a token past its expiry on the phone: one refresh before all '
        'three, and no 401 at all', () async {
      final rig = SessionRig();
      await rig.signIn();
      rig.now = rig.now.add(FakeAuthServer.accessLifetime);

      final answers = await Future.wait([
        for (final path in _three) rig.get(path),
      ]);

      expect(answers, [200, 200, 200]);
      expect(rig.session.refreshes, 1);
      expect(rig.server.log.where((l) => l.endsWith(' 401')), isEmpty);
    });

    test('a 401 for a request sent with a token that has since been '
        'replaced is retried with the new token, never refreshed '
        'again', () async {
      final rig = SessionRig();
      await rig.signIn();
      rig.server.revokeAccess(rig.session.access!.value);
      // The second request reaches the server only after the refresh.
      final late = rig.server.callGates['/api/v1/stokvels/late'] =
          Completer<void>();

      final lateAnswer = rig.get('/api/v1/stokvels/late');
      expect(await rig.get('/api/v1/me/home'), 200);
      expect(rig.server.rotations, 1);
      late.complete();

      expect(await lateAnswer, 200);
      expect(rig.answered('/api/v1/stokvels/late', 401), 1);
      expect(rig.session.refreshes, 1, reason: 'no second refresh');
      expect(rig.server.reuses, 0);
    });
  });

  test('the bug, on purpose: a plain interceptor that refreshes for every '
      '401 trips reuse detection, and the session is dead', () async {
    final rig = SessionRig();
    await rig.signIn();
    final plain = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8081'))
      ..httpClientAdapter = rig.server
      ..interceptors.add(_PlainRefreshInterceptor(rig));
    rig.server.revokeAccess(rig.session.access!.value);
    final gate = rig.server.refreshGate = Completer<void>();

    final answers = Future.wait([
      for (final path in _three)
        plain
            .get<Object?>(path)
            .then<Object?>((r) => r.statusCode)
            .catchError(toFailure),
    ]);
    await _releaseAfterAllArrive(gate);
    final results = await answers;

    expect(rig.server.reuses, greaterThan(0));
    expect(results, everyElement(isA<UnauthorisedFailure>()));
    // Whatever the store holds now, the API has revoked it: signed out.
    expect(rig.server.isAlive(rig.store.token!), isFalse);
    expect(
      toFailure(
        await rig.calls.refresh(rig.store.token!).then<Object>((_) {
          fail('The family should be revoked');
        }, onError: (Object e) => e),
      ),
      isA<UnauthorisedFailure>(),
    );
  });

  test('a refused refresh ends the session once, however many requests '
      'were waiting on it', () async {
    final rig = SessionRig();
    await rig.signIn();
    // Signed out elsewhere: the API revoked the family.
    await rig.calls.logout(
      rig.store.token,
      timeout: const Duration(seconds: 1),
    );
    rig.server.revokeAccess(rig.session.access!.value);
    final gate = rig.server.refreshGate = Completer<void>();

    final answers = Future.wait([for (final path in _three) rig.get(path)]);
    await _releaseAfterAllArrive(gate);

    for (final answer in await answers) {
      expect(toFailure(answer), isA<UnauthorisedFailure>());
    }
    expect(rig.session.refreshes, 1);
    expect(rig.ended, 1);
    expect(rig.store.token, isNull);
    expect(rig.session.access, isNull);
  });

  group('what never signs anyone out', () {
    for (final (name, override, failure) in [
      ('no answer', const Offline(), isA<NoAnswerFailure>()),
      ('a 403', const Status(403), isA<ForbiddenFailure>()),
      ('a 429', const Status(429, retryAfter: 30), isA<RateLimitedFailure>()),
      ('a 500', const Status(500), isA<ServerFailure>()),
    ]) {
      test('$name from the refresh: the request fails with it, and the '
          'session stays', () async {
        final rig = SessionRig();
        await rig.signIn();
        final stored = rig.store.token;
        rig.server
          ..revokeAccess(rig.session.access!.value)
          ..nextRefresh = override;

        final answer = await rig.get('/api/v1/me/home');

        expect(toFailure(answer), failure);
        expect(rig.ended, 0);
        expect(rig.store.token, stored);
        expect(rig.server.isAlive(stored!), isTrue);
      });

      test('$name from a call: no refresh, and the session stays', () async {
        final rig = SessionRig();
        await rig.signIn();
        rig.server.everyCall = override;

        final answer = await rig.get('/api/v1/stokvels/a');

        expect(toFailure(answer), failure);
        expect(rig.session.refreshes, 0);
        expect(rig.ended, 0);
        expect(rig.session.access, isNotNull);
      });
    }
  });

  test("the refresh and the retry don't go through the session interceptor: "
      "a retry's 401 is final, and nothing waits on itself", () async {
    final rig = SessionRig();
    await rig.signIn();
    // Every call is refused, even with a fresh token.
    rig.server.everyCall = const Status(401);

    final answer = await rig
        .get('/api/v1/me/home')
        .timeout(const Duration(seconds: 5));

    expect(toFailure(answer), isA<UnauthorisedFailure>());
    expect(rig.session.refreshes, 1);
    expect(rig.answered('/api/v1/me/home', 401), 2, reason: 'sent, retried');
    // The refresh went out on the bare client: no access token on it.
    final refresh = rig.server.requests.singleWhere(
      (r) => r.uri.path == '/api/v1/auth/refresh',
    );
    expect(refresh.headers['Authorization'], isNull);
  });

  test('the refresh cookie goes only to refresh and logout; the access '
      'token never goes to an auth call', () async {
    final rig = SessionRig();
    await rig.signIn();
    rig.session.spoilAccessToken();
    await rig.get('/api/v1/me/home');
    rig.now = rig.now.add(FakeAuthServer.accessLifetime);
    await rig.get('/api/v1/stokvels/a');
    await rig.calls.logout(
      await rig.session.end(),
      timeout: const Duration(seconds: 1),
    );

    for (final request in rig.server.requests) {
      final path = request.uri.path;
      final withCookie =
          path == '/api/v1/auth/refresh' || path == '/api/v1/auth/logout';
      expect(request.headers.containsKey('Cookie'), withCookie, reason: path);
      if (path.startsWith('/api/v1/auth/')) {
        expect(request.headers['Authorization'], isNull, reason: path);
      }
    }
    expect(rig.session.refreshes, 2);
  });

  test('a refresh that finishes after sign-out signs nobody back in', () async {
    final rig = SessionRig();
    await rig.signIn();
    rig.server.revokeAccess(rig.session.access!.value);
    final gate = rig.server.refreshGate = Completer<void>();

    final answer = rig.get('/api/v1/me/home');
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(rig.session.refreshes, 1, reason: 'the slow refresh is running');
    final told = await rig.session.end();
    gate.complete();

    expect(toFailure(await answer), isA<RefreshOutlived>());
    expect(told, isNotNull, reason: 'sign-out had the token to tell the API');
    expect(rig.session.access, isNull);
    expect(rig.store.token, isNull);
    expect(rig.store.writes, 1, reason: "only sign-in's; never the late one");
  });

  test('the Run console shows the 401s, one refresh, and the retries, and '
      'never a token', () async {
    final rig = SessionRig();
    await rig.signIn();
    final access = rig.session.access!.value;
    final refresh = rig.store.token!;
    rig.session.spoilAccessToken();
    final gate = rig.server.refreshGate = Completer<void>();

    final answers = Future.wait([for (final path in _three) rig.get(path)]);
    await _releaseAfterAllArrive(gate);
    await answers;

    final lines = rig.log.map((l) => l.replaceAll(RegExp(r' in \d+ ms.*'), ''));
    expect(lines.where((l) => l.endsWith(' 401')), hasLength(3));
    expect(lines.where((l) => l.contains('/auth/refresh')), [
      'API POST /api/v1/auth/refresh 200',
    ]);
    expect(lines.where((l) => l.endsWith(' 200')), hasLength(1 + 1 + 3));
    for (final line in rig.log) {
      expect(line, isNot(contains(access)));
      expect(line, isNot(contains(refresh)));
      expect(line, isNot(contains('Bearer')));
    }
  });
}
