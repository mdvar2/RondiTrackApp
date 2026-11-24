import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/theme/app_theme.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/features/home/domain/home_entry.dart';
import 'package:ronditrack_app/features/home/presentation/home_screen.dart';
import 'package:ronditrack_app/features/stokvels/domain/membership.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';

HomeEntry _entry({
  required String id,
  required String name,
  required StokvelRole role,
  required CycleStatus status,
  required Cents paid,
  required Cents owed,
  required Cents arrears,
}) => HomeEntry(
  membership: Membership(stokvelId: id, role: role),
  stokvelName: name,
  currentCycle: HomeCycle(
    period: '2026-11',
    status: status,
    dueDate: CalendarDate(2026, 11, 30),
  ),
  amountPaid: paid,
  amountOwed: owed,
  arrears: arrears,
  nextPayoutDate: null,
);

Widget _card(HomeEntry entry) => Theme(
  data: AppTheme.light,
  child: SizedBox(width: 360, child: HomeStokvelCard(entry: entry)),
);

Future<void> main() async {
  await goldenTest(
    'Home cards show roles, balances and unknown statuses in words',
    fileName: 'home_stokvel_cards',
    builder: () => GoldenTestGroup(
      scenarioConstraints: const BoxConstraints(maxWidth: 400),
      children: [
        GoldenTestScenario(
          name: 'Treasurer with arrears',
          child: _card(
            _entry(
              id: 'mabena',
              name: 'Mabena Family',
              role: StokvelRole.treasurer,
              status: CycleStatus.open,
              paid: const Cents(50000),
              owed: const Cents(50000),
              arrears: const Cents(25000),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'Member up to date',
          child: _card(
            _entry(
              id: 'soweto',
              name: 'Soweto Teachers',
              role: StokvelRole.member,
              status: CycleStatus.closed,
              paid: const Cents(75000),
              owed: Cents.zero,
              arrears: Cents.zero,
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'Unknown role and cycle status',
          child: _card(
            _entry(
              id: 'unknown',
              name: 'Community Fund',
              role: StokvelRole.unknown,
              status: CycleStatus.unknown,
              paid: Cents.zero,
              owed: const Cents(50000),
              arrears: Cents.zero,
            ),
          ),
        ),
      ],
    ),
  );
}
