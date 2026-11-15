import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/dev/persona_switcher.dart';
import 'package:ronditrack_app/core/config/app_config.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

import '../../helpers/app_harness.dart';

const String _mabena = FakeSeed.mabenaFamilyId;
const String _mabenaCycle = FakeSeed.mabenaCycleId;

/// Every screen a signed-in person can be on: each tab, a stokvel, a cycle
/// and the payouts view.
const _signedInAddresses = [
  '/',
  '/stokvels',
  '/stokvels/$_mabena',
  '/stokvels/$_mabena/cycles/$_mabenaCycle',
  '/stokvels/$_mabena/cycles/$_mabenaCycle/payouts',
  '/activity',
  '/profile',
  '/join/MABENA26',
];

void main() {
  test('only the dev flavour has developer tools', () {
    expect(devConfig.hasDevTools, isTrue);
    expect(stagingConfig.hasDevTools, isFalse);
    expect(prodConfig.hasDevTools, isFalse);
    expect(
      [
        for (final config in [devConfig, stagingConfig, prodConfig])
          config.environment,
      ],
      AppEnvironment.values,
      reason: 'every flavour is checked',
    );
  });

  group('the dev build has the switcher', () {
    testWidgets('on the tab shell, listing the three seed personas', (
      tester,
    ) async {
      await pumpApp(tester, as: FakeSeed.lerato, size: phone);

      expect(find.byType(PersonaSwitcherButton), findsOneWidget);
      await tester.tap(find.byKey(const Key('persona-switcher')));
      await tester.pumpAndSettle();

      for (final persona in [FakeSeed.lerato, FakeSeed.sipho, FakeSeed.thabo]) {
        expect(find.text(persona.name), findsOneWidget, reason: persona.name);
      }
      expect(find.byIcon(Icons.check), findsOneWidget, reason: 'Lerato');
    });

    testWidgets('choosing a persona signs in as them, through the gate, and '
        'returns to the same address', (tester) async {
      final app = await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: phone,
        coldStart: '/stokvels/$_mabena',
      );
      expect(find.text('Your role: Treasurer'), findsOneWidget);

      await tester.tap(find.byKey(const Key('persona-switcher')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('persona-${FakeSeed.sipho.email}')));
      await tester.pumpAndSettle();

      expect(app.read(authControllerProvider), signedInAs(FakeSeed.sipho));
      expect(locationOf(app), '/stokvels/$_mabena');
      expect(find.text('Your role: Member'), findsOneWidget);
      expect(find.text('Your role: Treasurer'), findsNothing);
    });

    testWidgets('it works in a tablet window too (the rail layout)', (
      tester,
    ) async {
      await pumpApp(tester, as: FakeSeed.lerato, size: tabletLandscape);

      expect(find.byType(PersonaSwitcherButton), findsOneWidget);
    });

    testWidgets('the sign-in page offers the seed personas', (tester) async {
      await pumpApp(tester);

      expect(find.text('Test accounts'), findsOneWidget);
    });
  });

  for (final (flavour, config) in [
    ('staging', stagingConfig),
    ('prod', prodConfig),
  ]) {
    group('the $flavour build has no switcher: absent, not hidden', () {
      for (final address in _signedInAddresses) {
        testWidgets('at $address', (tester) async {
          await pumpApp(
            tester,
            as: FakeSeed.lerato,
            size: phone,
            config: config,
            coldStart: address,
          );

          expect(find.byType(PersonaSwitcherButton), findsNothing);
          expect(find.byKey(const Key('persona-switcher')), findsNothing);
          // Not even an invisible one: the shell builds no button at all.
          expect(find.byType(FloatingActionButton), findsNothing);
        });
      }

      testWidgets('nor on a tablet', (tester) async {
        await pumpApp(
          tester,
          as: FakeSeed.lerato,
          size: tabletLandscape,
          config: config,
        );

        expect(find.byType(PersonaSwitcherButton), findsNothing);
        expect(find.byType(FloatingActionButton), findsNothing);
      });

      testWidgets('it has no address: a link to one is not found, and lands '
          'on Home with no switcher', (tester) async {
        final app = await pumpApp(
          tester,
          as: FakeSeed.lerato,
          config: config,
          coldStart: '/dev/personas',
        );

        expect(locationOf(app), '/');
        expect(find.byType(PersonaSwitcherButton), findsNothing);
        expect(find.byKey(const Key('persona-sheet')), findsNothing);
      });

      testWidgets('the sign-in page lists no test accounts', (tester) async {
        await pumpApp(tester, config: config);

        expect(find.widgetWithText(AppBar, 'Sign in'), findsOneWidget);
        expect(find.text('Test accounts'), findsNothing);
        expect(find.text(FakeSeed.lerato.name), findsNothing);
      });

      testWidgets('signing in by typing an email still works', (tester) async {
        final app = await pumpApp(tester, config: config);

        await tester.enterText(
          find.byKey(const Key('sign-in-email')),
          FakeSeed.sipho.email,
        );
        await tester.tap(find.byKey(const Key('sign-in-submit')));
        await tester.pumpAndSettle();

        expect(app.read(authControllerProvider), isA<SignedIn>());
        expect(locationOf(app), '/');
      });
    });
  }
}
