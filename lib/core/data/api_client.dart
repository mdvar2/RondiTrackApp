import 'dart:math';

import 'package:dio/dio.dart';
import 'package:ronditrack_app/core/data/to_failure.dart';

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

/// The access token, in memory only: never written to storage, gone when
/// the app stops or the person signs out. Tomorrow's sign-in replaces this
/// stand-in.
class AccessTokenHolder {
  /// The token for every following request, or `null` when nobody is
  /// signed in.
  String? token;

  /// Forgets the token.
  void clear() => token = null;
}

/// The one Dio client: its base URL from the flavour's config, the app's
/// timeouts, and the app's own interceptors, in order: a trace id, the
/// token, the log line. Never Dio's `LogInterceptor`, which prints request
/// headers, and so the token.
Dio createApiClient({
  required Uri baseUri,
  required AccessTokenHolder tokens,
  required void Function() onSessionEnded,
  required void Function(String line) log,
  HttpClientAdapter? adapter,
  Random? random,
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
  dio.interceptors.addAll([
    TraceparentInterceptor(random ?? Random.secure()),
    AuthInterceptor(tokens, onSessionEnded: onSessionEnded),
    ApiLogInterceptor(log),
  ]);
  return dio;
}

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

/// Puts the in-memory access token on every request, and ends the session
/// when the API says it has ended (`401`).
///
/// A `401` from signing in is a refused password, not an ended session, so
/// `/auth/` calls never end it. A `403` never does: the person is signed
/// in, and only this stokvel's role is missing.
class AuthInterceptor extends Interceptor {
  /// Creates the interceptor.
  new(this._tokens, {required this.onSessionEnded});

  final AccessTokenHolder _tokens;

  /// Called on a `401` outside `/auth/`.
  final void Function() onSessionEnded;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokens.token;
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final signingIn = err.requestOptions.uri.path.contains('/auth/');
    if (err.response?.statusCode == 401 && !signingIn) {
      _tokens.clear();
      onSessionEnded();
    }
    handler.next(err);
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
