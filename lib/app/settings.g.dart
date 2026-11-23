// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Where settings are kept. `main` overrides it with
/// [PreferencesSettingsStore].

@ProviderFor(settingsStore)
final settingsStoreProvider = SettingsStoreProvider._();

/// Where settings are kept. `main` overrides it with
/// [PreferencesSettingsStore].

final class SettingsStoreProvider
    extends $FunctionalProvider<SettingsStore, SettingsStore, SettingsStore>
    with $Provider<SettingsStore> {
  /// Where settings are kept. `main` overrides it with
  /// [PreferencesSettingsStore].
  SettingsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsStoreHash();

  @$internal
  @override
  $ProviderElement<SettingsStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SettingsStore create(Ref ref) {
    return settingsStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsStore>(value),
    );
  }
}

String _$settingsStoreHash() => r'da62495122ab52bce7af6a91f80501668c0e0c8f';

/// The app's language: the person's choice, or `null` to follow the phone.
///
/// Lifetime: keepAlive, and not rebuilt at sign-out: a setting belongs to
/// the phone, not to who is signed in.

@ProviderFor(LanguageChoice)
final languageChoiceProvider = LanguageChoiceProvider._();

/// The app's language: the person's choice, or `null` to follow the phone.
///
/// Lifetime: keepAlive, and not rebuilt at sign-out: a setting belongs to
/// the phone, not to who is signed in.
final class LanguageChoiceProvider
    extends $NotifierProvider<LanguageChoice, Locale?> {
  /// The app's language: the person's choice, or `null` to follow the phone.
  ///
  /// Lifetime: keepAlive, and not rebuilt at sign-out: a setting belongs to
  /// the phone, not to who is signed in.
  LanguageChoiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'languageChoiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$languageChoiceHash();

  @$internal
  @override
  LanguageChoice create() => LanguageChoice();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale?>(value),
    );
  }
}

String _$languageChoiceHash() => r'6f810477c3e73f4e6e5e7ab96daf01a9eeec4af7';

/// The app's language: the person's choice, or `null` to follow the phone.
///
/// Lifetime: keepAlive, and not rebuilt at sign-out: a setting belongs to
/// the phone, not to who is signed in.

abstract class _$LanguageChoice extends $Notifier<Locale?> {
  Locale? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Locale?, Locale?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale?, Locale?>,
              Locale?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
