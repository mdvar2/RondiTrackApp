import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/auth/domain/auth_repository.dart';
import 'package:ronditrack_app/features/auth/domain/auth_user.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

/// An [AuthRepository] that signs in as one of the three seed personas by
/// email, ignoring case and surrounding spaces, with no password. The
/// whole-app tests sign in through it.
class FakeAuthRepository implements AuthRepository {
  /// Creates the fake. [delay] pretends to be the network.
  new({this.delay = const Duration(milliseconds: 600)});

  /// The pretend network delay.
  final Duration delay;

  @override
  Future<Result<AuthUser>> signIn({required String email}) async {
    await Future<void>.delayed(delay);
    final wanted = email.trim().toLowerCase();
    for (final persona in FakeSeed.personas.values) {
      if (persona.email == wanted) {
        return Ok(
          AuthUser(id: persona.id, name: persona.name, email: persona.email),
        );
      }
    }
    return const Err(SignInFailedException());
  }

  @override
  Future<Result<void>> signOut() async {
    await Future<void>.delayed(delay);
    return const Ok(null);
  }
}
