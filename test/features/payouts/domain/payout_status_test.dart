import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_status.dart';

void main() {
  group('PayoutStatus.fromApi', () {
    test('every status the API sends maps (API PayoutStatuses, da39b16)', () {
      expect(PayoutStatus.fromApi('Paid'), PayoutStatus.paid);
      expect(PayoutStatus.fromApi('Next'), PayoutStatus.next);
      expect(PayoutStatus.fromApi('Waiting'), PayoutStatus.waiting);
    });

    test('each known status round-trips through its API spelling', () {
      for (final status in PayoutStatus.values) {
        if (status == PayoutStatus.unknown) continue;
        expect(PayoutStatus.fromApi(status.apiValue), status);
      }
    });

    test('a new status is unknown, not a crash', () {
      expect(PayoutStatus.fromApi('Skipped'), PayoutStatus.unknown);
      expect(PayoutStatus.fromApi('Deferred'), PayoutStatus.unknown);
    });

    test('the spelling is exact: case, spaces and nothing at all are '
        'unknown', () {
      for (final value in ['paid', 'NEXT', ' Waiting', 'Paid ', '', null]) {
        expect(
          PayoutStatus.fromApi(value),
          PayoutStatus.unknown,
          reason: '$value',
        );
      }
    });
  });

  group('payoutStatusLabel', () {
    test('every status has words of its own', () {
      expect(payoutStatusLabel(PayoutStatus.paid), 'Paid');
      expect(payoutStatusLabel(PayoutStatus.next), 'Next to be paid');
      expect(payoutStatusLabel(PayoutStatus.waiting), 'Waiting');
      expect(payoutStatusLabel(PayoutStatus.unknown), 'Status not recognised');
    });

    test('no two statuses read the same', () {
      final labels = PayoutStatus.values.map(payoutStatusLabel).toSet();
      expect(labels, hasLength(PayoutStatus.values.length));
    });
  });
}
