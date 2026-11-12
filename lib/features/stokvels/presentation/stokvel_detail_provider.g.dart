// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stokvel_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One stokvel's detail, keyed by its id.
///
/// A family: every stokvel has its own state, so switching stokvels can
/// never show the previous one's data under the new one's name.
/// Lifetime: autoDispose. See README "Provider lifetimes".

@ProviderFor(stokvelDetail)
final stokvelDetailProvider = StokvelDetailFamily._();

/// One stokvel's detail, keyed by its id.
///
/// A family: every stokvel has its own state, so switching stokvels can
/// never show the previous one's data under the new one's name.
/// Lifetime: autoDispose. See README "Provider lifetimes".

final class StokvelDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<StokvelDetail>,
          StokvelDetail,
          FutureOr<StokvelDetail>
        >
    with $FutureModifier<StokvelDetail>, $FutureProvider<StokvelDetail> {
  /// One stokvel's detail, keyed by its id.
  ///
  /// A family: every stokvel has its own state, so switching stokvels can
  /// never show the previous one's data under the new one's name.
  /// Lifetime: autoDispose. See README "Provider lifetimes".
  StokvelDetailProvider._({
    required StokvelDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stokvelDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stokvelDetailHash();

  @override
  String toString() {
    return r'stokvelDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<StokvelDetail> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StokvelDetail> create(Ref ref) {
    final argument = this.argument as String;
    return stokvelDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StokvelDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stokvelDetailHash() => r'156bd40152617e045c8f0a6a2f33431181d59da5';

/// One stokvel's detail, keyed by its id.
///
/// A family: every stokvel has its own state, so switching stokvels can
/// never show the previous one's data under the new one's name.
/// Lifetime: autoDispose. See README "Provider lifetimes".

final class StokvelDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<StokvelDetail>, String> {
  StokvelDetailFamily._()
    : super(
        retry: null,
        name: r'stokvelDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One stokvel's detail, keyed by its id.
  ///
  /// A family: every stokvel has its own state, so switching stokvels can
  /// never show the previous one's data under the new one's name.
  /// Lifetime: autoDispose. See README "Provider lifetimes".

  StokvelDetailProvider call(String stokvelId) =>
      StokvelDetailProvider._(argument: stokvelId, from: this);

  @override
  String toString() => r'stokvelDetailProvider';
}

/// One cycle of one stokvel, keyed by both ids, so a cycle id under the
/// wrong stokvel is its own request, and is not found.
///
/// Lifetime: autoDispose, like [stokvelDetailProvider].

@ProviderFor(cycleDetail)
final cycleDetailProvider = CycleDetailFamily._();

/// One cycle of one stokvel, keyed by both ids, so a cycle id under the
/// wrong stokvel is its own request, and is not found.
///
/// Lifetime: autoDispose, like [stokvelDetailProvider].

final class CycleDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<CycleDetail>,
          CycleDetail,
          FutureOr<CycleDetail>
        >
    with $FutureModifier<CycleDetail>, $FutureProvider<CycleDetail> {
  /// One cycle of one stokvel, keyed by both ids, so a cycle id under the
  /// wrong stokvel is its own request, and is not found.
  ///
  /// Lifetime: autoDispose, like [stokvelDetailProvider].
  CycleDetailProvider._({
    required CycleDetailFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'cycleDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cycleDetailHash();

  @override
  String toString() {
    return r'cycleDetailProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<CycleDetail> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CycleDetail> create(Ref ref) {
    final argument = this.argument as (String, String);
    return cycleDetail(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is CycleDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cycleDetailHash() => r'2fb1d2dced4867020e7de944805fd0ea4510731e';

/// One cycle of one stokvel, keyed by both ids, so a cycle id under the
/// wrong stokvel is its own request, and is not found.
///
/// Lifetime: autoDispose, like [stokvelDetailProvider].

final class CycleDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CycleDetail>, (String, String)> {
  CycleDetailFamily._()
    : super(
        retry: null,
        name: r'cycleDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One cycle of one stokvel, keyed by both ids, so a cycle id under the
  /// wrong stokvel is its own request, and is not found.
  ///
  /// Lifetime: autoDispose, like [stokvelDetailProvider].

  CycleDetailProvider call(String stokvelId, String cycleId) =>
      CycleDetailProvider._(argument: (stokvelId, cycleId), from: this);

  @override
  String toString() => r'cycleDetailProvider';
}
