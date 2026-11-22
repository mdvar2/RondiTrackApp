// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

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
final class AuthControllerProvider
    extends $NotifierProvider<AuthController, AuthState> {
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
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$authControllerHash() => r'94cdd9bb107e3d1ffa83b269c5401fcb8477039b';

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

abstract class _$AuthController extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
