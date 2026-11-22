import 'package:dio/dio.dart';
import 'package:ronditrack_app/core/data/auth_calls.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/session/session.dart';

/// The one interceptor that owns the session on every request.
///
/// * Puts the access token on every request but the auth calls.
/// * Refreshes first when the token expires within the session's margin,
///   or when there is none in memory but one is stored (the app was
///   opened offline, and this is the first request since).
/// * On a `401`, refreshes once and sends that request again once, on
///   [_retryClient]: a second client without this interceptor, so neither
///   the refresh ([AuthCalls], also on that client) nor the retry can wait
///   on this interceptor, and a retry's own `401` is final.
///
/// Every request that needs a refresh at the same moment shares the
/// session's one refresh. A `401` for a request sent with a token that has
/// since been replaced is retried with the new one, never refreshed again.
class SessionInterceptor extends Interceptor {
  /// Creates the interceptor.
  new(this._session, {required this._retryClient});

  final Session _session;
  final Dio _retryClient;

  /// The access token a request went out with.
  static const _sentWithKey = 'ronditrack.sentWith';

  /// Set on a request this interceptor already sent again.
  static const _retriedKey = 'ronditrack.retried';

  static bool _isAuthCall(RequestOptions options) =>
      AuthCalls.paths.contains(options.uri.path);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isAuthCall(options)) return handler.next(options);
    var access = _session.access;
    try {
      if (access != null && _session.isNearExpiry(access)) {
        // Refreshed before it is sent: no 401 needed.
        access = await _session.refresh(sentWith: access.value);
      } else if (access == null && await _session.hasStoredSession()) {
        access = await _session.refresh();
      }
    } on Failure catch (failure) {
      return handler.reject(_failed(options, failure));
    }
    if (access != null) {
      options.headers['Authorization'] = 'Bearer ${access.value}';
      options.extra[_sentWithKey] = access.value;
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final sentWith = request.extra[_sentWithKey];
    if (err.response?.statusCode != 401 ||
        sentWith is! String ||
        request.extra[_retriedKey] == true) {
      return handler.next(err);
    }

    final String token;
    try {
      token = (await _session.refresh(sentWith: sentWith)).value;
    } on Failure catch (failure) {
      // The refresh's own failure, not the request's 401: no answer is
      // "offline", a 500 is the server's fault. Only the refresh's 401
      // ended the session (the session did that).
      return handler.next(_failed(request, failure));
    }

    final retry = request.copyWith(
      headers: {...request.headers, 'Authorization': 'Bearer $token'},
    )..extra[_retriedKey] = true;
    try {
      handler.resolve(await _retryClient.fetch<Object?>(retry));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  DioException _failed(RequestOptions options, Failure failure) =>
      DioException(requestOptions: options, error: failure);
}
