import 'package:flutter/foundation.dart';
import 'package:ronditrack_app/features/auth/domain/auth_user.dart';

/// Who, if anyone, is signed in. The router's gate decides every
/// navigation from this and the address.
@immutable
sealed class AuthState {
  const new();
}

/// Nobody is signed in.
final class SignedOut extends AuthState {
  /// Creates the signed-out state.
  const new();

  @override
  bool operator ==(Object other) => other is SignedOut;

  @override
  int get hashCode => 0;
}

/// [user] is signed in.
final class SignedIn extends AuthState {
  /// Creates the signed-in state.
  const new(this.user);

  /// Who.
  final AuthUser user;

  @override
  bool operator ==(Object other) => other is SignedIn && other.user == user;

  @override
  int get hashCode => user.hashCode;
}
