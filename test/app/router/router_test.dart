import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/home/presentation/home_screen.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

import '../../helpers/app_harness.dart';

const String _mabena = FakeSeed.mabenaFamilyId;
const String _soweto = FakeSeed.sowetoTeachersId;
const String _mabenaCycle = FakeSeed.mabenaCycleId;
const String _sowetoCycle = FakeSeed.sowetoCycleId;

Finder _tab(String label) => find.descendant(
  of: find.byKey(const Key('nav-bar')),
  matching: find.text(label),
);

const _treasurerActions = [
  'action-confirmContributions',
  'action-closeCycle',
  'action-recordPayout',
];

void main() {
  group('twist 2: a stokvel or cycle you are not in is "not found"', () {
    testWidgets('Thabo opens a link to Mabena Family: the same "not found" '
        'as a stokvel that does not exist', (tester) async {
      await pumpApp(
        tester,
        as: FakeSeed.thabo,
        coldStart: '/stokvels/$_mabena',
      );

      expect(find.text("We couldn't find that stokvel."), findsOneWidget);
      expect(find.textContaining('access'), findsNothing);
      expect(find.text('Mabena Family'), findsNothing);
      expect(find.text('Nomsa Mabena'), findsNothing);
    });

    testWidgets('a stokvel id that does not exist reads exactly the same', (
      tester,
    ) async {
      await pumpApp(
        tester,
        as: FakeSeed.thabo,
        coldStart: '/stokvels/00000000-0000-0000-0000-000000000000',
      );

      expect(find.text("We couldn't find that stokvel."), findsOneWidget);
    });

    testWidgets("Thabo opens a link to Mabena Family's cycle: not found", (
      tester,
    ) async {
      await pumpApp(
        tester,
        as: FakeSeed.thabo,
        coldStart: '/stokvels/$_mabena/cycles/$_mabenaCycle',
      );

      expect(find.text("We couldn't find that cycle."), findsOneWidget);
      expect(find.textContaining('access'), findsNothing);
      expect(find.text('Nomsa Mabena'), findsNothing);
      expect(find.text('Lerato Mokoena'), findsNothing);
    });

    testWidgets(
      'a cycle id that belongs to another stokvel is not found, even for a '
      'member of both',
      (tester) async {
        await pumpApp(
          tester,
          as: FakeSeed.lerato,
          coldStart: '/stokvels/$_mabena/cycles/$_sowetoCycle',
        );

        expect(find.text("We couldn't find that cycle."), findsOneWidget);
        expect(find.text('Kagiso Molefe'), findsNothing);
      },
    );

    testWidgets('a cycle id that does not exist reads exactly the same', (
      tester,
    ) async {
      await pumpApp(
        tester,
        as: FakeSeed.lerato,
        coldStart: '/stokvels/$_mabena/cycles/not-a-cycle',
      );

      expect(find.text("We couldn't find that cycle."), findsOneWidget);
    });
  });

  group("twist 3: Lerato's role comes from each stokvel, by address", () {
    testWidgets('Mabena Family, where she is Treasurer: treasurer actions', (
      tester,
    ) async {
      await pumpApp(
        tester,
        as: FakeSeed.lerato,
        coldStart: '/stokvels/$_mabena',
      );

      expect(find.text('Your role: Treasurer'), findsOneWidget);
      for (final action in _treasurerActions) {
        expect(find.byKey(Key(action)), findsOneWidget, reason: action);
      }
    });

    testWidgets('Soweto Teachers, where she is Member: none of them', (
      tester,
    ) async {
      await pumpApp(
        tester,
        as: FakeSeed.lerato,
        coldStart: '/stokvels/$_soweto',
      );

      expect(find.text('Your role: Member'), findsOneWidget);
      for (final action in _treasurerActions) {
        expect(find.byKey(Key(action)), findsNothing, reason: action);
      }
      expect(find.byKey(const Key('action-pay')), findsOneWidget);
    });

    testWidgets('one login, both stokvels, switching by link while running', (
      tester,
    ) async {
      final app = await pumpApp(
        tester,
        as: FakeSeed.lerato,
        coldStart: '/stokvels/$_mabena',
      );
      expect(find.byKey(const Key('action-closeCycle')), findsOneWidget);

      await openLink(tester, app, '/stokvels/$_soweto');
      expect(find.byKey(const Key('action-closeCycle')), findsNothing);

      await openLink(tester, app, '/stokvels/$_mabena');
      expect(find.byKey(const Key('action-closeCycle')), findsOneWidget);
    });
  });

  group('twist 1: /join/:code survives sign-in', () {
    testWidgets('opened signed out from cold, then signed in: lands on the '
        'invite, then joins', (tester) async {
      final app = await pumpApp(tester, coldStart: '/join/MABENA26');

      expect(locationOf(app), '/sign-in?from=%2Fjoin%2FMABENA26');
      expect(find.widgetWithText(AppBar, 'Sign in'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('sign-in-email')),
        FakeSeed.thabo.email,
      );
      await tester.tap(find.byKey(const Key('sign-in-submit')));
      await tester.pumpAndSettle();

      expect(locationOf(app), '/join/MABENA26');
      expect(find.byKey(const Key('invite-data-MABENA26')), findsOneWidget);
      expect(find.text('Mabena Family'), findsOneWidget);

      await tester.tap(find.byKey(const Key('invite-join')));
      await tester.pumpAndSettle();

      expect(locationOf(app), '/stokvels/$_mabena');
      expect(find.text('Your role: Member'), findsOneWidget);
    });

    testWidgets('opened signed out while the app runs: the same', (
      tester,
    ) async {
      final app = await pumpApp(tester);
      await openLink(tester, app, '/join/SOWETO26');
      expect(locationOf(app), '/sign-in?from=%2Fjoin%2FSOWETO26');

      await tester.enterText(
        find.byKey(const Key('sign-in-email')),
        'THABO@ronditrack.example ',
      );
      await tester.tap(find.byKey(const Key('sign-in-submit')));
      await tester.pumpAndSettle();

      expect(locationOf(app), '/join/SOWETO26');
      expect(find.byKey(const Key('invite-data-SOWETO26')), findsOneWidget);
    });

    testWidgets('a member opening the invite is offered the stokvel instead', (
      tester,
    ) async {
      await pumpApp(tester, as: FakeSeed.lerato, coldStart: '/join/MABENA26');

      expect(find.byKey(const Key('invite-open')), findsOneWidget);
      expect(find.byKey(const Key('invite-join')), findsNothing);
    });

    testWidgets('an unknown code is "not found"', (tester) async {
      await pumpApp(tester, as: FakeSeed.thabo, coldStart: '/join/NOPE');

      expect(find.text("We couldn't find that invite."), findsOneWidget);
    });

    testWidgets('a wrong email stays on sign-in and says so', (tester) async {
      final app = await pumpApp(tester, coldStart: '/join/MABENA26');

      await tester.enterText(
        find.byKey(const Key('sign-in-email')),
        'nobody@example.com',
      );
      await tester.tap(find.byKey(const Key('sign-in-submit')));
      await tester.pumpAndSettle();

      expect(find.text('No account uses that email.'), findsOneWidget);
      expect(locationOf(app), '/sign-in?from=%2Fjoin%2FMABENA26');
    });
  });

  group('tabs keep their place', () {
    testWidgets('open a cycle on Stokvels, visit Activity, come back: the '
        'cycle is still open, scrolled where it was left', (tester) async {
      final app = await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: phone,
        textScale: 1.5,
      );

      await tester.tap(_tab('Stokvels'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('stokvel-tile-$_mabena')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('open-cycle-$_mabenaCycle')));
      await tester.pumpAndSettle();
      expect(locationOf(app), '/stokvels/$_mabena/cycles/$_mabenaCycle');

      final cycleList = find.descendant(
        of: find.byKey(const Key('cycle-data-$_mabenaCycle')),
        matching: find.byType(Scrollable),
      );
      await tester.drag(cycleList, const Offset(0, -150));
      await tester.pumpAndSettle();
      final scrolled = tester.state<ScrollableState>(cycleList).position.pixels;
      expect(scrolled, greaterThan(0));

      await tester.tap(_tab('Activity'));
      await tester.pumpAndSettle();
      expect(locationOf(app), '/activity');
      expect(find.byKey(const Key('cycle-data-$_mabenaCycle')), findsNothing);

      await tester.tap(_tab('Stokvels'));
      await tester.pumpAndSettle();
      expect(locationOf(app), '/stokvels/$_mabena/cycles/$_mabenaCycle');
      expect(find.byKey(const Key('cycle-data-$_mabenaCycle')), findsOneWidget);
      expect(
        tester.state<ScrollableState>(cycleList).position.pixels,
        scrolled,
      );
    });

    testWidgets('tapping the tab you are on goes back to its first screen', (
      tester,
    ) async {
      final app = await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: phone,
        coldStart: '/stokvels/$_mabena/cycles/$_mabenaCycle',
      );

      await tester.tap(_tab('Stokvels'));
      await tester.pumpAndSettle();
      expect(locationOf(app), '/stokvels');

      // On the first screen, it does nothing.
      await tester.tap(_tab('Stokvels'));
      await tester.pumpAndSettle();
      expect(locationOf(app), '/stokvels');
    });
  });

  group('back, after a cold start', () {
    testWidgets('a cycle link: back to its stokvel, the list, then Home', (
      tester,
    ) async {
      final app = await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: phone,
        coldStart: '/stokvels/$_mabena/cycles/$_mabenaCycle',
      );
      expect(find.byKey(const Key('cycle-data-$_mabenaCycle')), findsOneWidget);

      await pressBack(tester);
      expect(locationOf(app), '/stokvels/$_mabena');
      expect(find.byKey(const Key('stokvel-data-$_mabena')), findsOneWidget);

      await pressBack(tester);
      expect(locationOf(app), '/stokvels');

      await pressBack(tester);
      expect(locationOf(app), '/');
      expect(find.byType(HomeStokvelCard), findsNWidgets(2));
    });

    testWidgets('an invite link: back to Home', (tester) async {
      final app = await pumpApp(
        tester,
        as: FakeSeed.lerato,
        coldStart: '/join/MABENA26',
      );

      await pressBack(tester);
      expect(locationOf(app), '/');
    });
  });

  group('the gate', () {
    testWidgets('a Home card opens the stokvel at its address, on the '
        'Stokvels tab; back is the list', (tester) async {
      final app = await pumpApp(tester, as: FakeSeed.lerato, size: phone);

      await tester.tap(find.byKey(const Key('home-card-$_soweto')));
      await tester.pumpAndSettle();
      expect(locationOf(app), '/stokvels/$_soweto');

      await pressBack(tester);
      expect(locationOf(app), '/stokvels');
    });

    testWidgets('signing out lands on sign-in, and back cannot return', (
      tester,
    ) async {
      final app = await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: phone,
        coldStart: '/profile',
      );
      expect(find.text(FakeSeed.lerato.email), findsOneWidget);

      await tester.tap(find.byKey(const Key('sign-out')));
      await tester.pumpAndSettle();
      expect(locationOf(app), startsWith('/sign-in'));

      await pressBack(tester);
      expect(locationOf(app), startsWith('/sign-in'));
      // Her profile is gone (the sign-in page's test accounts still name
      // her, so look for what only Profile showed).
      expect(find.text(FakeSeed.lerato.email), findsNothing);
      expect(find.byType(HomeStokvelCard), findsNothing);
    });

    testWidgets('the redirect runs again when the auth state changes, with '
        'no tap', (tester) async {
      final app = await pumpApp(
        tester,
        as: FakeSeed.lerato,
        coldStart: '/activity',
      );

      // Not awaited: the fake's delay only passes while the test pumps.
      unawaited(app.read(authControllerProvider.notifier).signOut());
      await tester.pumpAndSettle();

      expect(locationOf(app), startsWith('/sign-in'));
    });

    testWidgets('signed in as someone else, nothing of the last person '
        'remains', (tester) async {
      final app = await pumpApp(tester, as: FakeSeed.lerato, size: phone);
      expect(find.byType(HomeStokvelCard), findsNWidgets(2));

      // Not awaited: the fake's delay only passes while the test pumps.
      unawaited(app.read(authControllerProvider.notifier).signOut());
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('sign-in-email')),
        FakeSeed.thabo.email,
      );
      await tester.tap(find.byKey(const Key('sign-in-submit')));
      await tester.pumpAndSettle();
      await tester.tap(_tab('Home'));
      await tester.pumpAndSettle();

      expect(find.byType(HomeStokvelCard), findsNothing);
      expect(find.byKey(const Key('home-empty')), findsOneWidget);
    });
  });

  group('Activity', () {
    testWidgets("Lerato's feed spans both stokvels, newest first, and an "
        'item opens its cycle', (tester) async {
      final app = await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: tabletPortrait,
        coldStart: '/activity',
      );

      final items = FakeSeed.stokvels.expand((s) => s.contributions).toList()
        ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
      final tops = [
        for (final item in items)
          tester.getTopLeft(find.byKey(Key('activity-item-${item.id}'))).dy,
      ];
      expect(tops, orderedEquals([...tops]..sort()));

      await tester.tap(find.byKey(Key('activity-item-${items.first.id}')));
      await tester.pumpAndSettle();
      expect(locationOf(app), startsWith('/stokvels/'));
      expect(locationOf(app), contains('/cycles/'));
    });

    testWidgets('Thabo, in no stokvel, sees the empty state', (tester) async {
      await pumpApp(tester, as: FakeSeed.thabo, coldStart: '/activity');

      expect(find.byKey(const Key('activity-empty')), findsOneWidget);
    });
  });
}
