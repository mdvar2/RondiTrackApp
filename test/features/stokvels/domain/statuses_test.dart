import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/features/stokvels/domain/status_labels.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';

void main() {
  group('CycleStatus.fromApi', () {
    test("maps the API's exact spellings", () {
      expect(CycleStatus.fromApi('Open'), CycleStatus.open);
      expect(CycleStatus.fromApi('Closed'), CycleStatus.closed);
      expect(CycleStatus.fromApi('PaidOut'), CycleStatus.paidOut);
    });

    test('a wrong case, a new status or null is unknown, never a throw', () {
      for (final value in ['open', 'OPEN', 'Paidout', 'Archived', '', null]) {
        expect(CycleStatus.fromApi(value), CycleStatus.unknown);
      }
    });
  });

  group('ContributionStatus.fromApi', () {
    test("maps the API's exact spellings", () {
      expect(ContributionStatus.fromApi('Pending'), ContributionStatus.pending);
      expect(ContributionStatus.fromApi('Paid'), ContributionStatus.paid);
      expect(
        ContributionStatus.fromApi('Confirmed'),
        ContributionStatus.confirmed,
      );
    });

    test('a wrong case, a new status or null is unknown, never a throw', () {
      for (final value in ['paid', 'Refunded', '', null]) {
        expect(ContributionStatus.fromApi(value), ContributionStatus.unknown);
      }
    });
  });

  group('StokvelRole.fromApi', () {
    test("maps the API's exact spellings", () {
      expect(StokvelRole.fromApi('Member'), StokvelRole.member);
      expect(StokvelRole.fromApi('Treasurer'), StokvelRole.treasurer);
      expect(StokvelRole.fromApi('Chairperson'), StokvelRole.chairperson);
    });

    test('a platform role, a wrong case or null is unknown', () {
      for (final value in ['treasurer', 'PlatformAdmin', 'User', '', null]) {
        expect(StokvelRole.fromApi(value), StokvelRole.unknown);
      }
    });
  });

  group('every value round-trips through its API spelling', () {
    test('CycleStatus', () {
      for (final status in CycleStatus.values) {
        expect(CycleStatus.fromApi(status.apiValue), status);
      }
    });

    test('ContributionStatus', () {
      for (final status in ContributionStatus.values) {
        expect(ContributionStatus.fromApi(status.apiValue), status);
      }
    });

    test('StokvelRole', () {
      for (final role in StokvelRole.values) {
        expect(StokvelRole.fromApi(role.apiValue), role);
      }
    });
  });

  group('labels are words for every value', () {
    test('cycle statuses', () {
      expect(cycleStatusLabel(CycleStatus.open), 'Open');
      expect(cycleStatusLabel(CycleStatus.closed), 'Closed');
      expect(cycleStatusLabel(CycleStatus.paidOut), 'Paid out');
      expect(cycleStatusLabel(CycleStatus.unknown), 'Status not recognised');
    });

    test('contribution statuses', () {
      expect(contributionStatusLabel(ContributionStatus.pending), 'Pending');
      expect(contributionStatusLabel(ContributionStatus.paid), 'Paid');
      expect(
        contributionStatusLabel(ContributionStatus.confirmed),
        'Confirmed',
      );
      expect(
        contributionStatusLabel(ContributionStatus.unknown),
        'Status not recognised',
      );
    });

    test('roles', () {
      expect(stokvelRoleLabel(StokvelRole.member), 'Member');
      expect(stokvelRoleLabel(StokvelRole.treasurer), 'Treasurer');
      expect(stokvelRoleLabel(StokvelRole.chairperson), 'Chairperson');
      expect(stokvelRoleLabel(StokvelRole.unknown), 'Role not recognised');
    });
  });
}
