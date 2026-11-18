// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'close_cycle_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// What closing cycle [cycleId] of stokvel [stokvelId] would record.
///
/// Lifetime: autoDispose, like the cycle it sits on: it holds other
/// members' names and shortfalls, and goes when the screen does.

@ProviderFor(closePreview)
final closePreviewProvider = ClosePreviewFamily._();

/// What closing cycle [cycleId] of stokvel [stokvelId] would record.
///
/// Lifetime: autoDispose, like the cycle it sits on: it holds other
/// members' names and shortfalls, and goes when the screen does.

final class ClosePreviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<CycleClosePreview>,
          CycleClosePreview,
          FutureOr<CycleClosePreview>
        >
    with
        $FutureModifier<CycleClosePreview>,
        $FutureProvider<CycleClosePreview> {
  /// What closing cycle [cycleId] of stokvel [stokvelId] would record.
  ///
  /// Lifetime: autoDispose, like the cycle it sits on: it holds other
  /// members' names and shortfalls, and goes when the screen does.
  ClosePreviewProvider._({
    required ClosePreviewFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'closePreviewProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$closePreviewHash();

  @override
  String toString() {
    return r'closePreviewProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<CycleClosePreview> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CycleClosePreview> create(Ref ref) {
    final argument = this.argument as (String, String);
    return closePreview(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ClosePreviewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$closePreviewHash() => r'61a8c6409b2133f81db354a7486fe511c096b2b8';

/// What closing cycle [cycleId] of stokvel [stokvelId] would record.
///
/// Lifetime: autoDispose, like the cycle it sits on: it holds other
/// members' names and shortfalls, and goes when the screen does.

final class ClosePreviewFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<CycleClosePreview>,
          (String, String)
        > {
  ClosePreviewFamily._()
    : super(
        retry: null,
        name: r'closePreviewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// What closing cycle [cycleId] of stokvel [stokvelId] would record.
  ///
  /// Lifetime: autoDispose, like the cycle it sits on: it holds other
  /// members' names and shortfalls, and goes when the screen does.

  ClosePreviewProvider call(String stokvelId, String cycleId) =>
      ClosePreviewProvider._(argument: (stokvelId, cycleId), from: this);

  @override
  String toString() => r'closePreviewProvider';
}
