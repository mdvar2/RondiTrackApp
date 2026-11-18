import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ronditrack_app/app/router/routes.dart';
import 'package:ronditrack_app/features/activity/presentation/activity_screen.dart';
import 'package:ronditrack_app/features/auth/presentation/profile_screen.dart';
import 'package:ronditrack_app/features/auth/presentation/sign_in_screen.dart';
import 'package:ronditrack_app/features/home/presentation/home_screen.dart';
import 'package:ronditrack_app/features/invites/presentation/join_screen.dart';
import 'package:ronditrack_app/features/payouts/presentation/payouts_screen.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/presentation/close_cycle_screen.dart';
import 'package:ronditrack_app/features/stokvels/presentation/cycle_screen.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_detail_screen.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvels_screen.dart';

import '../../helpers/app_harness.dart';

const String _mabena = FakeSeed.mabenaFamilyId;
const String _mabenaCycle = FakeSeed.mabenaCycleId;

/// The addresses in README "Routes", first column, as written there.
List<String> _readmeAddresses() {
  final lines = File('README.md').readAsLinesSync();
  final start = lines.indexOf('### Routes');
  expect(start, isNot(-1), reason: 'README has a Routes section');
  final addresses = <String>[];
  for (final line in lines.skip(start + 1)) {
    if (line.startsWith('### ')) break;
    final match = RegExp(r'^\| `([^`]+)` \|').firstMatch(line);
    if (match != null) addresses.add(match.group(1)!);
  }
  return addresses;
}

/// Every full path the router knows, walked from the typed routes.
List<String> _routerAddresses() {
  final paths = <String>[];
  void walk(List<RouteBase> routes, String parent) {
    for (final route in routes) {
      switch (route) {
        case GoRoute(:final path, routes: final children):
          final full = path.startsWith('/')
              ? path
              : '${parent == '/' ? '' : parent}/$path';
          paths.add(full);
          walk(children, full);
        case StatefulShellRoute(:final branches):
          for (final branch in branches) {
            walk(branch.routes, parent);
          }
        case ShellRouteBase(routes: final children):
          walk(children, parent);
      }
    }
  }

  walk($appRoutes, '/');
  return paths;
}

/// One row of the table: a real address, who opens it, and where it must
/// land: the address, the screen, and the tab (`null`: outside the tabs).
typedef _Row = ({
  String pattern,
  String open,
  FakePersona? as,
  String lands,
  Type screen,
  int? tab,
});

const _cycle = '/stokvels/$_mabena/cycles/$_mabenaCycle';

final List<_Row> _rows = [
  (
    pattern: '/',
    open: '/',
    as: FakeSeed.lerato,
    lands: '/',
    screen: HomeScreen,
    tab: 0,
  ),
  (
    pattern: '/stokvels',
    open: '/stokvels',
    as: FakeSeed.lerato,
    lands: '/stokvels',
    screen: StokvelListScreen,
    tab: 1,
  ),
  (
    pattern: '/stokvels/:id',
    open: '/stokvels/$_mabena',
    as: FakeSeed.sipho,
    lands: '/stokvels/$_mabena',
    screen: StokvelDetailScreen,
    tab: 1,
  ),
  (
    pattern: '/stokvels/:id/cycles/:cycleId',
    open: _cycle,
    as: FakeSeed.sipho,
    lands: _cycle,
    screen: CycleScreen,
    tab: 1,
  ),
  (
    pattern: '/stokvels/:id/cycles/:cycleId/payouts',
    open: '$_cycle/payouts',
    as: FakeSeed.lerato,
    lands: '$_cycle/payouts',
    screen: PayoutsScreen,
    tab: 1,
  ),
  (
    pattern: '/stokvels/:id/cycles/:cycleId/close',
    open: '$_cycle/close',
    as: FakeSeed.lerato,
    lands: '$_cycle/close',
    screen: CloseCycleScreen,
    tab: 1,
  ),
  (
    pattern: '/activity',
    open: '/activity',
    as: FakeSeed.sipho,
    lands: '/activity',
    screen: ActivityScreen,
    tab: 2,
  ),
  (
    pattern: '/profile',
    open: '/profile',
    as: FakeSeed.thabo,
    lands: '/profile',
    screen: ProfileScreen,
    tab: 3,
  ),
  (
    pattern: '/join/:code',
    open: '/join/MABENA26',
    as: FakeSeed.thabo,
    lands: '/join/MABENA26',
    screen: JoinScreen,
    tab: 0,
  ),
  (
    pattern: '/sign-in',
    open: '/sign-in',
    as: null,
    lands: '/sign-in',
    screen: SignInScreen,
    tab: null,
  ),
];

void main() {
  test('the Routes table lists exactly the addresses the router has', () {
    expect(_readmeAddresses(), unorderedEquals(_routerAddresses()));
    expect(_routerAddresses(), hasLength(_routerAddresses().toSet().length));
  });

  test('this test opens every row of the table', () {
    expect(
      _rows.map((row) => row.pattern),
      unorderedEquals(_readmeAddresses()),
    );
  });

  for (final row in _rows) {
    testWidgets('${row.open}, as ${row.as?.name ?? 'nobody'}: lands on '
        '${row.screen}${row.tab == null ? ', outside the tabs' : ''}', (
      tester,
    ) async {
      final app = await pumpApp(
        tester,
        as: row.as,
        size: phone,
        coldStart: row.open,
      );

      expect(locationOf(app), row.lands);
      expect(find.byType(row.screen), findsOneWidget);
      final bar = find.byKey(const Key('nav-bar'));
      if (row.tab == null) {
        expect(bar, findsNothing);
      } else {
        expect(tester.widget<NavigationBar>(bar).selectedIndex, row.tab);
      }
    });
  }

  testWidgets('every tab is reachable from the shell', (tester) async {
    final app = await pumpApp(tester, as: FakeSeed.lerato, size: phone);

    for (final (label, location) in [
      ('Stokvels', '/stokvels'),
      ('Activity', '/activity'),
      ('Profile', '/profile'),
      ('Home', '/'),
    ]) {
      await tester.tap(
        find.descendant(
          of: find.byKey(const Key('nav-bar')),
          matching: find.text(label),
        ),
      );
      await tester.pumpAndSettle();
      expect(locationOf(app), location, reason: label);
    }
  });
}
