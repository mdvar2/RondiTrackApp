import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/router/routes.dart';
import 'package:ronditrack_app/features/payouts/presentation/payouts_screen.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

import '../../helpers/app_harness.dart';

const String _mabena = FakeSeed.mabenaFamilyId;
const String _mabenaCycle = FakeSeed.mabenaCycleId;
final String _payouts = const PayoutsRoute(
  id: _mabena,
  cycleId: _mabenaCycle,
).location;

/// The tab the bottom bar shows as selected.
int _selectedTab(WidgetTester tester) => tester
    .widget<NavigationBar>(find.byKey(const Key('nav-bar')))
    .selectedIndex;

void main() {
  test('the typed route spells the address of README "Routes"', () {
    expect(_payouts, '/stokvels/$_mabena/cycles/$_mabenaCycle/payouts');
  });

  testWidgets('a deep link from a cold start opens the payouts view, in the '
      'Stokvels tab', (tester) async {
    final app = await pumpApp(
      tester,
      as: FakeSeed.lerato,
      size: phone,
      coldStart: _payouts,
    );

    expect(locationOf(app), _payouts);
    expect(find.byType(PayoutsScreen), findsOneWidget);
    expect(_selectedTab(tester), 1, reason: 'the Stokvels tab');
  });

  testWidgets('back from a cold start goes to the cycle, then the stokvel, '
      'then the list', (tester) async {
    final app = await pumpApp(
      tester,
      as: FakeSeed.lerato,
      size: phone,
      coldStart: _payouts,
    );

    await pressBack(tester);
    expect(locationOf(app), '/stokvels/$_mabena/cycles/$_mabenaCycle');
    expect(find.byKey(const Key('cycle-data-$_mabenaCycle')), findsOneWidget);

    await pressBack(tester);
    expect(locationOf(app), '/stokvels/$_mabena');

    await pressBack(tester);
    expect(locationOf(app), '/stokvels');
  });

  testWidgets('a signed-out link survives sign-in and lands on the payouts '
      'view', (tester) async {
    final app = await pumpApp(tester, coldStart: _payouts);

    expect(locationOf(app), SignInRoute(from: _payouts).location);

    await typeSignIn(tester, FakeSeed.lerato.email);

    expect(locationOf(app), _payouts);
    expect(find.byType(PayoutsScreen), findsOneWidget);
  });

  testWidgets("the cycle screen's Payout order button opens it, and back "
      'returns to the cycle', (tester) async {
    final app = await pumpApp(
      tester,
      as: FakeSeed.sipho,
      size: phone,
      coldStart: '/stokvels/$_mabena/cycles/$_mabenaCycle',
    );

    final button = find.byKey(const Key('open-payouts-$_mabenaCycle'));
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(locationOf(app), _payouts);

    await pressBack(tester);
    expect(locationOf(app), '/stokvels/$_mabena/cycles/$_mabenaCycle');
  });
}
