// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_statuses.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// How each screen's data stands (when fetched, whether the last refresh
/// failed), by key: `home`, `stokvel:<id>`, `cycle:<id>:<cycleId>`. The
/// banners read it. Rebuilt for whoever signs in.

@ProviderFor(SyncStatuses)
final syncStatusesProvider = SyncStatusesProvider._();

/// How each screen's data stands (when fetched, whether the last refresh
/// failed), by key: `home`, `stokvel:<id>`, `cycle:<id>:<cycleId>`. The
/// banners read it. Rebuilt for whoever signs in.
final class SyncStatusesProvider
    extends $NotifierProvider<SyncStatuses, Map<String, SyncStatus>> {
  /// How each screen's data stands (when fetched, whether the last refresh
  /// failed), by key: `home`, `stokvel:<id>`, `cycle:<id>:<cycleId>`. The
  /// banners read it. Rebuilt for whoever signs in.
  SyncStatusesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncStatusesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncStatusesHash();

  @$internal
  @override
  SyncStatuses create() => SyncStatuses();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, SyncStatus> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, SyncStatus>>(value),
    );
  }
}

String _$syncStatusesHash() => r'12286669a98f5a0fdcebc668650e2ed85303699b';

/// How each screen's data stands (when fetched, whether the last refresh
/// failed), by key: `home`, `stokvel:<id>`, `cycle:<id>:<cycleId>`. The
/// banners read it. Rebuilt for whoever signs in.

abstract class _$SyncStatuses extends $Notifier<Map<String, SyncStatus>> {
  Map<String, SyncStatus> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<Map<String, SyncStatus>, Map<String, SyncStatus>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, SyncStatus>, Map<String, SyncStatus>>,
              Map<String, SyncStatus>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
