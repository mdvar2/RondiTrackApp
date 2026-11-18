import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/data/api_client.dart';
import 'package:ronditrack_app/core/data/to_failure.dart';
import 'package:ronditrack_app/core/errors/failure.dart';

import '../../helpers/api_fixtures.dart';
import '../../helpers/fake_http_adapter.dart';

const _token = 'eyJhbGciOiJIUzI1NiJ9.secret-token-payload.signature';
const _cookie =
    '__Secure-ronditrack_refresh=c2VjcmV0LXJlZnJlc2g; path=/api/v1/auth';

/// A client against a fake adapter, counting ended sessions.
({Dio dio, FakeHttpAdapter adapter, List<String> log, List<int> ended}) _client(
  FakeAnswer Function(RequestOptions request) answer,
) {
  final tokens = AccessTokenHolder()..token = _token;
  final log = <String>[];
  final ended = <int>[];
  final adapter = FakeHttpAdapter(answer);
  final dio = createApiClient(
    baseUri: Uri.parse('http://127.0.0.1:8081'),
    tokens: tokens,
    onSessionEnded: () => ended.add(1),
    log: log.add,
    adapter: adapter,
    random: Random(7),
  );
  return (dio: dio, adapter: adapter, log: log, ended: ended);
}

Future<Object?> _get(Dio dio, String path) async {
  try {
    await dio.get<Object?>(path);
    return null;
  } on DioException catch (error) {
    return error;
  }
}

void main() {
  group('the log line leaves nothing personal in it', () {
    test('a success: method, path, status, time and trace, and nothing of '
        'the token, the cookie, the body or the query', () async {
      final client = _client(
        (_) => Answer(
          200,
          apiFixtureText('home_lerato'),
          headers: {
            'set-cookie': [_cookie],
          },
        ),
      );

      await client.dio.get<Object?>(
        '/api/v1/me/home',
        queryParameters: {'userId': 'lerato-secret-query'},
      );

      final line = client.log.single;
      expect(
        line,
        matches(
          RegExp(
            r'^API GET /api/v1/me/home 200 in \d+ ms \[trace [0-9a-f]{32}\]$',
          ),
        ),
      );
      for (final secret in [
        _token,
        'secret-token',
        'Bearer',
        'c2VjcmV0LXJlZnJlc2g',
        'ronditrack_refresh',
        'lerato-secret-query',
        'userId',
        '?',
        'Lerato',
        'Mokoena',
        'Mabena',
        '50000',
        '75000',
        'Treasurer',
      ]) {
        expect(line, isNot(contains(secret)), reason: secret);
      }
    });

    test("a failure: the status and the error's correlationId, never its "
        'detail or a name', () async {
      final client = _client(
        (_) => Answer(
          500,
          jsonEncode({
            'type': 'about:blank',
            'title': 'Internal Server Error',
            'status': 500,
            'detail': 'An unexpected error occurred for Sipho Dlamini.',
            'correlationId': '9f21773e18af553124148fb4140b5bc4',
          }),
        ),
      );

      await _get(client.dio, '/api/v1/stokvels/abc');

      final line = client.log.single;
      expect(
        line,
        matches(
          RegExp(
            r'^API GET /api/v1/stokvels/abc 500 in \d+ ms '
            r'\[correlationId 9f21773e18af553124148fb4140b5bc4\]$',
          ),
        ),
      );
      expect(line, isNot(contains('Sipho')));
      expect(line, isNot(contains('unexpected')));
    });

    test('no answer says so, with the trace id', () async {
      final client = _client((_) => const NoAnswer());

      final error = await _get(client.dio, '/api/v1/me/home');

      expect(toFailure(error!), isA<NoAnswerFailure>());
      expect(
        client.log.single,
        matches(
          RegExp(
            r'^API GET /api/v1/me/home no answer \(connectionError\) in \d+ ms '
            r'\[correlationId [0-9a-f]{32}\]$',
          ),
        ),
      );
    });
  });

  group('the token', () {
    test('goes on every request, and not after it is cleared', () async {
      final tokens = AccessTokenHolder()..token = _token;
      final adapter = FakeHttpAdapter((_) => const Answer(200, '{}'));
      final dio = createApiClient(
        baseUri: Uri.parse('http://127.0.0.1:8081'),
        tokens: tokens,
        onSessionEnded: () {},
        log: (_) {},
        adapter: adapter,
      );

      await dio.get<Object?>('/api/v1/me/home');
      await dio.get<Object?>('/api/v1/stokvels/a');
      await dio.post<Object?>('/api/v1/invites/X/join');
      tokens.clear();
      await dio.get<Object?>('/api/v1/me/home');

      expect(
        [for (final r in adapter.requests) r.headers['Authorization']],
        ['Bearer $_token', 'Bearer $_token', 'Bearer $_token', null],
      );
    });

    test('every request carries a W3C traceparent whose trace id is kept '
        'for the failure', () async {
      final client = _client((_) => const Answer(200, '{}'));

      await client.dio.get<Object?>('/api/v1/me/home');

      final request = client.adapter.requests.single;
      final traceparent = request.headers['traceparent'] as String;
      expect(
        traceparent,
        matches(RegExp(r'^00-[0-9a-f]{32}-[0-9a-f]{16}-01$')),
      );
      expect(traceparent.split('-')[1], request.extra[traceIdKey]);
    });
  });

  group('who is signed out', () {
    test('a 403 signs nobody out, and keeps the token', () async {
      final client = _client(
        (_) => Answer(403, apiFixtureText('problem_403_member')),
      );

      final error = await _get(
        client.dio,
        '/api/v1/stokvels/s/cycles/c/close/preview',
      );

      expect(toFailure(error!), isA<ForbiddenFailure>());
      expect(client.ended, isEmpty);
      expect(
        client.adapter.requests.single.headers['Authorization'],
        'Bearer $_token',
      );
    });

    test('a 401 on any other call ends the session, once per call', () async {
      final client = _client((_) => Answer(401, apiFixtureText('problem_401')));

      await _get(client.dio, '/api/v1/me/home');

      expect(client.ended, [1]);
    });

    test('a 401 from signing in is a refused password, not an ended '
        'session', () async {
      final client = _client(
        (_) => Answer(401, apiFixtureText('problem_401_login')),
      );

      try {
        await client.dio.post<Object?>('/api/v1/auth/login', data: {});
      } on DioException catch (error) {
        expect(toFailure(error), isA<UnauthorisedFailure>());
      }
      expect(client.ended, isEmpty);
    });
  });

  test('the timeouts are the decided ones', () {
    final options = _client((_) => const Answer(200, '{}')).dio.options;
    expect(options.connectTimeout, const Duration(seconds: 10));
    expect(options.sendTimeout, const Duration(seconds: 10));
    expect(options.receiveTimeout, const Duration(seconds: 30));
    expect(options.baseUrl, 'http://127.0.0.1:8081');
  });
}
