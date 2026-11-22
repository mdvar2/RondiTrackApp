import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/domain/auth_user.dart';
import 'package:ronditrack_app/features/auth/presentation/sign_in_notice.dart';

part 'auth_controller.g.dart';

/// Who is signed in. The app starts [Restoring]: one refresh decides.
///
/// Lifetime: keepAlive. It is the session: the router's gate listens to it
/// for the whole life of the app, and [signedInUserIdProvider] (and through
/// it every repository and every provider holding someone's data) follows
/// it.
///
/// Every sign-in, sign-out and restore moves `_generation` on. An answer
/// that arrives for an older generation (a restore that finishes after
/// the person tapped Sign out) changes nothing.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  int _generation = 0;

  @override
  AuthState build() {
    // On launch, one refresh. The splash shows until it answers. Unless
    // something else (a sign-in) started first: that decides instead.
    unawaited(
      Future.microtask(() async {
        if (_generation == 0) await restore();
      }),
    );
    return const Restoring();
  }

  /// Finds out whether the session the app stopped with is still good:
  /// [SignedIn] if the API accepts the stored refresh token, [SignedOut]
  /// if there is none or the API refuses it, and still [Restoring], with
  /// the failure, if it can't tell (no signal is not signed out).
  Future<void> restore() async {
    final generation = ++_generation;
    state = const Restoring();
    final result = await ref.read(authRepositoryProvider).restore();
    if (!ref.mounted || generation != _generation) return;
    state = switch (result) {
      Ok(value: final AuthUser user) => SignedIn(user),
      Ok(value: null) => const SignedOut(),
      Err(failure: UnauthorisedFailure()) => const SignedOut(),
      Err(:final failure) => Restoring(failure: failure),
    };
  }

  /// Signs in. Throws the repository's [Failure] (a refused email and
  /// password is an `UnauthorisedFailure`) and leaves the state as it was.
  Future<void> signIn({required String email, required String password}) =>
      _signInWith(
        () => ref
            .read(authRepositoryProvider)
            .signIn(email: email, password: password),
      );

  /// Creates the account, then signs in with it. Throws the repository's
  /// [Failure]: field errors, an address already in use, the wait.
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) => _signInWith(
    () => ref
        .read(authRepositoryProvider)
        .register(name: name, email: email, password: password),
  );

  Future<void> _signInWith(Future<Result<AuthUser>> Function() attempt) async {
    final generation = ++_generation;
    final user = (await attempt()).valueOrThrow;
    if (!ref.mounted || generation != _generation) return;
    state = SignedIn(user);
  }

  /// Signs out: the session is wiped from the phone and the state is
  /// [SignedOut] at once, so every provider holding this person's data is
  /// rebuilt for nobody; then the API is told, with a short timeout. A dead
  /// network can't keep anyone signed in, and a slow one can't make this
  /// hang longer than the timeout.
  Future<void> signOut() async {
    _generation++;
    // The repository wipes the access token before its first await.
    final told = ref.read(authRepositoryProvider).signOut();
    state = const SignedOut();
    await told;
  }

  /// The API refused the refresh (its `401`): the session has ended.
  /// Sign-in says why, and the gate sends every screen there. Called once
  /// per ended session. A `403`, `429`, `5xx` or no answer never comes
  /// here.
  void sessionEnded() {
    if (state is! SignedIn) return;
    _generation++;
    ref.read(signInNoticeProvider.notifier).show(const UnauthorisedFailure());
    state = const SignedOut();
  }
}
