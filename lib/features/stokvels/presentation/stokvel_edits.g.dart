// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stokvel_edits.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Creating a stokvel and editing a cycle, for the forms: they never see
/// which editor (the API's or the fakes') does it.
///
/// Lifetime: autoDispose; it holds nothing.

@ProviderFor(StokvelEdits)
final stokvelEditsProvider = StokvelEditsProvider._();

/// Creating a stokvel and editing a cycle, for the forms: they never see
/// which editor (the API's or the fakes') does it.
///
/// Lifetime: autoDispose; it holds nothing.
final class StokvelEditsProvider extends $NotifierProvider<StokvelEdits, void> {
  /// Creating a stokvel and editing a cycle, for the forms: they never see
  /// which editor (the API's or the fakes') does it.
  ///
  /// Lifetime: autoDispose; it holds nothing.
  StokvelEditsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stokvelEditsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stokvelEditsHash();

  @$internal
  @override
  StokvelEdits create() => StokvelEdits();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$stokvelEditsHash() => r'018bb6ed144c2c445c322ba81cb900ec95778da9';

/// Creating a stokvel and editing a cycle, for the forms: they never see
/// which editor (the API's or the fakes') does it.
///
/// Lifetime: autoDispose; it holds nothing.

abstract class _$StokvelEdits extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
