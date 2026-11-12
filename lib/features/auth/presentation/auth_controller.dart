import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/app/providers.dart';
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

  /// Signs in by email. Throws what the repository throws (a wrong email
  /// is `SignInFailedException`) and leaves the state signed out.
  Future<void> signIn(String email) async {
    final user = await ref.read(authRepositoryProvider).signIn(email: email);
    state = SignedIn(user);
  }

  /// Signs out. The gate then sends every screen to sign-in.
  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const SignedOut();
  }
}
