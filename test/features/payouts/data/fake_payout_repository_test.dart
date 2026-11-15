import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/features/payouts/data/fake_payout_repository.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_status.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';

const String _mabena = FakeSeed.mabenaFamilyId;
const String _soweto = FakeSeed.sowetoTeachersId;
const String _mabenaCycle = FakeSeed.mabenaCycleId;
const String _sowetoCycle = FakeSeed.sowetoCycleId;

FakePayoutRepository _as(String? userId) => FakePayoutRepository(
  userId: userId,
  delay: Duration.zero,
  stokvels: FakeSeed.fresh(),
);

void main() {
  group('a non-member gets "not found", exactly as the API\'s 404', () {
    for (final (stokvelId, cycleId) in [
      (_mabena, _mabenaCycle),
      (_soweto, _sowetoCycle),
    ]) {
      test('Thabo, in no stokvel, asking for $cycleId', () async {
        await expectLater(
          _as(FakeSeed.thabo.id).fetchPayoutOrder(stokvelId, cycleId),
          throwsA(isA<CycleNotFoundException>()),
        );
      });
    }

    test('nobody signed in', () async {
      await expectLater(
        _as(null).fetchPayoutOrder(_mabena, _mabenaCycle),
        throwsA(isA<CycleNotFoundException>()),
      );
    });

    test('the same for a cycle that does not exist, and for a cycle of '
        'another stokvel, even to a member of both', () async {
      final lerato = _as(FakeSeed.lerato.id);
      await expectLater(
        lerato.fetchPayoutOrder(_mabena, 'not-a-cycle'),
        throwsA(isA<CycleNotFoundException>()),
      );
      await expectLater(
        lerato.fetchPayoutOrder(_mabena, _sowetoCycle),
        throwsA(isA<CycleNotFoundException>()),
      );
      await expectLater(
        lerato.fetchPayoutOrder('no-such-stokvel', _mabenaCycle),
        throwsA(isA<CycleNotFoundException>()),
      );
    });
  });

  group('a member gets the order as seeded', () {
    test('Mabena Family: Nomsa paid, Lerato next, Sipho waiting', () async {
      final order = await _as(FakeSeed.lerato.id)
          .fetchPayoutOrder(_mabena, _mabenaCycle);

      expect(order.stokvelId, _mabena);
      expect(order.cycleId, _mabenaCycle);
      expect(order.entries, FakeSeed.payoutOrders[_mabenaCycle]);
      expect(
        [
          for (final entry in order.entries)
            (entry.position, entry.memberName, entry.status, entry.amount),
        ],
        [
          (1, 'Nomsa Mabena', PayoutStatus.paid, const Cents(150000)),
          (2, 'Lerato Mokoena', PayoutStatus.next, const Cents(150000)),
          (3, 'Sipho Dlamini', PayoutStatus.waiting, const Cents(150000)),
        ],
      );
      expect(order.entries.first.paidAt, DateTime.utc(2026, 10, 31, 15));
      expect(order.entries.skip(1).map((entry) => entry.paidAt), [null, null]);
    });

    test('Soweto Teachers, in its own order: Kagiso next, then Sipho, then '
        'Lerato', () async {
      final order = await _as(FakeSeed.sipho.id)
          .fetchPayoutOrder(_soweto, _sowetoCycle);

      expect(order.entries.map((entry) => entry.memberName), [
        'Kagiso Molefe',
        'Sipho Dlamini',
        'Lerato Mokoena',
      ]);
      expect(order.entries.map((entry) => entry.status), [
        PayoutStatus.next,
        PayoutStatus.waiting,
        PayoutStatus.waiting,
      ]);
    });

    test("the order is the stokvel's, not the caller's: Lerato and Sipho "
        'get the same answer', () async {
      final lerato = await _as(FakeSeed.lerato.id)
          .fetchPayoutOrder(_mabena, _mabenaCycle);
      final sipho = await _as(FakeSeed.sipho.id)
          .fetchPayoutOrder(_mabena, _mabenaCycle);

      expect(sipho, lerato);
    });

    test('a cycle with no order is an empty order, not "not found"', () async {
      final order = await FakePayoutRepository(
        userId: FakeSeed.lerato.id,
        delay: Duration.zero,
        orders: const {},
      ).fetchPayoutOrder(_mabena, _mabenaCycle);

      expect(order.entries, isEmpty);
    });

    test('the caller cannot change the seed through the answer', () async {
      final order = await _as(FakeSeed.lerato.id)
          .fetchPayoutOrder(_mabena, _mabenaCycle);

      expect(() => order.entries.removeLast(), throwsUnsupportedError);
    });
  });
}
