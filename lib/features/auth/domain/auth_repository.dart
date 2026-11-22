import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/auth/domain/auth_user.dart';

/// The fake sign-in's refusal: no seed persona has that email. Like
/// `POST /auth/login`'s `401`, it doesn't say which part was wrong.
class SignInFailedException extends UnauthorisedFailure {
  /// Creates the failure. It carries no email, so it is safe to log.
  const new() : super(atSignIn: true);

  @override
  String toString() => 'SignInFailedException';
}

/// Signs people in, registers them, restores the session the app stopped
/// with, and signs them out. The router's gate only sees the result.
abstract interface class AuthRepository {
  /// Signs in. A refused email and password is an [UnauthorisedFailure]
  /// with `atSignIn`; too many attempts a [RateLimitedFailure].
  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  });

  /// Creates the account, then signs in with it. A field the API refuses
  /// is a [ValidationFailure] with its `fieldErrors`; an address already
  /// in use a [RuleFailure].
  Future<Result<AuthUser>> register({
    required String name,
    required String email,
    required String password,
  });

  /// The session the app stopped with: `Ok(null)` when none is stored,
  /// the person when the API accepts it, an [UnauthorisedFailure] when it
  /// refuses it, and any other failure when it can't tell.
  Future<Result<AuthUser?>> restore();

  /// Wipes the session from the phone at once, then tells the API, giving
  /// up after a short timeout. Never fails: the person is signed out
  /// whatever the API says.
  Future<void> signOut();
}
