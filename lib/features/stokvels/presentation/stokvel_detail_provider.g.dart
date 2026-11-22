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
///
/// What the phone has, at once, then the server's answer once it is in the
/// cache (README "Offline").

@ProviderFor(stokvelDetail)
final stokvelDetailProvider = StokvelDetailFamily._();

/// One stokvel's detail, keyed by its id.
///
/// A family: every stokvel has its own state, so switching stokvels can
/// never show the previous one's data under the new one's name.
/// Lifetime: autoDispose. See README "Provider lifetimes".
///
/// What the phone has, at once, then the server's answer once it is in the
/// cache (README "Offline").

final class StokvelDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<StokvelDetail>,
          StokvelDetail,
          Stream<StokvelDetail>
        >
    with $FutureModifier<StokvelDetail>, $StreamProvider<StokvelDetail> {
  /// One stokvel's detail, keyed by its id.
  ///
  /// A family: every stokvel has its own state, so switching stokvels can
  /// never show the previous one's data under the new one's name.
  /// Lifetime: autoDispose. See README "Provider lifetimes".
  ///
  /// What the phone has, at once, then the server's answer once it is in the
  /// cache (README "Offline").
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
  $StreamProviderElement<StokvelDetail> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<StokvelDetail> create(Ref ref) {
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

String _$stokvelDetailHash() => r'fa392743dcf6e4a753dfd0841256472c7ebae1b6';

/// One stokvel's detail, keyed by its id.
///
/// A family: every stokvel has its own state, so switching stokvels can
/// never show the previous one's data under the new one's name.
/// Lifetime: autoDispose. See README "Provider lifetimes".
///
/// What the phone has, at once, then the server's answer once it is in the
/// cache (README "Offline").

final class StokvelDetailFamily extends $Family
    with $FunctionalFamilyOverride<Stream<StokvelDetail>, String> {
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
  ///
  /// What the phone has, at once, then the server's answer once it is in the
  /// cache (README "Offline").

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
          Stream<CycleDetail>
        >
    with $FutureModifier<CycleDetail>, $StreamProvider<CycleDetail> {
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
  $StreamProviderElement<CycleDetail> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<CycleDetail> create(Ref ref) {
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

String _$cycleDetailHash() => r'e26b047cafc70ce7e68de6b6f81fd3fec3b0708e';

/// One cycle of one stokvel, keyed by both ids, so a cycle id under the
/// wrong stokvel is its own request, and is not found.
///
/// Lifetime: autoDispose, like [stokvelDetailProvider].

final class CycleDetailFamily extends $Family
    with $FunctionalFamilyOverride<Stream<CycleDetail>, (String, String)> {
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
