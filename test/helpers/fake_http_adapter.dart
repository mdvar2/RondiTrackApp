import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// One answer from [FakeHttpAdapter]: a status, a body and headers, or no
/// answer at all.
sealed class FakeAnswer {
  const new();
}

/// The server answered.
final class Answer extends FakeAnswer {
  /// [body] is sent as written; JSON unless [contentType] says otherwise.
  const new(
    this.status,
    this.body, {
    this.headers = const {},
    this.contentType = 'application/json; charset=utf-8',
  });

  /// The status code.
  final int status;

  /// The body, as text.
  final String body;

  /// Extra headers.
  final Map<String, List<String>> headers;

  /// The `Content-Type`.
  final String contentType;
}

/// Nobody answered: the connection was refused.
final class NoAnswer extends FakeAnswer {
  const new();
}

/// An HTTP adapter for Dio that answers from a function instead of the
/// network, and keeps every request it was sent.
class FakeHttpAdapter implements HttpClientAdapter {
  /// Answers each request with [answer].
  new(this.answer);

  /// Decides each request's answer.
  final FakeAnswer Function(RequestOptions request) answer;

  /// Every request, in order.
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    switch (answer(options)) {
      case Answer(
        :final status,
        :final body,
        :final headers,
        :final contentType,
      ):
        return ResponseBody.fromString(
          body,
          status,
          headers: {
            Headers.contentTypeHeader: [contentType],
            ...headers,
          },
        );
      case NoAnswer():
        throw DioException.connectionError(
          requestOptions: options,
          reason: 'Connection refused',
        );
    }
  }

  @override
  void close({bool force = false}) {}
}
