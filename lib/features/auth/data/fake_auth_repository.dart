import 'package:ronditrack_app/features/auth/domain/auth_repository.dart';
import 'package:ronditrack_app/features/auth/domain/auth_user.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

/// An [AuthRepository] that signs in as one of the three seed personas by
/// email, ignoring case and surrounding spaces. No password until Week 11.
class FakeAuthRepository implements AuthRepository {
  /// Creates the fake. [delay] pretends to be the network.
  new({this.delay = const Duration(milliseconds: 600)});

  /// The pretend network delay.
  final Duration delay;

  @override
  Future<AuthUser> signIn({required String email}) async {
    await Future<void>.delayed(delay);
    final wanted = email.trim().toLowerCase();
    for (final persona in FakeSeed.personas.values) {
      if (persona.email == wanted) {
        return AuthUser(
          id: persona.id,
          name: persona.name,
          email: persona.email,
        );
      }
    }
    throw const SignInFailedException();
  }

  @override
  Future<void> signOut() => Future<void>.delayed(delay);
}
