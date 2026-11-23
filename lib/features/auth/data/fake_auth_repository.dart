import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/auth/domain/auth_repository.dart';
import 'package:ronditrack_app/features/auth/domain/auth_user.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

/// An [AuthRepository] that signs in as one of the three seed personas by
/// email, ignoring case and surrounding spaces, with any password that
/// isn't empty. The whole-app tests sign in through it.
///
/// It keeps who is signed in the way the phone keeps a refresh token:
/// [restore] finds them again until [signOut].
class FakeAuthRepository implements AuthRepository {
  /// Creates the fake. [delay] pretends to be the network; [storedEmail]
  /// is someone still signed in from the last launch.
  new({this.delay = const Duration(milliseconds: 600), this.storedEmail});

  /// The pretend network delay.
  final Duration delay;

  /// Who is signed in on this pretend phone.
  String? storedEmail;

  // No timer at all when there is no delay: a widget test that ends at
  // once leaves none pending.
  Future<void> _pretendNetwork() async {
    if (delay > Duration.zero) await Future<void>.delayed(delay);
  }

  /// Accounts registered since the app started.
  final Map<String, AuthUser> _registered = {};

  AuthUser? _find(String email) {
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
    return _registered[wanted];
  }

  @override
  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  }) async {
    await _pretendNetwork();
    final user = _find(email);
    if (user == null || password.isEmpty) {
      return const Err(SignInFailedException());
    }
    storedEmail = user.email;
    return Ok(user);
  }

  @override
  Future<Result<AuthUser>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _pretendNetwork();
    final wanted = email.trim().toLowerCase();
    if (_find(wanted) != null) {
      return const Err(
        RuleFailure(detail: 'An account with this email already exists.'),
      );
    }
    _registered[wanted] = AuthUser(
      id: 'registered-${_registered.length + 1}',
      name: name.trim(),
      email: wanted,
    );
    return await signIn(email: wanted, password: password);
  }

  @override
  Future<Result<AuthUser?>> restore() async {
    await _pretendNetwork();
    final email = storedEmail;
    return Ok(email == null ? null : _find(email));
  }

  @override
  Future<void> signOut() async {
    storedEmail = null;
    await _pretendNetwork();
  }
}
