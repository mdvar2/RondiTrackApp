import 'package:ronditrack_app/core/data/api_values.dart';
import 'package:ronditrack_app/core/data/generated/models/record_contribution_request.dart';
import 'package:ronditrack_app/core/data/generated/rondi_track_api.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/payments/domain/payment_outbox.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';

/// [PaymentSender] on the API: `POST /stokvels/{stokvelId}/members/{userId}
/// /contributions`, `{amountInCents, contributionCycleId}`, with the
/// payment's stored `Idempotency-Key`. A repeat with the same key and body
/// is answered with the stored `201`, and records nothing new.
class ApiPaymentSender implements PaymentSender {
  /// Creates the sender.
  new(this._api);

  final RondiTrackApi _api;

  @override
  Future<Result<void>> send(PendingPayment payment) => guard(
    () => _api.stokvels.postApiV1StokvelsStokvelIdMembersUserIdContributions(
      stokvelId: payment.stokvelId,
      userId: payment.userId,
      idempotencyKey: payment.idempotencyKey,
      body: RecordContributionRequest(
        amountInCents: payment.amount.value,
        contributionCycleId: payment.cycleId,
      ),
    ),
  );
}

/// [PaymentSender] over the fakes' seed, keeping keys the way the API
/// does: a repeat of a key gets the same answer and records nothing new.
class FakePaymentSender implements PaymentSender {
  /// Creates the sender over [stokvels] (the fakes' shared copy).
  new({required this.stokvels, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  /// The fakes' shared, changeable seed.
  final List<FakeStokvel> stokvels;

  final DateTime Function() _clock;

  /// Every key sent, in order (a repeat appears twice).
  final List<String> keysSent = [];

  final Map<String, Result<void>> _answers = {};

  @override
  Future<Result<void>> send(PendingPayment payment) async {
    keysSent.add(payment.idempotencyKey);
    return _answers[payment.idempotencyKey] ??= _record(payment);
  }

  Result<void> _record(PendingPayment payment) {
    final entry = stokvels
        .where((s) => s.stokvel.id == payment.stokvelId)
        .firstOrNull;
    final role = entry?.roles[payment.userId];
    if (entry == null || role == null) return const Err(NotFoundFailure());
    final cycle = entry.cycle;
    if (cycle == null || cycle.id != payment.cycleId) {
      return const Err(NotFoundFailure());
    }
    if (cycle.status != CycleStatus.open) {
      return const Err(
        RuleFailure(detail: 'This contribution cycle is no longer open.'),
      );
    }
    if (entry.contributions.any((c) => c.userId == payment.userId)) {
      return const Err(
        RuleFailure(
          detail: 'A contribution already exists for this member and cycle.',
        ),
      );
    }
    final name = FakeSeed.personas.values
        .where((p) => p.id == payment.userId)
        .map((p) => p.name)
        .firstOrNull;
    entry.contributions.add(
      Contribution(
        id: 'fake-${payment.idempotencyKey}',
        userId: payment.userId,
        memberName: name ?? 'Member',
        memberRole: role,
        amount: payment.amount,
        status: ContributionStatus.paid,
        recordedAt: _clock().toUtc(),
      ),
    );
    final figures = entry.home[payment.userId];
    if (figures != null) {
      entry.home[payment.userId] = (
        paid: figures.paid + payment.amount,
        owed: figures.owed > payment.amount
            ? figures.owed - payment.amount
            : figures.owed - figures.owed,
        arrears: figures.arrears,
      );
    }
    return const Ok(null);
  }
}
