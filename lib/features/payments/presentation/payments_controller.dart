import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/home/presentation/home_controller.dart';
import 'package:ronditrack_app/features/payments/domain/payment_outbox.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_detail_provider.dart';

part 'payments_controller.g.dart';

/// Every payment waiting in the outbox, oldest first. Lifetime:
/// autoDispose; the outbox itself is in the database.
@riverpod
Stream<List<PendingPayment>> pendingPayments(Ref ref) =>
    ref.watch(paymentOutboxProvider).watch();

/// The last thing a payment came to, for the snack bar. Rebuilt for
/// whoever signs in.
@Riverpod(keepAlive: true)
class PaymentNotices extends _$PaymentNotices {
  @override
  PaymentOutcome? build() {
    ref.watch(signedInUserIdProvider);
    return null;
  }

  /// Shows [outcome].
  // ignore: use_setters_to_change_properties, a notifier's verb.
  void show(PaymentOutcome outcome) => state = outcome;

  /// Clears it: shown.
  void clear() => state = null;
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
@Riverpod(keepAlive: true)
class Payments extends _$Payments {
  Timer? _retry;

  @override
  void build() {
    ref
      ..onDispose(() => _retry?.cancel())
      ..listen(authControllerProvider, (previous, next) {
        if (next is SignedIn && previous is! SignedIn) {
          unawaited(sendWaiting());
        }
      }, fireImmediately: true);
  }

  /// Records the member's tap on Pay for [cycleId] of [stokvelId], then
  /// sends it once.
  Future<PaymentOutcome> pay({
    required String stokvelId,
    required String cycleId,
    required Cents amount,
  }) async {
    final userId = ref.read(signedInUserIdProvider);
    if (userId == null) throw StateError('Nobody is signed in.');
    final outbox = ref.read(paymentOutboxProvider);
    final payment = await outbox.enqueue(
      stokvelId: stokvelId,
      cycleId: cycleId,
      userId: userId,
      amount: amount,
    );
    return await _sendOne(outbox, payment);
  }

  /// The payments waiting now.
  Future<List<PendingPayment>> waiting() =>
      ref.read(paymentOutboxProvider).waiting();

  /// Sends every payment that is due, oldest first.
  Future<void> sendWaiting() async {
    final outbox = ref.read(paymentOutboxProvider);
    final waiting = await outbox.waiting();
    for (final payment in waiting) {
      if (!ref.mounted) return;
      await _sendOne(outbox, payment);
    }
  }

  Future<PaymentOutcome> _sendOne(
    PaymentOutbox outbox,
    PendingPayment payment,
  ) async {
    final outcome = await outbox.send(payment);
    if (!ref.mounted) return outcome;
    switch (outcome) {
      case PaymentAccepted() || PaymentRefused() || PaymentExpired():
        ref
          ..invalidate(homeControllerProvider)
          ..invalidate(stokvelDetailProvider(payment.stokvelId))
          ..invalidate(cycleDetailProvider(payment.stokvelId, payment.cycleId));
      case PaymentWaiting(:final wait):
        _retry?.cancel();
        _retry = Timer(wait, () => unawaited(sendWaiting()));
      case PaymentStillPending():
    }
    ref.read(paymentNoticesProvider.notifier).show(outcome);
    return outcome;
  }
}
