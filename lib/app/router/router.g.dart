// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's router.
///
/// Lifetime: keepAlive, and built once. It *listens* to the auth state
/// rather than watching it: rebuilding the router on sign-in would throw
/// away every tab's stack. Instead, each auth change is copied into a
/// [ValueNotifier] that is the router's `refreshListenable`, so the
/// redirect runs again the moment someone signs in or out, not only when
/// someone taps.

@ProviderFor(router)
final routerProvider = RouterProvider._();

/// The app's router.
///
/// Lifetime: keepAlive, and built once. It *listens* to the auth state
/// rather than watching it: rebuilding the router on sign-in would throw
/// away every tab's stack. Instead, each auth change is copied into a
/// [ValueNotifier] that is the router's `refreshListenable`, so the
/// redirect runs again the moment someone signs in or out, not only when
/// someone taps.

final class RouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// The app's router.
  ///
  /// Lifetime: keepAlive, and built once. It *listens* to the auth state
  /// rather than watching it: rebuilding the router on sign-in would throw
  /// away every tab's stack. Instead, each auth change is copied into a
  /// [ValueNotifier] that is the router's `refreshListenable`, so the
  /// redirect runs again the moment someone signs in or out, not only when
  /// someone taps.
  RouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return router(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$routerHash() => r'a40e606c539565fe74fbd48fb284822fab64c36f';
