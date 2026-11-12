// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Who is signed in. The app starts signed out.
///
/// Lifetime: keepAlive. It is the session: the router's gate listens to it
/// for the whole life of the app, and [signedInUserIdProvider] (and through
/// it every repository) follows it. Week 11 keeps this class and swaps the
/// repository behind it.

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// Who is signed in. The app starts signed out.
///
/// Lifetime: keepAlive. It is the session: the router's gate listens to it
/// for the whole life of the app, and [signedInUserIdProvider] (and through
/// it every repository) follows it. Week 11 keeps this class and swaps the
/// repository behind it.
final class AuthControllerProvider
    extends $NotifierProvider<AuthController, AuthState> {
  /// Who is signed in. The app starts signed out.
  ///
  /// Lifetime: keepAlive. It is the session: the router's gate listens to it
  /// for the whole life of the app, and [signedInUserIdProvider] (and through
  /// it every repository) follows it. Week 11 keeps this class and swaps the
  /// repository behind it.
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

String _$authControllerHash() => r'a1869b645a6cba50189229694aa4a239d8918fa4';

/// Who is signed in. The app starts signed out.
///
/// Lifetime: keepAlive. It is the session: the router's gate listens to it
/// for the whole life of the app, and [signedInUserIdProvider] (and through
/// it every repository) follows it. Week 11 keeps this class and swaps the
/// repository behind it.

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
