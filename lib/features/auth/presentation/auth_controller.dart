import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';

part 'auth_controller.g.dart';

/// Who is signed in. The app starts signed out.
///
/// Lifetime: keepAlive. It is the session: the router's gate listens to it
/// for the whole life of the app, and [signedInUserIdProvider] (and through
/// it every repository) follows it. Week 11 keeps this class and swaps the
/// repository behind it.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  AuthState build() => const SignedOut();

  /// Signs in by email. Throws the repository's [Failure] (a wrong email
  /// is an `UnauthorisedFailure`) and leaves the state signed out.
  Future<void> signIn(String email) async {
    final result = await ref.read(authRepositoryProvider).signIn(email: email);
    state = SignedIn(result.valueOrThrow);
  }

  /// Signs out. The gate then sends every screen to sign-in. The person is
  /// signed out on this phone even if the API can't be told.
  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const SignedOut();
  }
}
