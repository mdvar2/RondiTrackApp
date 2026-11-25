import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
// alchemist doesn't export flutter_test.
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/theme/app_theme.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/features/home/domain/home_entry.dart';
import 'package:ronditrack_app/features/home/presentation/home_screen.dart';
import 'package:ronditrack_app/features/stokvels/domain/membership.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';

HomeEntry _entry({
  required StokvelRole role,
  required CycleStatus status,
  required Cents arrears,
  String name = 'Mabena Family',
}) => HomeEntry(
  membership: Membership(stokvelId: 'stokvel', role: role),
  stokvelName: name,
  currentCycle: HomeCycle(
    period: '2026-11',
    status: status,
    dueDate: CalendarDate(2026, 11, 30),
  ),
  amountPaid: arrears > Cents.zero ? const Cents(25000) : const Cents(50000),
  amountOwed: arrears > Cents.zero ? const Cents(25000) : Cents.zero,
  arrears: arrears,
  nextPayoutDate: null,
);

/// The cases that change how the card looks (README "Test plan").
final _cases = <String, HomeEntry>{
  'Treasurer, in arrears': _entry(
    role: StokvelRole.treasurer,
    status: CycleStatus.open,
    arrears: const Cents(25000),
  ),
  'Treasurer, up to date': _entry(
    role: StokvelRole.treasurer,
    status: CycleStatus.open,
    arrears: Cents.zero,
  ),
  'Member, in arrears': _entry(
    role: StokvelRole.member,
    status: CycleStatus.open,
    arrears: const Cents(25000),
  ),
  'Member, up to date': _entry(
    role: StokvelRole.member,
    status: CycleStatus.closed,
    arrears: Cents.zero,
  ),
  'A status the app does not recognise': _entry(
    name: 'Community Fund',
    role: StokvelRole.unknown,
    status: CycleStatus.unknown,
    arrears: Cents.zero,
  ),
};

/// The card alone: no screen, no provider, no router. Each card gets its
/// own theme (and the theme's surface behind it), so alchemist's labels
/// outside it stay readable in the dark group.
Widget _card(HomeEntry entry, ThemeData theme) => Theme(
  data: theme,
  child: ColoredBox(
    color: theme.colorScheme.surface,
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(width: 360, child: HomeStokvelCard(entry: entry)),
    ),
  ),
);

Future<void> main() async {
  group('the stokvel card', () {
    for (final (mode, theme) in [
      ('light', AppTheme.light),
      ('dark', AppTheme.dark),
    ]) {
      // ignore: discarded_futures, goldenTest registers the test and returns.
      goldenTest(
        'every case that changes how it looks, $mode',
        fileName: 'home_stokvel_card_$mode',
        builder: () => GoldenTestGroup(
          columns: 1,
          scenarioConstraints: const BoxConstraints(maxWidth: 380),
          children: [
            for (final MapEntry(key: name, value: entry) in _cases.entries)
              GoldenTestScenario(name: name, child: _card(entry, theme)),
          ],
        ),
      );
    }
  });
}
