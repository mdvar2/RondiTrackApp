// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lifecycle_log.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Where lifecycle lines go: the Run console, in debug builds only. Tests
/// override it to read the lines back.

@ProviderFor(lifecycleLog)
final lifecycleLogProvider = LifecycleLogProvider._();

/// Where lifecycle lines go: the Run console, in debug builds only. Tests
/// override it to read the lines back.

final class LifecycleLogProvider
    extends $FunctionalProvider<LifecycleLog, LifecycleLog, LifecycleLog>
    with $Provider<LifecycleLog> {
  /// Where lifecycle lines go: the Run console, in debug builds only. Tests
  /// override it to read the lines back.
  LifecycleLogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lifecycleLogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lifecycleLogHash();

  @$internal
  @override
  $ProviderElement<LifecycleLog> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LifecycleLog create(Ref ref) {
    return lifecycleLog(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LifecycleLog value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LifecycleLog>(value),
    );
  }
}

String _$lifecycleLogHash() => r'37d1eb2419e44840aa73ab350e5c66770e2011e1';
