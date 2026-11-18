import 'package:ronditrack_app/core/data/api_client.dart';
import 'package:ronditrack_app/core/data/api_values.dart';
import 'package:ronditrack_app/core/data/generated/models/login_request.dart';
import 'package:ronditrack_app/core/data/generated/rondi_track_api.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/auth/domain/auth_repository.dart';
import 'package:ronditrack_app/features/auth/domain/auth_user.dart';

/// [AuthRepository] on the API: today's stand-in for sign-in.
///
/// It signs in as a seed persona with the seed password given at run time
/// (`--dart-define=SEED_PASSWORD`, dev flavour only, never committed):
/// `POST /auth/login`, then `GET /me` for who that is. The access token is
/// kept in memory only ([AccessTokenHolder]) and lasts the API's 5
/// minutes; there is no refresh until tomorrow's sign-in, which also reads
/// the refresh cookie. Signing out tells the API, then forgets the token.
class ApiAuthRepository implements AuthRepository {
  /// Creates the repository.
  new(this._api, this._tokens, {required String seedPassword})
    : _password = seedPassword;

  final RondiTrackApi _api;
  final AccessTokenHolder _tokens;
  final String _password;

  @override
  Future<Result<AuthUser>> signIn({required String email}) async {
    final result = await guard(() async {
      final login = await _api.auth.postApiV1AuthLogin(
        body: LoginRequest(email: email.trim(), password: _password),
      );
      _tokens.token = login.data.accessToken;
      final me = (await _api.me.getApiV1Me()).data;
      return AuthUser(id: me.id, name: me.name, email: me.email);
    });
    return switch (result) {
      Ok() => result,
      // Signing in, a 401 is the email and password refused.
      Err(failure: UnauthorisedFailure()) => _refused(
        const UnauthorisedFailure(atSignIn: true),
      ),
      Err(:final failure) => _refused(failure),
    };
  }

  Result<AuthUser> _refused(Failure failure) {
    _tokens.clear();
    return Err(failure);
  }

  /// The person is signed out on this phone whatever the API answers.
  @override
  Future<Result<void>> signOut() async {
    await guard(() => _api.auth.postApiV1AuthLogout());
    _tokens.clear();
    return const Ok(null);
  }
}
