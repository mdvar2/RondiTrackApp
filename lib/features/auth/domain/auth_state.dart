import 'package:flutter/foundation.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/features/auth/domain/auth_user.dart';

/// Who, if anyone, is signed in. The router's gate decides every
/// navigation from this and the address.
///
/// Three cases, so every `switch` over it has to decide what [Restoring]
/// means: the compiler lists each one that doesn't.
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

/// The app has just started and is finding out whether the session it
/// stopped with is still good: the stored refresh token goes to the API
/// once. Nobody is signed in or out yet, so every address waits on the
/// splash.
///
/// [failure] is why it couldn't find out (no answer, the server's fault, a
/// `429`): only the refresh's own `401` signs anyone out, so the person
/// stays on the splash with Try again and Sign out.
final class Restoring extends AuthState {
  /// Creates the state: checking, or stuck on [failure].
  const new({this.failure});

  /// Why the last try couldn't tell; `null` while it is running.
  final Failure? failure;

  @override
  bool operator ==(Object other) =>
      other is Restoring && other.failure == failure;

  @override
  int get hashCode => Object.hash(Restoring, failure);
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
