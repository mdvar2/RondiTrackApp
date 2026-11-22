import 'package:drift/drift.dart';
import 'package:ronditrack_app/app/database.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/features/payments/domain/payment_outbox.dart';

/// The API's words for the two refusals a member can be told about in
/// their own terms (README "Contract notes › Offline, forms and lists",
/// question 2). Both are `409`; nothing else tells them apart.
const _alreadyPaid = 'A contribution already exists for this member and cycle.';
const _cycleClosed = 'This contribution cycle is no longer open.';

/// [PaymentOutbox] in the database's `payment_outbox` table.
class DriftPaymentOutbox implements PaymentOutbox {
  /// Creates the outbox. `newKey` makes an `Idempotency-Key` (a v4 UUID);
  /// it is called only by [enqueue], never by [send].
  new(
    this._db,
    this._sender, {
    required this._newKey,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final PaymentSender _sender;
  final String Function() _newKey;
  final DateTime Function() _clock;

  DateTime get _now => _clock().toUtc();

  static PendingPayment _payment(OutboxRow row) => PendingPayment(
    id: row.id,
    idempotencyKey: row.idempotencyKey,
    stokvelId: row.stokvelId,
    cycleId: row.cycleId,
    userId: row.userId,
    amount: Cents(row.amountCents),
    createdAt: row.createdAt,
    attempts: row.attempts,
    waitUntil: row.waitUntil,
  );

  @override
  Stream<List<PendingPayment>> watch() =>
      (_db.select(_db.paymentOutboxTable)
            ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
          .watch()
          .map((rows) => [for (final row in rows) _payment(row)]);

  @override
  Future<PendingPayment> enqueue({
    required String stokvelId,
    required String cycleId,
    required String userId,
    required Cents amount,
  }) async {
    final id = await _db
        .into(_db.paymentOutboxTable)
        .insert(
          PaymentOutboxTableCompanion.insert(
            // The key, made here, once, at the tap.
            idempotencyKey: _newKey(),
            stokvelId: stokvelId,
            cycleId: cycleId,
            userId: userId,
            amountCents: amount.value,
            createdAt: _now,
          ),
        );
    final row = await (_db.select(
      _db.paymentOutboxTable,
    )..where((r) => r.id.equals(id))).getSingle();
    return _payment(row);
  }

  Future<void> _remove(PendingPayment payment) => (_db.delete(
    _db.paymentOutboxTable,
  )..where((row) => row.id.equals(payment.id))).go();

  @override
  Future<PaymentOutcome> send(PendingPayment payment) async {
    if (!_now.isBefore(payment.createdAt.add(PaymentOutbox.maxAge))) {
      await _remove(payment);
      return PaymentExpired(payment.createdAt);
    }
    final waitUntil = payment.waitUntil;
    if (waitUntil != null && _now.isBefore(waitUntil)) {
      return PaymentWaiting(waitUntil.difference(_now));
    }

    await (_db.update(
      _db.paymentOutboxTable,
    )..where((row) => row.id.equals(payment.id))).write(
      PaymentOutboxTableCompanion(
        attempts: Value(payment.attempts + 1),
        waitUntil: const Value(null),
      ),
    );
    // The stored key, whatever happened before.
    final result = await _sender.send(payment);

    switch (result) {
      case Ok():
        await _remove(payment);
        return const PaymentAccepted();
      case Err(failure: RateLimitedFailure(:final wait)):
        final pause = wait ?? const Duration(seconds: 30);
        await (_db.update(
          _db.paymentOutboxTable,
        )..where((row) => row.id.equals(payment.id))).write(
          PaymentOutboxTableCompanion(waitUntil: Value(_now.add(pause))),
        );
        return PaymentWaiting(pause);
      case Err(failure: RuleFailure(:final detail)):
        await _remove(payment);
        return PaymentRefused(switch (detail) {
          _alreadyPaid => PaymentRefusal.alreadyPaid,
          _cycleClosed => PaymentRefusal.cycleClosed,
          _ => PaymentRefusal.other,
        }, detail: detail);
      case Err(
        failure: final failure &&
            (ValidationFailure() ||
                NotFoundFailure() ||
                ForbiddenFailure() ||
                ConflictFailure()),
      ):
        await _remove(payment);
        return PaymentRefused(PaymentRefusal.other, detail: failure.message);
      case Err(:final failure):
        // No answer, the server's fault, or a session that needs signing
        // in again: kept, with its key, and sent again later.
        return PaymentStillPending(failure);
    }
  }

  @override
  Future<List<PendingPayment>> waiting() async => [
    for (final row in await (_db.select(
      _db.paymentOutboxTable,
    )..orderBy([(row) => OrderingTerm.asc(row.createdAt)])).get())
      _payment(row),
  ];

  @override
  Future<List<PaymentOutcome>> sendAll() async => [
    for (final payment in await waiting()) await send(payment),
  ];
}
