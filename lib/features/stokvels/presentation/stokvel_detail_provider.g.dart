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
