import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_actions.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_detail_provider.dart';

const StokvelAction _pay = StokvelAction.pay;
const StokvelAction _proof = StokvelAction.uploadProof;
const StokvelAction _confirm = StokvelAction.confirmContributions;
const StokvelAction _close = StokvelAction.closeCycle;
const StokvelAction _payout = StokvelAction.recordPayout;

const Set<StokvelAction> _treasurer = {_confirm, _close, _payout};

void main() {
  // One test per row of allowedActions' switch.
  group('allowedActions, one case per rule', () {
    test('row 1: a cycle that is not open allows nothing', () {
      for (final cycle in [
        CycleStatus.closed,
        CycleStatus.paidOut,
        CycleStatus.unknown,
      ]) {
        expect(
          allowedActions((
            role: StokvelRole.treasurer,
            cycle: cycle,
            mine: ContributionStatus.paid,
          )),
          isEmpty,
        );
      }
    });

    test('row 2: an unknown role allows nothing, even when open', () {
      expect(
        allowedActions((
          role: StokvelRole.unknown,
          cycle: CycleStatus.open,
          mine: null,
        )),
        isEmpty,
      );
    });

    test('row 3: a member who has paid nothing may pay', () {
      expect(
        allowedActions((
          role: StokvelRole.member,
          cycle: CycleStatus.open,
          mine: null,
        )),
        {_pay},
      );
    });

    test('row 4: a member with a pending or paid contribution may pay more '
        'and upload proof', () {
      for (final mine in [
        ContributionStatus.pending,
        ContributionStatus.paid,
      ]) {
        expect(
          allowedActions((
            role: StokvelRole.member,
            cycle: CycleStatus.open,
            mine: mine,
          )),
          {_pay, _proof},
        );
      }
    });

    test('row 5: a member whose contribution is confirmed (or unknown) has '
        'nothing to do', () {
      for (final mine in [
        ContributionStatus.confirmed,
        ContributionStatus.unknown,
      ]) {
        expect(
          allowedActions((
            role: StokvelRole.member,
            cycle: CycleStatus.open,
            mine: mine,
          )),
          isEmpty,
        );
      }
    });

    test('row 6: a treasurer or chairperson who has paid nothing may pay '
        'and manage the cycle', () {
      for (final role in [StokvelRole.treasurer, StokvelRole.chairperson]) {
        expect(
          allowedActions((role: role, cycle: CycleStatus.open, mine: null)),
          {_pay, ..._treasurer},
        );
      }
    });

    test('row 7: a treasurer with a paid contribution may also upload '
        'proof', () {
      expect(
        allowedActions((
          role: StokvelRole.chairperson,
          cycle: CycleStatus.open,
          mine: ContributionStatus.pending,
        )),
        {_pay, _proof, ..._treasurer},
      );
    });

    test('row 8: a treasurer whose own contribution is confirmed only '
        'manages', () {
      expect(
        allowedActions((
          role: StokvelRole.treasurer,
          cycle: CycleStatus.open,
          mine: ContributionStatus.confirmed,
        )),
        _treasurer,
      );
    });
  });

  test('treasurer actions appear for Treasurer and Chairperson only, in '
      'every combination', () {
    for (final role in StokvelRole.values) {
      for (final cycle in CycleStatus.values) {
        for (final mine in [null, ...ContributionStatus.values]) {
          final actions = allowedActions((
            role: role,
            cycle: cycle,
            mine: mine,
          ));
          final elevated =
              role == StokvelRole.treasurer || role == StokvelRole.chairperson;
          if (!elevated || cycle != CycleStatus.open) {
            expect(actions.intersection(_treasurer), isEmpty);
          } else {
            expect(actions, containsAll(_treasurer));
          }
        }
      }
    }
  });

  group('actionsFor, from the role in this stokvel', () {
    final repository = FakeStokvelRepository(
      userId: FakeSeed.lerato.id,
      delay: Duration.zero,
    );

    test('Lerato manages Mabena Family, where she is Treasurer', () async {
      final detail = await repository.fetchStokvel(FakeSeed.mabenaFamilyId);
      expect(actionsFor(detail, FakeSeed.lerato.id), {
        _pay,
        _proof,
        ..._treasurer,
      });
    });

    test('and only pays in Soweto Teachers, where she is Member', () async {
      final detail = await repository.fetchStokvel(FakeSeed.sowetoTeachersId);
      expect(actionsFor(detail, FakeSeed.lerato.id), {_pay, _proof});
    });
  });

  test('every action has a label', () {
    expect(
      StokvelAction.values.map(stokvelActionLabel),
      everyElement(isNotEmpty),
    );
  });
}
