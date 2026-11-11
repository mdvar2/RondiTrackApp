import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';

/// A person the fakes can be signed in as.
typedef FakePersona = ({String id, String name});

/// What `/me/home` returns for one member of one stokvel. These are the
/// API's numbers, stored as data: the app never computes them.
typedef FakeHomeFigures = ({Cents paid, Cents owed, Cents arrears});

/// One stokvel as the fakes hold it.
typedef FakeStokvel = ({
  Stokvel stokvel,
  Map<String, StokvelRole> roles,
  StokvelCycle? cycle,
  List<Contribution> contributions,
  Map<String, FakeHomeFigures> home,
});

/// The three seed personas, and the stokvels they belong to.
///
/// The API repository has no seed data (its README: "There's no seed
/// data"), so these people are defined here and listed in README "Contract
/// notes", question 5. Creating them in the API is a backend change for
/// Week 11; until then the fakes and the README are the record.
abstract final class FakeSeed {
  /// Treasurer of Mabena Family and Member of Soweto Teachers: one login,
  /// two roles.
  static const FakePersona lerato = (
    id: '0b6f1a52-6a0e-4b7e-9a51-1c2f6c3e0001',
    name: 'Lerato Mokoena',
  );

  /// Member of Mabena Family (with arrears) and Chairperson of Soweto
  /// Teachers.
  static const FakePersona sipho = (
    id: '0b6f1a52-6a0e-4b7e-9a51-1c2f6c3e0002',
    name: 'Sipho Dlamini',
  );

  /// In no stokvel at all: Home's empty state.
  static const FakePersona thabo = (
    id: '0b6f1a52-6a0e-4b7e-9a51-1c2f6c3e0003',
    name: 'Thabo Nkosi',
  );

  /// The three personas, by the short name used with `FAKE_PERSONA`.
  static const Map<String, FakePersona> personas = {
    'lerato': lerato,
    'sipho': sipho,
    'thabo': thabo,
  };

  static const _nomsa = '0b6f1a52-6a0e-4b7e-9a51-1c2f6c3e0004';
  static const _kagiso = '0b6f1a52-6a0e-4b7e-9a51-1c2f6c3e0005';

  /// Mabena Family's id.
  static const mabenaFamilyId = '5d0c9a4e-2b1f-4c8a-8e7d-3a6b9f2e0101';

  /// Soweto Teachers' id.
  static const sowetoTeachersId = '5d0c9a4e-2b1f-4c8a-8e7d-3a6b9f2e0102';

  /// The stokvels, ordered by name as `/me/home` orders them.
  static final List<FakeStokvel> stokvels = [
    (
      stokvel: const Stokvel(
        id: mabenaFamilyId,
        name: 'Mabena Family',
        contributionAmount: Cents(50000),
        memberCount: 3,
      ),
      roles: {
        _nomsa: StokvelRole.chairperson,
        lerato.id: StokvelRole.treasurer,
        sipho.id: StokvelRole.member,
      },
      cycle: StokvelCycle(
        id: '9e8f7a6b-5c4d-4e3f-8a2b-1c0d9e8f0201',
        period: '2026-11',
        status: CycleStatus.open,
        dueDate: CalendarDate(2026, 11, 30),
        membersPaid: 2,
        collected: const Cents(100000),
        target: const Cents(150000),
      ),
      contributions: [
        Contribution(
          id: '7a6b5c4d-3e2f-4a1b-9c8d-7e6f5a4b0301',
          userId: lerato.id,
          memberName: lerato.name,
          memberRole: StokvelRole.treasurer,
          amount: const Cents(50000),
          status: ContributionStatus.paid,
          recordedAt: DateTime.utc(2026, 11, 5, 8, 30),
        ),
        Contribution(
          id: '7a6b5c4d-3e2f-4a1b-9c8d-7e6f5a4b0302',
          userId: _nomsa,
          memberName: 'Nomsa Mabena',
          memberRole: StokvelRole.chairperson,
          amount: const Cents(50000),
          status: ContributionStatus.confirmed,
          recordedAt: DateTime.utc(2026, 11, 2, 17, 5),
        ),
      ],
      home: {
        lerato.id: (
          paid: const Cents(50000),
          owed: Cents.zero,
          arrears: Cents.zero,
        ),
        sipho.id: (
          paid: Cents.zero,
          owed: const Cents(50000),
          arrears: const Cents(25000),
        ),
        _nomsa: (
          paid: const Cents(50000),
          owed: Cents.zero,
          arrears: Cents.zero,
        ),
      },
    ),
    (
      stokvel: const Stokvel(
        id: sowetoTeachersId,
        name: 'Soweto Teachers',
        contributionAmount: Cents(150000),
        memberCount: 3,
      ),
      roles: {
        _kagiso: StokvelRole.treasurer,
        sipho.id: StokvelRole.chairperson,
        lerato.id: StokvelRole.member,
      },
      cycle: StokvelCycle(
        id: '9e8f7a6b-5c4d-4e3f-8a2b-1c0d9e8f0202',
        period: '2026-11',
        status: CycleStatus.open,
        dueDate: CalendarDate(2026, 11, 25),
        membersPaid: 1,
        collected: const Cents(225000),
        target: const Cents(450000),
      ),
      contributions: [
        Contribution(
          id: '7a6b5c4d-3e2f-4a1b-9c8d-7e6f5a4b0303',
          userId: lerato.id,
          memberName: lerato.name,
          memberRole: StokvelRole.member,
          amount: const Cents(75000),
          status: ContributionStatus.paid,
          recordedAt: DateTime.utc(2026, 11, 6, 12),
        ),
        Contribution(
          id: '7a6b5c4d-3e2f-4a1b-9c8d-7e6f5a4b0304',
          userId: _kagiso,
          memberName: 'Kagiso Molefe',
          memberRole: StokvelRole.treasurer,
          amount: const Cents(150000),
          status: ContributionStatus.confirmed,
          recordedAt: DateTime.utc(2026, 11, 1, 9, 15),
        ),
      ],
      home: {
        lerato.id: (
          paid: const Cents(75000),
          owed: const Cents(75000),
          arrears: Cents.zero,
        ),
        sipho.id: (
          paid: Cents.zero,
          owed: const Cents(150000),
          arrears: Cents.zero,
        ),
        _kagiso: (
          paid: const Cents(150000),
          owed: Cents.zero,
          arrears: Cents.zero,
        ),
      },
    ),
  ];
}
