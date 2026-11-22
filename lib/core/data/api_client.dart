import 'dart:math';

import 'package:dio/dio.dart';
import 'package:ronditrack_app/core/data/session_interceptor.dart';
import 'package:ronditrack_app/core/data/to_failure.dart';
import 'package:ronditrack_app/core/session/session.dart';

/// How long the app waits on the API (README "Decisions").
///
/// Measured against this API with its database unreachable: a closed
/// database port answered `500` after about 20 s (EF Core tries four
/// times); a database host that never answers took 64 s.
abstract final class ApiTimeouts {
  /// To open a connection. The API is one hop away on a LAN or USB, and a
  /// phone on mobile data still connects in a few seconds; 10 s means it
  /// isn't there.
  static const connect = Duration(seconds: 10);

  /// To send a request. Every body the app sends is a few hundred bytes.
  static const send = Duration(seconds: 10);

  /// To receive the answer once connected. Long enough for the API's own
  /// 20 s `500` (with its reference) to arrive, rather than the app giving
  /// up first and saying "no answer"; a database that never answers (64 s)
  /// is cut off here and shown as no answer.
  static const receive = Duration(seconds: 30);
}

Dio _client(
  Uri baseUri, {
  required List<Interceptor> interceptors,
  HttpClientAdapter? adapter,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUri.toString(),
      connectTimeout: ApiTimeouts.connect,
      sendTimeout: ApiTimeouts.send,
      receiveTimeout: ApiTimeouts.receive,
      headers: {'Accept': 'application/json'},
    ),
  );
  if (adapter != null) dio.httpClientAdapter = adapter;
  dio.interceptors.addAll(interceptors);
  return dio;
}

/// The bare client: a trace id and the log line, and no session. The auth
/// calls go through it (a refresh through the session interceptor could
/// wait on itself), and so does the session interceptor's one retry.
Dio createBareClient({
  required Uri baseUri,
  required void Function(String line) log,
  HttpClientAdapter? adapter,
  Random? random,
}) => _client(
  baseUri,
  adapter: adapter,
  interceptors: [
    TraceparentInterceptor(random ?? Random.secure()),
    ApiLogInterceptor(log),
  ],
);

/// The client every repository uses: its base URL from the flavour's
/// config, the app's timeouts, and the app's own interceptors, in order: a
/// trace id, the log line, the session. The log comes before the session
/// so a `401` is logged before it is refreshed and retried. Never Dio's
/// `LogInterceptor`, which prints request headers, and so the token.
Dio createApiClient({
  required Uri baseUri,
  required Session session,
  required Dio retryClient,
  required void Function(String line) log,
  HttpClientAdapter? adapter,
  Random? random,
}) => _client(
  baseUri,
  adapter: adapter,
  interceptors: [
    TraceparentInterceptor(random ?? Random.secure()),
    ApiLogInterceptor(log),
    SessionInterceptor(session, retryClient: retryClient),
  ],
);

/// Sends a W3C `traceparent` with a new trace id on every request. The API
/// adopts it, so the `correlationId` it logs is this id, and the app knows
/// a failure's reference even when the answer carried none (a proxy's
/// page). The id is random and says nothing about the person.
class TraceparentInterceptor extends Interceptor {
  /// Creates the interceptor, drawing ids from [_random].
  new(this._random);

  final Random _random;

  String _hex(int bytes) => [
    for (var i = 0; i < bytes; i++)
      _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ].join();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final traceId = _hex(16);
    options.extra[traceIdKey] = traceId;
    options.headers['traceparent'] = '00-$traceId-${_hex(8)}-01';
    handler.next(options);
  }
}

/// One line per call: the method, the path, the status, the time taken,
/// and the trace or correlation id.
///
/// Never a header (the token), a cookie, a body (names, amounts, arrears:
/// personal information under POPIA) or a query value. The path is
/// `uri.path`, which has no query; ids in it are random UUIDs.
class ApiLogInterceptor extends Interceptor {
  /// Creates the interceptor, writing to [_log].
  new(this._log);

  final void Function(String line) _log;

  static const _startedKey = 'ronditrack.startedAt';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startedKey] = DateTime.now().microsecondsSinceEpoch;
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final request = response.requestOptions;
    _log(
      '${_head(request)} ${response.statusCode} in ${_ms(request)} ms '
      '[trace ${request.extra[traceIdKey] ?? '-'}]',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final request = err.requestOptions;
    final response = err.response;
    final data = response?.data;
    final correlationId = data is Map && data['correlationId'] is String
        ? data['correlationId'] as String
        : request.extra[traceIdKey] ?? '-';
    final outcome = response == null
        ? 'no answer (${err.type.name})'
        : '${response.statusCode}';
    _log(
      '${_head(request)} $outcome in ${_ms(request)} ms '
      '[correlationId $correlationId]',
    );
    handler.next(err);
  }

  String _head(RequestOptions request) =>
      'API ${request.method} ${request.uri.path}';

  int _ms(RequestOptions request) {
    final started = request.extra[_startedKey];
    if (started is! int) return 0;
    return (DateTime.now().microsecondsSinceEpoch - started) ~/ 1000;
  }
}
