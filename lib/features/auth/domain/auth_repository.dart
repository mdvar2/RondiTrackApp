import 'package:ronditrack_app/features/auth/domain/auth_user.dart';

/// Thrown when no account matches. Like `POST /auth/login`'s `401`, it
/// doesn't say which part was wrong.
class SignInFailedException implements Exception {
  /// Creates the exception. It carries no email, so it is safe to log.
  const new();

  @override
  String toString() => 'SignInFailedException';
}

/// Signs people in and out. Week 11 implements it with `POST /auth/login`
/// and `POST /auth/logout`; the router's gate only sees the result.
abstract interface class AuthRepository {
  /// Signs in by email. Throws [SignInFailedException] if no account has
  /// that email.
  Future<AuthUser> signIn({required String email});

  /// Signs out.
  Future<void> signOut();
}
