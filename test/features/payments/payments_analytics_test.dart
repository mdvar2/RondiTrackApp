import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/observability/analytics.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/payments/domain/payment_outbox.dart';
import 'package:ronditrack_app/features/payments/presentation/payments_controller.dart';

import '../../helpers/test_database.dart';

class _SignedOutAuthController extends AuthController {
  @override
  AuthState build() => const SignedOut();
}

class _AnsweringSender implements PaymentSender {
  new(this.answer);

  final Result<void> answer;

  @override
  Future<Result<void>> send(PendingPayment payment) async => answer;
}

class _RecordingAnalytics implements Analytics {
  final events = <({String stokvelId, String memberId})>[];

  @override
  void contributionRecorded({
    required String stokvelId,
    required String memberId,
  }) {
    events.add((stokvelId: stokvelId, memberId: memberId));
  }
}

void main() {
  test(
    'a confirmed contribution emits only the stokvel and member ids',
    () async {
      final analytics = _RecordingAnalytics();
      final container = ProviderContainer.test(
        overrides: [
          inMemoryDatabase(),
          authControllerProvider.overrideWith(_SignedOutAuthController.new),
          signedInUserIdProvider.overrideWithValue('member-123'),
          paymentSenderProvider.overrideWithValue(
            _AnsweringSender(const Ok<void>(null)),
          ),
          idempotencyKeysProvider.overrideWithValue(() => 'payment-key'),
          analyticsProvider.overrideWithValue(analytics),
        ],
        retry: (retryCount, error) => null,
      );

      await container
          .read(paymentsProvider.notifier)
          .pay(
            stokvelId: 'stokvel-456',
            cycleId: 'cycle-789',
            amount: const Cents(125050),
          );

      expect(analytics.events, [
        (stokvelId: 'stokvel-456', memberId: 'member-123'),
      ]);
    },
  );

  for (final (name, answer) in [
    (
      'refused: already paid (409)',
      const Err<void>(
        RuleFailure(
          detail: 'A contribution already exists for this member and cycle.',
        ),
      ),
    ),
    ('no answer: still in the outbox', const Err<void>(NoAnswerFailure())),
  ]) {
    test('$name: no event, because nothing was recorded', () async {
      final analytics = _RecordingAnalytics();
      final container = ProviderContainer.test(
        overrides: [
          inMemoryDatabase(),
          authControllerProvider.overrideWith(_SignedOutAuthController.new),
          signedInUserIdProvider.overrideWithValue('member-123'),
          paymentSenderProvider.overrideWithValue(_AnsweringSender(answer)),
          idempotencyKeysProvider.overrideWithValue(() => 'payment-key'),
          analyticsProvider.overrideWithValue(analytics),
        ],
        retry: (retryCount, error) => null,
      );

      await container
          .read(paymentsProvider.notifier)
          .pay(
            stokvelId: 'stokvel-456',
            cycleId: 'cycle-789',
            amount: const Cents(125050),
          );

      expect(analytics.events, isEmpty);
    });
  }
}
