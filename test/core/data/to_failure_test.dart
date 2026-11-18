import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/data/to_failure.dart';
import 'package:ronditrack_app/core/errors/failure.dart';

import '../../helpers/api_fixtures.dart';

final _request = RequestOptions(path: '/api/v1/me/home');

/// The DioException Dio throws for [status] with [data] and [headers].
DioException _answer(
  int status,
  Object? data, {
  Map<String, List<String>> headers = const {},
  RequestOptions? request,
}) {
  final options = request ?? _request;
  return DioException.badResponse(
    statusCode: status,
    requestOptions: options,
    response: Response<Object?>(
      requestOptions: options,
      statusCode: status,
      data: data,
      headers: Headers.fromMap(headers),
    ),
  );
}

/// A ProblemDetails body as the API writes it.
Map<String, Object?> _problem(int status, String detail) => {
  'type': 'about:blank',
  'title': 'Title',
  'status': status,
  'detail': detail,
  'instance': '/api/v1/x',
  'correlationId': 'c0ffee00c0ffee00c0ffee00c0ffee00',
};

void main() {
  group('every status the API sends maps to its Failure', () {
    test('400: validation, with the detail and each field', () {
      final failure = toFailure(
        _answer(400, apiFixture('problem_400_validation')),
      );

      expect(failure, isA<ValidationFailure>());
      final validation = failure as ValidationFailure;
      expect(validation.detail, startsWith("'Name' must not be empty."));
      expect(validation.fieldErrors.keys, {'name', 'email', 'password'});
      expect(validation.fieldErrors['email'], [
        "'Email' is not a valid email address.",
      ]);
    });

    test('400: a page token used with other filters is validation too', () {
      final failure = toFailure(_answer(400, apiFixture('problem_400_token')));
      expect(
        (failure as ValidationFailure).detail,
        'Page token does not match the current sort or filter.',
      );
    });

    test('401: unauthorised', () {
      expect(
        toFailure(_answer(401, apiFixture('problem_401'))),
        isA<UnauthorisedFailure>(),
      );
    });

    test('403: forbidden, never "not found"', () {
      expect(
        toFailure(_answer(403, apiFixture('problem_403_member'))),
        isA<ForbiddenFailure>(),
      );
    });

    test('404: not found, for a non-member exactly as for nothing there', () {
      expect(
        toFailure(_answer(404, apiFixture('problem_404_nonmember'))),
        isA<NotFoundFailure>(),
      );
      expect(
        toFailure(
          _answer(404, _problem(404, 'The requested endpoint was not found.')),
        ),
        isA<NotFoundFailure>(),
      );
    });

    test("409: a rule, with the API's words", () {
      final failure = toFailure(
        _answer(
          409,
          _problem(409, 'This contribution cycle is already closed.'),
        ),
      );
      expect(failure, isA<RuleFailure>());
      expect(failure.message, 'This contribution cycle is already closed.');
    });

    test('410: an expired invite is a rule too', () {
      final failure = toFailure(
        _answer(410, _problem(410, 'This invite has expired.')),
      );
      expect(failure.message, 'This invite has expired.');
    });

    test('412: a stale ETag is a conflict, "changed elsewhere"', () {
      expect(
        toFailure(_answer(412, apiFixture('problem_412'))),
        isA<ConflictFailure>(),
      );
    });

    test('429: rate limited, with the wait from Retry-After in seconds', () {
      final failure = toFailure(
        _answer(
          429,
          apiFixture('problem_429'),
          headers: {
            'retry-after': ['60'],
          },
        ),
      );

      expect(failure, isA<RateLimitedFailure>());
      expect((failure as RateLimitedFailure).wait, const Duration(seconds: 60));
      expect(
        failure.message,
        'Too many attempts. Wait 60 seconds, then try again.',
      );
    });

    test('429 with Retry-After as an HTTP date still says how long', () {
      final at = DateTime.now().toUtc().add(const Duration(seconds: 90));
      final failure = toFailure(
        _answer(
          429,
          null,
          headers: {
            'retry-after': [HttpDate.format(at)],
          },
        ),
      );
      final wait = (failure as RateLimitedFailure).wait!;
      expect(wait.inSeconds, inInclusiveRange(85, 90));
    });

    test("500: server, with the reference and never the API's message", () {
      final failure = toFailure(
        _answer(500, {
          ..._problem(500, 'An unexpected error occurred.'),
          'correlationId': '9f21773e18af553124148fb4140b5bc4',
        }),
      );

      expect(failure, isA<ServerFailure>());
      expect(failure.reference, '9f21773e18af553124148fb4140b5bc4');
      expect(failure.message, isNot(contains('unexpected error')));
    });

    test("a status the contract lacks (405) is the server's fault", () {
      expect(toFailure(_answer(405, null)), isA<ServerFailure>());
    });
  });

  group("answers that aren't ProblemDetails", () {
    test("a proxy's HTML 502 is a server failure, with the trace id sent", () {
      final request = RequestOptions(
        path: '/api/v1/me/home',
        extra: {traceIdKey: '4bf92f3577b34da6a3ce929d0e0e4736'},
      );
      final failure = toFailure(
        _answer(
          502,
          '<html><body><h1>502 Bad Gateway</h1></body></html>',
          request: request,
        ),
      );

      expect(failure, isA<ServerFailure>());
      expect(failure.reference, '4bf92f3577b34da6a3ce929d0e0e4736');
    });

    test("a body the models can't read is a server failure", () {
      Object? thrown;
      try {
        // What json_serializable does with a field of the wrong type.
        final json = <String, Object?>{'amountPaid': 'fifty rand'};
        json['amountPaid']! as int;
      } on Object catch (error) {
        thrown = error;
      }
      expect(toFailure(thrown!), isA<ServerFailure>());
      expect(
        toFailure(const FormatException('Unexpected character')),
        isA<ServerFailure>(),
      );
    });

    test("JSON that Dio itself couldn't decode is a server failure", () {
      final failure = toFailure(
        DioException(
          requestOptions: _request,
          response: Response<Object?>(
            requestOptions: _request,
            statusCode: 200,
          ),
          error: const FormatException('Unexpected end of input'),
        ),
      );
      expect(failure, isA<ServerFailure>());
    });
  });

  group('no answer at all', () {
    for (final type in [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.connectionError,
    ]) {
      test('$type is no answer', () {
        expect(
          toFailure(DioException(requestOptions: _request, type: type)),
          isA<NoAnswerFailure>(),
        );
      });
    }

    test('a socket error with no response is no answer', () {
      expect(
        toFailure(
          DioException(
            requestOptions: _request,
            error: const SocketException('Connection refused'),
          ),
        ),
        isA<NoAnswerFailure>(),
      );
      expect(
        toFailure(const SocketException('Network is unreachable')),
        isA<NoAnswerFailure>(),
      );
    });

    test("its words are the brief's", () {
      expect(
        const NoAnswerFailure().message,
        "You're offline, or we couldn't reach the server.",
      );
    });
  });

  group('calls awaited together', () {
    Future<Never> fail(Exception error) async {
      await Future<void>.delayed(Duration.zero);
      throw error;
    }

    test('a 404 inside a ParallelWaitError is still not found', () async {
      Object? thrown;
      try {
        await (
          fail(
            DioException(
              requestOptions: _request,
              type: DioExceptionType.connectionError,
            ),
          ),
          fail(_answer(404, apiFixture('problem_404_nonmember'))),
        ).wait;
      } on Object catch (error) {
        thrown = error;
      }

      expect(thrown, isA<ParallelWaitError<Object?, Object?>>());
      expect(toFailure(thrown!), isA<NotFoundFailure>());
    });

    test(
      'three calls, one forbidden and one a server failure: forbidden',
      () async {
        Object? thrown;
        try {
          await (
            Future.value(1),
            fail(_answer(500, _problem(500, 'x'))),
            fail(_answer(403, apiFixture('problem_403_member'))),
          ).wait;
        } on Object catch (error) {
          thrown = error;
        }
        expect(toFailure(thrown!), isA<ForbiddenFailure>());
      },
    );

    test('a list of calls works the same way', () async {
      Object? thrown;
      try {
        await [
          fail(_answer(500, _problem(500, 'x'))),
          Future<Never>.error(
            DioException(
              requestOptions: _request,
              type: DioExceptionType.receiveTimeout,
            ),
          ),
        ].wait;
      } on Object catch (error) {
        thrown = error;
      }
      expect(toFailure(thrown!), isA<ServerFailure>());
    });
  });

  test('a Failure is already mapped', () {
    const failure = RateLimitedFailure(wait: Duration(seconds: 3));
    expect(toFailure(failure), same(failure));
  });
}
