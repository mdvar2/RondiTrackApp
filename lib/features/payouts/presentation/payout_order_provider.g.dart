// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One cycle's payout order, keyed by [CycleKey].
///
/// A family: every cycle has its own state, so opening another cycle's
/// payouts can never show this one's order under its name.
/// Lifetime: autoDispose, like `cycleDetailProvider`: it holds other
/// members' names and amounts, and goes when the screen does.

@ProviderFor(payoutOrder)
final payoutOrderProvider = PayoutOrderFamily._();

/// One cycle's payout order, keyed by [CycleKey].
///
/// A family: every cycle has its own state, so opening another cycle's
/// payouts can never show this one's order under its name.
/// Lifetime: autoDispose, like `cycleDetailProvider`: it holds other
/// members' names and amounts, and goes when the screen does.

final class PayoutOrderProvider
    extends
        $FunctionalProvider<
          AsyncValue<PayoutOrder>,
          PayoutOrder,
          FutureOr<PayoutOrder>
        >
    with $FutureModifier<PayoutOrder>, $FutureProvider<PayoutOrder> {
  /// One cycle's payout order, keyed by [CycleKey].
  ///
  /// A family: every cycle has its own state, so opening another cycle's
  /// payouts can never show this one's order under its name.
  /// Lifetime: autoDispose, like `cycleDetailProvider`: it holds other
  /// members' names and amounts, and goes when the screen does.
  PayoutOrderProvider._({
    required PayoutOrderFamily super.from,
    required CycleKey super.argument,
  }) : super(
         retry: null,
         name: r'payoutOrderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$payoutOrderHash();

  @override
  String toString() {
    return r'payoutOrderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PayoutOrder> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PayoutOrder> create(Ref ref) {
    final argument = this.argument as CycleKey;
    return payoutOrder(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PayoutOrderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$payoutOrderHash() => r'ee1b1f4747d933c9c29438dad98409f56163eb7a';

/// One cycle's payout order, keyed by [CycleKey].
///
/// A family: every cycle has its own state, so opening another cycle's
/// payouts can never show this one's order under its name.
/// Lifetime: autoDispose, like `cycleDetailProvider`: it holds other
/// members' names and amounts, and goes when the screen does.

final class PayoutOrderFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PayoutOrder>, CycleKey> {
  PayoutOrderFamily._()
    : super(
        retry: null,
        name: r'payoutOrderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One cycle's payout order, keyed by [CycleKey].
  ///
  /// A family: every cycle has its own state, so opening another cycle's
  /// payouts can never show this one's order under its name.
  /// Lifetime: autoDispose, like `cycleDetailProvider`: it holds other
  /// members' names and amounts, and goes when the screen does.

  PayoutOrderProvider call(CycleKey cycle) =>
      PayoutOrderProvider._(argument: cycle, from: this);

  @override
  String toString() => r'payoutOrderProvider';
}
