import 'package:flutter/foundation.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/core/money/cents.dart';

/// A payment the member tapped Pay for, waiting in the outbox. It is not
/// paid until the server says so, and is never added to any total.
@immutable
class PendingPayment {
  /// Creates the payment.
  const new({
    required this.id,
    required this.idempotencyKey,
    required this.stokvelId,
    required this.cycleId,
    required this.userId,
    required this.amount,
    required this.createdAt,
    this.attempts = 0,
    this.waitUntil,
  });

  /// The outbox row.
  final int id;

  /// Made once, at the tap; sent with every attempt.
  final String idempotencyKey;

  /// The stokvel.
  final String stokvelId;

  /// The cycle paid for.
  final String cycleId;

  /// The member paying.
  final String userId;

  /// How much.
  final Cents amount;

  /// When Pay was tapped (UTC).
  final DateTime createdAt;

  /// How many times it was sent.
  final int attempts;

  /// Not sent again before this (the API's `Retry-After`).
  final DateTime? waitUntil;

  @override
  String toString() => 'PendingPayment($id, attempts: $attempts)';
}

/// What one attempt at sending a payment came to. Each of the API's
/// answers has exactly one (README "Offline", the outbox table).
@immutable
sealed class PaymentOutcome {
  const new();
}

/// Accepted (`201`), or the stored answer to a repeat of the same key:
/// removed from the outbox.
final class PaymentAccepted extends PaymentOutcome {
  /// Creates the outcome.
  const new();
}

/// Why the API refused a payment, in a member's terms.
enum PaymentRefusal {
  /// "A contribution already exists for this member and cycle."
  alreadyPaid,

  /// "This contribution cycle is no longer open."
  cycleClosed,

  /// Anything else; [PaymentRefused.detail] has the API's words.
  other,
}

/// Refused (`400`, `403`, `404`, `409`): removed, and the member told why.
final class PaymentRefused extends PaymentOutcome {
  /// Creates the outcome.
  const new(this.reason, {this.detail});

  /// Why, in a member's terms.
  final PaymentRefusal reason;

  /// The API's words, for [PaymentRefusal.other].
  final String? detail;
}

/// Too many payments (`429`): kept, with its key, until [wait] has passed.
final class PaymentWaiting extends PaymentOutcome {
  /// Creates the outcome.
  const new(this.wait);

  /// How long, from `Retry-After`.
  final Duration wait;
}

/// No answer, or no usable one (the session, the server's fault): kept,
/// with its key. Pending, never paid.
final class PaymentStillPending extends PaymentOutcome {
  /// Creates the outcome.
  const new(this.failure);

  /// What happened to the request.
  final Failure failure;
}

/// Older than the outbox's maximum age: never sent again, because the API
/// may have forgotten its key. Removed, and the member told to check.
final class PaymentExpired extends PaymentOutcome {
  /// Creates the outcome.
  const new(this.createdAt);

  /// When Pay was tapped.
  final DateTime createdAt;
}

/// Sends one payment to the API: `POST …/members/{userId}/contributions`
/// with its `Idempotency-Key`.
abstract interface class PaymentSender {
  /// Sends [payment], with its stored key.
  Future<Result<void>> send(PendingPayment payment);
}

/// The payment outbox (README "Offline").
abstract interface class PaymentOutbox {
  /// How long a payment may wait: shorter than the API's key retention, M.
  static const maxAge = Duration(hours: 20);

  /// The API's `Housekeeping:IdempotencyRetentionHours`, M: 24 hours.
  static const apiKeyRetention = Duration(hours: 24);

  /// Every payment waiting, oldest first, now and on every change.
  Stream<List<PendingPayment>> watch();

  /// Every payment waiting now, oldest first.
  Future<List<PendingPayment>> waiting();

  /// Records the member's tap: the payment, with an `Idempotency-Key` made
  /// now, once, and stored with it.
  Future<PendingPayment> enqueue({
    required String stokvelId,
    required String cycleId,
    required String userId,
    required Cents amount,
  });

  /// Sends [payment] once, with its stored key, and acts on the answer.
  Future<PaymentOutcome> send(PendingPayment payment);

  /// Sends every payment that is due, oldest first, one at a time.
  Future<List<PaymentOutcome>> sendAll();
}
