// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payments_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Every payment waiting in the outbox, oldest first. Lifetime:
/// autoDispose; the outbox itself is in the database.

@ProviderFor(pendingPayments)
final pendingPaymentsProvider = PendingPaymentsProvider._();

/// Every payment waiting in the outbox, oldest first. Lifetime:
/// autoDispose; the outbox itself is in the database.

final class PendingPaymentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PendingPayment>>,
          List<PendingPayment>,
          Stream<List<PendingPayment>>
        >
    with
        $FutureModifier<List<PendingPayment>>,
        $StreamProvider<List<PendingPayment>> {
  /// Every payment waiting in the outbox, oldest first. Lifetime:
  /// autoDispose; the outbox itself is in the database.
  PendingPaymentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingPaymentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingPaymentsHash();

  @$internal
  @override
  $StreamProviderElement<List<PendingPayment>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PendingPayment>> create(Ref ref) {
    return pendingPayments(ref);
  }
}

String _$pendingPaymentsHash() => r'1df2e1623c8117db0075d9b48f5705c83e61abed';

/// The last thing a payment came to, for the snack bar. Rebuilt for
/// whoever signs in.

@ProviderFor(PaymentNotices)
final paymentNoticesProvider = PaymentNoticesProvider._();

/// The last thing a payment came to, for the snack bar. Rebuilt for
/// whoever signs in.
final class PaymentNoticesProvider
    extends $NotifierProvider<PaymentNotices, PaymentOutcome?> {
  /// The last thing a payment came to, for the snack bar. Rebuilt for
  /// whoever signs in.
  PaymentNoticesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentNoticesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentNoticesHash();

  @$internal
  @override
  PaymentNotices create() => PaymentNotices();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaymentOutcome? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaymentOutcome?>(value),
    );
  }
}

String _$paymentNoticesHash() => r'8b8d0d25aacd795256094950b60fc5b1384c37fa';

/// The last thing a payment came to, for the snack bar. Rebuilt for
/// whoever signs in.

abstract class _$PaymentNotices extends $Notifier<PaymentOutcome?> {
  PaymentOutcome? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PaymentOutcome?, PaymentOutcome?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PaymentOutcome?, PaymentOutcome?>,
              PaymentOutcome?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Pays, and sends what is waiting.
///
/// * **Pay** records the payment in the outbox (its key made there, once),
///   then sends it once.
/// * **What is waiting** is sent, oldest first, one at a time, when someone
///   signs in (or the app opens signed in) and on Send now. After a `429`,
///   it is sent again when `Retry-After` has passed, with the same key.
/// * A payment accepted or refused refreshes Home, the stokvel and the
///   cycle, so the server's own figures replace what was on screen.
///
/// Lifetime: keepAlive, watched by the tab shell; rebuilt for whoever
/// signs in.

@ProviderFor(Payments)
final paymentsProvider = PaymentsProvider._();

/// Pays, and sends what is waiting.
///
/// * **Pay** records the payment in the outbox (its key made there, once),
///   then sends it once.
/// * **What is waiting** is sent, oldest first, one at a time, when someone
///   signs in (or the app opens signed in) and on Send now. After a `429`,
///   it is sent again when `Retry-After` has passed, with the same key.
/// * A payment accepted or refused refreshes Home, the stokvel and the
///   cycle, so the server's own figures replace what was on screen.
///
/// Lifetime: keepAlive, watched by the tab shell; rebuilt for whoever
/// signs in.
final class PaymentsProvider extends $NotifierProvider<Payments, void> {
  /// Pays, and sends what is waiting.
  ///
  /// * **Pay** records the payment in the outbox (its key made there, once),
  ///   then sends it once.
  /// * **What is waiting** is sent, oldest first, one at a time, when someone
  ///   signs in (or the app opens signed in) and on Send now. After a `429`,
  ///   it is sent again when `Retry-After` has passed, with the same key.
  /// * A payment accepted or refused refreshes Home, the stokvel and the
  ///   cycle, so the server's own figures replace what was on screen.
  ///
  /// Lifetime: keepAlive, watched by the tab shell; rebuilt for whoever
  /// signs in.
  PaymentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentsHash();

  @$internal
  @override
  Payments create() => Payments();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$paymentsHash() => r'c7e9baaf73e457c844a55a077d68129e93d484a4';

/// Pays, and sends what is waiting.
///
/// * **Pay** records the payment in the outbox (its key made there, once),
///   then sends it once.
/// * **What is waiting** is sent, oldest first, one at a time, when someone
///   signs in (or the app opens signed in) and on Send now. After a `429`,
///   it is sent again when `Retry-After` has passed, with the same key.
/// * A payment accepted or refused refreshes Home, the stokvel and the
///   cycle, so the server's own figures replace what was on screen.
///
/// Lifetime: keepAlive, watched by the tab shell; rebuilt for whoever
/// signs in.

abstract class _$Payments extends $Notifier<void> {
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
