import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/auth/domain/auth_user.dart';

/// The fake sign-in's refusal: no seed persona has that email. Like
/// `POST /auth/login`'s `401`, it doesn't say which part was wrong. The
/// real sign-in fails with [UnauthorisedFailure] itself, whose words also
/// mention the password.
class SignInFailedException extends UnauthorisedFailure {
  /// Creates the failure. It carries no email, so it is safe to log.
  const new() : super(atSignIn: true);

  @override
  String get message => 'No account uses that email.';

  @override
  String toString() => 'SignInFailedException';
}

/// Signs people in and out: `POST /auth/login` and `POST /auth/logout`.
/// The router's gate only sees the result.
abstract interface class AuthRepository {
  /// Signs in by email. Fails with an [UnauthorisedFailure] if no account
  /// matches.
  Future<Result<AuthUser>> signIn({required String email});

  /// Signs out.
  Future<Result<void>> signOut();
}
