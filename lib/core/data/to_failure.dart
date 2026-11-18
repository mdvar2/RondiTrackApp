import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ronditrack_app/core/errors/failure.dart';

/// The request option under which `TraceparentInterceptor` keeps the trace
/// id it sent. The API adopts it, so it is the `correlationId` the API logs,
/// and the reference for a failure whose answer carried none.
const traceIdKey = 'ronditrack.traceId';

/// Turns anything a call threw into the one [Failure] it means. The only
/// place in the app that looks at a status code (README "Failures").
///
/// * A [DioException] with an answer: by its status, with the API's
///   `detail`, `errors`, `correlationId` and `Retry-After`, read from the
///   raw body and headers. The contract's `ProblemDetails` schema lists
///   none of the extensions, so no generated model is used here.
/// * A [DioException] with no answer (offline, refused, a timeout):
///   [NoAnswerFailure].
/// * A body the models can't read (a proxy's HTML page where JSON was
///   expected, a field of the wrong type): [ServerFailure].
/// * A [ParallelWaitError] from calls awaited together: the most telling
///   of its failures, so a `404` among them is still not found.
/// * A [Failure]: itself.
Failure toFailure(Object error) => switch (error) {
  final Failure failure => failure,
  final DioException dio => _fromDio(dio),
  final ParallelWaitError<Object?, Object?> wait => _fromParallelWait(wait),
  SocketException() ||
  HttpException() ||
  TimeoutException() => const NoAnswerFailure(),
  _ => const ServerFailure(),
};

Failure _fromDio(DioException error) {
  final traceId = error.requestOptions.extra[traceIdKey] as String?;
  final response = error.response;
  return switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout ||
    DioExceptionType.connectionError ||
    DioExceptionType.cancel => const NoAnswerFailure(),
    // A certificate the app can't trust: whoever answered, it wasn't
    // shown to be the API.
    DioExceptionType.badCertificate => const NoAnswerFailure(),
    DioExceptionType.badResponse when response != null => _fromResponse(
      response,
      traceId,
    ),
    DioExceptionType.badResponse || DioExceptionType.unknown =>
      response == null && error.error is SocketException
          ? const NoAnswerFailure()
          // An answer that couldn't be decoded (a body that isn't JSON).
          : ServerFailure(correlationId: traceId),
  };
}

Failure _fromResponse(Response<Object?> response, String? traceId) {
  final status = response.statusCode ?? 0;
  // A ProblemDetails body is a JSON object; a proxy's error page is a
  // String. Only the first carries the API's words.
  final body = response.data;
  final problem = body is Map ? body : const <Object?, Object?>{};
  final detail = problem['detail'] is String
      ? problem['detail']! as String
      : null;
  final correlationId = problem['correlationId'] is String
      ? problem['correlationId']! as String
      : traceId;

  return switch (status) {
    400 => ValidationFailure(
      detail: detail,
      fieldErrors: _fieldErrors(problem['errors']),
    ),
    401 => const UnauthorisedFailure(),
    403 => const ForbiddenFailure(),
    404 => const NotFoundFailure(),
    409 || 410 || 422 => RuleFailure(detail: detail),
    412 => const ConflictFailure(),
    429 => RateLimitedFailure(wait: _retryAfter(response.headers)),
    // 5xx, and any other status the contract doesn't have (405, 415…):
    // either way the fault isn't the person's.
    _ => ServerFailure(correlationId: correlationId),
  };
}

/// `Retry-After`, in seconds as the API sends it, or as an HTTP date.
Duration? _retryAfter(Headers headers) {
  final value = headers.value('retry-after')?.trim();
  if (value == null || value.isEmpty) return null;
  final seconds = int.tryParse(value);
  if (seconds != null) return seconds < 0 ? null : Duration(seconds: seconds);
  try {
    final until = HttpDate.parse(value);
    final wait = until.difference(DateTime.now());
    return wait.isNegative ? Duration.zero : wait;
  } on FormatException {
    return null;
  }
}

Map<String, List<String>> _fieldErrors(Object? errors) => {
  if (errors is Map)
    for (final MapEntry(:key, :value) in errors.entries)
      if (key is String && value is List)
        key: [
          for (final message in value)
            if (message is String) message,
        ],
};

/// Calls awaited together fail together. Of their failures, the most
/// telling wins: a definite answer about the thing (not found, forbidden)
/// beats a refusal of the session, which beats a problem with the request,
/// which beats a server fault, which beats no answer.
Failure _fromParallelWait(ParallelWaitError<Object?, Object?> error) {
  final failures = [
    for (final async in _asyncErrors(error.errors)) toFailure(async.error),
  ];
  if (failures.isEmpty) return const ServerFailure();
  failures.sort((a, b) => _rank(a).compareTo(_rank(b)));
  return failures.first;
}

int _rank(Failure failure) => switch (failure) {
  NotFoundFailure() => 0,
  ForbiddenFailure() => 1,
  UnauthorisedFailure() => 2,
  RateLimitedFailure() => 3,
  ValidationFailure() || ConflictFailure() || RuleFailure() => 4,
  ServerFailure() => 5,
  NoAnswerFailure() => 6,
};

/// The errors of a `wait` over a list, or over a record of two to four
/// futures. A record can't be iterated, so each size is matched.
List<AsyncError> _asyncErrors(Object? errors) => switch (errors) {
  final List<Object?> list => list.whereType<AsyncError>().toList(),
  (final a, final b) => [a, b].whereType<AsyncError>().toList(),
  (final a, final b, final c) => [a, b, c].whereType<AsyncError>().toList(),
  (final a, final b, final c, final d) => [
    a,
    b,
    c,
    d,
  ].whereType<AsyncError>().toList(),
  final AsyncError single => [single],
  _ => const [],
};
