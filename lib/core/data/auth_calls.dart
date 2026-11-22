import 'package:dio/dio.dart';
import 'package:ronditrack_app/core/data/generated/models/access_token_response.dart';
import 'package:ronditrack_app/core/data/generated/models/login_request.dart';
import 'package:ronditrack_app/core/data/generated/models/register_request.dart';
import 'package:ronditrack_app/core/data/generated/models/user_response.dart';
import 'package:ronditrack_app/core/data/set_cookie.dart';
import 'package:ronditrack_app/core/session/access_token.dart';

/// A sign-in's or refresh's answer: the access token from the body, and
/// the refresh token from the `Set-Cookie` header.
typedef SessionTokens = ({AccessToken access, String refreshToken});

/// The API's auth endpoints, called with Dio directly (README "Decisions").
///
/// The generated client's methods take no per-call header, and the refresh
/// token must go out as a `Cookie` header on exactly two calls (refresh and
/// logout) and come back from `Set-Cookie` on two (sign-in and refresh).
/// So these four calls are written here by hand, with the generated
/// models for every body.
///
/// [_dio] is the bare client: no session interceptor. A refresh made
/// through the interceptor that is waiting on it would wait on itself.
class AuthCalls {
  /// Creates the calls over the bare client. `cookieName` is the flavour
  /// config's `REFRESH_COOKIE_NAME`.
  new(this._dio, {required this._cookieName});

  final Dio _dio;
  final String _cookieName;

  static const _login = '/api/v1/auth/login';
  static const _register = '/api/v1/auth/register';
  static const _refresh = '/api/v1/auth/refresh';
  static const _logout = '/api/v1/auth/logout';

  /// The paths that carry the refresh cookie, and so never an access
  /// token, and never pass through the session interceptor.
  static const Set<String> paths = {_login, _register, _refresh, _logout};

  /// `POST /auth/login`. A `401` is the email and password refused.
  Future<SessionTokens> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, Object?>>(
      _login,
      data: LoginRequest(email: email, password: password).toJson(),
    );
    return _tokens(response);
  }

  /// `POST /auth/register`: creates the account and answers who it is. It
  /// doesn't sign them in (no cookie, no token); [login] does, next.
  Future<UserResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, Object?>>(
      _register,
      data: RegisterRequest(
        name: name,
        email: email,
        password: password,
      ).toJson(),
    );
    return UserResponse.fromJson(response.data!);
  }

  /// `POST /auth/refresh` with [refreshToken] as the cookie. The API
  /// rotates it: the answer's cookie replaces it, and it is spent.
  Future<SessionTokens> refresh(String refreshToken) async {
    final response = await _dio.post<Map<String, Object?>>(
      _refresh,
      options: Options(headers: {'Cookie': '$_cookieName=$refreshToken'}),
    );
    return _tokens(response);
  }

  /// `POST /auth/logout` with [refreshToken] as the cookie, if there is
  /// one: the API revokes its whole family. Gives up after [timeout].
  Future<void> logout(String? refreshToken, {required Duration timeout}) =>
      _dio.post<void>(
        _logout,
        options: Options(
          headers: {
            if (refreshToken != null) 'Cookie': '$_cookieName=$refreshToken',
          },
          sendTimeout: timeout,
          receiveTimeout: timeout,
        ),
      );

  SessionTokens _tokens(Response<Map<String, Object?>> response) {
    final body = AccessTokenResponse.fromJson(response.data!);
    return (
      access: AccessToken.fromResponse(
        accessToken: body.accessToken,
        expiresAtUtc: body.expiresAtUtc,
      ),
      refreshToken: cookieFrom(response.headers, _cookieName),
    );
  }
}
