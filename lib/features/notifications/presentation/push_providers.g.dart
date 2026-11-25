// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Firebase plugin, or `null` with push off (no
/// `config/firebase.<flavour>.json`). `main` overrides it.

@ProviderFor(pushClient)
final pushClientProvider = PushClientProvider._();

/// The Firebase plugin, or `null` with push off (no
/// `config/firebase.<flavour>.json`). `main` overrides it.

final class PushClientProvider
    extends $FunctionalProvider<PushClient?, PushClient?, PushClient?>
    with $Provider<PushClient?> {
  /// The Firebase plugin, or `null` with push off (no
  /// `config/firebase.<flavour>.json`). `main` overrides it.
  PushClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushClientHash();

  @$internal
  @override
  $ProviderElement<PushClient?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PushClient? create(Ref ref) {
    return pushClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushClient? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushClient?>(value),
    );
  }
}

String _$pushClientHash() => r'aaac844d753b13d067bd3424a919963aa40c5b30';

/// Where a tap from a closed app asked to go, read before the first frame:
/// the router starts there, with no flash of Home. `main` overrides it.

@ProviderFor(pushStartLocation)
final pushStartLocationProvider = PushStartLocationProvider._();

/// Where a tap from a closed app asked to go, read before the first frame:
/// the router starts there, with no flash of Home. `main` overrides it.

final class PushStartLocationProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Where a tap from a closed app asked to go, read before the first frame:
  /// the router starts there, with no flash of Home. `main` overrides it.
  PushStartLocationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushStartLocationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushStartLocationHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return pushStartLocation(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$pushStartLocationHash() => r'5e8fdbd83fe5bc57ad06d0a1a5167b500376678d';

/// Keeps the API's record of this phone in step with who is signed in.
/// The auth controller calls it; it never reads the auth state (one way:
/// Riverpod refuses providers that depend on each other).

@ProviderFor(pushRegistration)
final pushRegistrationProvider = PushRegistrationProvider._();

/// Keeps the API's record of this phone in step with who is signed in.
/// The auth controller calls it; it never reads the auth state (one way:
/// Riverpod refuses providers that depend on each other).

final class PushRegistrationProvider
    extends
        $FunctionalProvider<
          PushRegistration,
          PushRegistration,
          PushRegistration
        >
    with $Provider<PushRegistration> {
  /// Keeps the API's record of this phone in step with who is signed in.
  /// The auth controller calls it; it never reads the auth state (one way:
  /// Riverpod refuses providers that depend on each other).
  PushRegistrationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushRegistrationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushRegistrationHash();

  @$internal
  @override
  $ProviderElement<PushRegistration> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PushRegistration create(Ref ref) {
    return pushRegistration(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushRegistration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushRegistration>(value),
    );
  }
}

String _$pushRegistrationHash() => r'365831ded59c2d0902363b45143301ba0a93ccf0';

/// What the app does with a push while it runs (README "Notifications",
/// question 3). Watched by the app.
///
/// * In front: the plugin file shows it on the app's channel; here, that
///   cycle (and Home) is fetched again. A push is a nudge to fetch, never
///   the news.
/// * A tap from the background: that cycle opens, through the router and
///   its gate, as a deep link would.

@ProviderFor(pushRouting)
final pushRoutingProvider = PushRoutingProvider._();

/// What the app does with a push while it runs (README "Notifications",
/// question 3). Watched by the app.
///
/// * In front: the plugin file shows it on the app's channel; here, that
///   cycle (and Home) is fetched again. A push is a nudge to fetch, never
///   the news.
/// * A tap from the background: that cycle opens, through the router and
///   its gate, as a deep link would.

final class PushRoutingProvider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// What the app does with a push while it runs (README "Notifications",
  /// question 3). Watched by the app.
  ///
  /// * In front: the plugin file shows it on the app's channel; here, that
  ///   cycle (and Home) is fetched again. A push is a nudge to fetch, never
  ///   the news.
  /// * A tap from the background: that cycle opens, through the router and
  ///   its gate, as a deep link would.
  PushRoutingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushRoutingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushRoutingHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return pushRouting(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$pushRoutingHash() => r'0c503732fcbe11f925be564326780a7bf9f6454d';
