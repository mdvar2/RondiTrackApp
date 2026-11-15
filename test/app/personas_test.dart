import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/home/presentation/home_screen.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

import '../helpers/app_harness.dart';

// The twist: one phone, three people. Lerato is Treasurer of Mabena Family
// and Member of Soweto Teachers; Sipho is a Member only; Thabo is in no
// stokvel. Each table row is one persona on one screen, with what they
// must see (README "Personas").

const String _mabena = FakeSeed.mabenaFamilyId;
const String _soweto = FakeSeed.sowetoTeachersId;
const String _mabenaCycle = FakeSeed.mabenaCycleId;
const String _sowetoCycle = FakeSeed.sowetoCycleId;

const _treasurerActions = [
  'action-confirmContributions',
  'action-closeCycle',
  'action-recordPayout',
];

Finder _key(String key) => find.byKey(Key(key));

void main() {
  group('Home, as each persona', () {
    for (final (persona, cards, roles, empty) in [
      (FakeSeed.lerato, 2, ['Treasurer', 'Member'], false),
      (FakeSeed.sipho, 2, ['Member', 'Member'], false),
      (FakeSeed.thabo, 0, <String>[], true),
    ]) {
      testWidgets(persona.name, (tester) async {
        await pumpApp(tester, as: persona, size: tabletPortrait);

        expect(find.byType(HomeStokvelCard), findsNWidgets(cards));
        final shownRoles = [
          for (final chip in tester.widgetList<Chip>(find.byType(Chip)))
            (chip.label as Text).data,
        ];
        expect(shownRoles, roles);
        expect(_key('home-empty'), empty ? findsOneWidget : findsNothing);
        if (empty) {
          // Says so, and what to do next.
          expect(find.text("You're not in a stokvel yet"), findsOneWidget);
          expect(find.textContaining('invite link'), findsOneWidget);
          expect(find.text('Refresh'), findsOneWidget);
        }
      });
    }
  });

  group('a stokvel, as each persona', () {
    for (final (persona, stokvelId, role, treasurer) in [
      (FakeSeed.lerato, _mabena, 'Treasurer', true),
      (FakeSeed.lerato, _soweto, 'Member', false),
      (FakeSeed.sipho, _mabena, 'Member', false),
      (FakeSeed.sipho, _soweto, 'Member', false),
      (FakeSeed.thabo, _mabena, null, false),
      (FakeSeed.thabo, _soweto, null, false),
    ]) {
      final where = stokvelId == _mabena ? 'Mabena Family' : 'Soweto Teachers';
      testWidgets('${persona.name} in $where: '
          '${role ?? 'not found'}', (tester) async {
        await pumpApp(
          tester,
          as: persona,
          size: tabletPortrait,
          coldStart: '/stokvels/$stokvelId',
        );

        if (role == null) {
          expect(find.text("We couldn't find that stokvel."), findsOneWidget);
          expect(find.text(where), findsNothing);
        } else {
          expect(find.text('Your role: $role'), findsOneWidget);
        }
        for (final action in _treasurerActions) {
          expect(
            _key(action),
            treasurer ? findsOneWidget : findsNothing,
            reason: action,
          );
        }
      });
    }
  });

  group('the payouts view, as each persona', () {
    for (final (persona, stokvelId, cycleId, next, record) in [
      (FakeSeed.lerato, _mabena, _mabenaCycle, 'Lerato Mokoena', true),
      (FakeSeed.lerato, _soweto, _sowetoCycle, 'Kagiso Molefe', false),
      (FakeSeed.sipho, _mabena, _mabenaCycle, 'Lerato Mokoena', false),
      (FakeSeed.sipho, _soweto, _sowetoCycle, 'Kagiso Molefe', false),
      (FakeSeed.thabo, _mabena, _mabenaCycle, null, false),
      (FakeSeed.thabo, _soweto, _sowetoCycle, null, false),
    ]) {
      final where = stokvelId == _mabena ? 'Mabena Family' : 'Soweto Teachers';
      testWidgets('${persona.name} in $where: '
          '${next == null
              ? 'not found'
              : record
              ? 'Record payout'
              : 'no '
                    'action'}', (tester) async {
        await pumpApp(
          tester,
          as: persona,
          size: tabletPortrait,
          coldStart: '/stokvels/$stokvelId/cycles/$cycleId/payouts',
        );

        if (next == null) {
          expect(find.text("We couldn't find that cycle."), findsOneWidget);
          expect(find.byKey(const Key('payout-next')), findsNothing);
        } else {
          expect(
            find.descendant(of: _key('payout-next'), matching: find.text(next)),
            findsOneWidget,
          );
        }
        expect(
          _key('action-recordPayout'),
          record ? findsOneWidget : findsNothing,
        );
      });
    }
  });

  group('Sipho sees no treasurer action anywhere', () {
    for (final address in [
      '/',
      '/stokvels',
      '/stokvels/$_mabena',
      '/stokvels/$_soweto',
      '/stokvels/$_mabena/cycles/$_mabenaCycle',
      '/stokvels/$_soweto/cycles/$_sowetoCycle',
      '/stokvels/$_mabena/cycles/$_mabenaCycle/payouts',
      '/stokvels/$_soweto/cycles/$_sowetoCycle/payouts',
      '/activity',
      '/profile',
    ]) {
      testWidgets(address, (tester) async {
        await pumpApp(
          tester,
          as: FakeSeed.sipho,
          size: tabletPortrait,
          coldStart: address,
        );

        for (final action in _treasurerActions) {
          expect(_key(action), findsNothing, reason: action);
        }
      });
    }
  });

  group('nothing of the last person survives a switch', () {
    testWidgets('Lerato to Sipho with Mabena Family open: not one frame of '
        "Lerato's actions, role or details under Sipho's name", (tester) async {
      // A real delay, so the switch passes through sign-in and loading
      // frames, as on a phone.
      final app = await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: phone,
        delay: const Duration(milliseconds: 300),
        coldStart: '/profile',
      );
      // Profile stays built, offstage, on its tab while Mabena Family is open.
      await openLink(tester, app, '/stokvels/$_mabena');
      expect(find.text('Your role: Treasurer'), findsOneWidget);
      expect(_key('action-recordPayout'), findsOneWidget);
      expect(_key('action-uploadProof'), findsOneWidget);
      expect(
        find.text(FakeSeed.lerato.email, skipOffstage: false),
        findsOneWidget,
      );

      await tester.tap(_key('persona-switcher'));
      await tester.pumpAndSettle();
      await tester.tap(_key('persona-${FakeSeed.sipho.email}'));

      var framesAsSipho = 0;
      int? signedOutAt;
      for (var frame = 0; frame < 300; frame++) {
        await tester.pump(const Duration(milliseconds: 16));
        final auth = app.read(authControllerProvider);
        if (auth != signedInAs(FakeSeed.lerato)) signedOutAt ??= frame;
        // Lerato's screen is hers until her sign-out completes. The state
        // changes during that frame's pump, and the gate redirects on the
        // next one.
        if (signedOutAt == null || frame == signedOutAt) continue;

        // From then on, signed out or signed in as Sipho: nothing that was
        // Lerato's, on screen or offstage.
        final why = 'frame $frame, ${auth.runtimeType}';
        for (final action in [..._treasurerActions, 'action-uploadProof']) {
          expect(_key(action), findsNothing, reason: '$why: $action');
        }
        expect(find.text('Your role: Treasurer'), findsNothing, reason: why);
        expect(
          find.text(FakeSeed.lerato.email, skipOffstage: false),
          findsNothing,
          reason: why,
        );
        if (auth == signedInAs(FakeSeed.sipho)) framesAsSipho++;
      }

      expect(framesAsSipho, greaterThan(0));
      expect(app.read(authControllerProvider), isA<SignedIn>());
      expect(locationOf(app), '/stokvels/$_mabena');
      expect(find.text('Your role: Member'), findsOneWidget);
      expect(_key('action-pay'), findsOneWidget);
    });

    testWidgets('the shell and every screen of the last person are disposed '
        'on the way through sign-in', (tester) async {
      final app = await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: phone,
        delay: const Duration(milliseconds: 300),
        coldStart: '/stokvels/$_mabena/cycles/$_mabenaCycle/payouts',
      );
      expect(_key('action-recordPayout'), findsOneWidget);

      await tester.tap(_key('persona-switcher'));
      await tester.pumpAndSettle();
      await tester.tap(_key('persona-${FakeSeed.thabo.email}'));

      var sawSignIn = false;
      int? signedOutAt;
      for (var frame = 0; frame < 300; frame++) {
        await tester.pump(const Duration(milliseconds: 16));
        if (app.read(authControllerProvider) is SignedOut) {
          signedOutAt ??= frame;
        }
        // As above: the frame in which sign-out completes is still hers.
        if (signedOutAt == null || frame == signedOutAt) continue;
        if (find.widgetWithText(AppBar, 'Sign in').evaluate().isNotEmpty) {
          // Sign-in never shows over the shell: by then the shell, and every
          // screen of the last person, has been disposed.
          sawSignIn = true;
          expect(find.byKey(const Key('nav-bar')), findsNothing);
          expect(find.text('Nomsa Mabena', skipOffstage: false), findsNothing);
        }
      }

      expect(sawSignIn, isTrue);
      // Thabo is in no stokvel: the remembered payouts link is "not found".
      expect(
        locationOf(app),
        '/stokvels/$_mabena/cycles/$_mabenaCycle/payouts',
      );
      expect(find.text("We couldn't find that cycle."), findsOneWidget);
      expect(_key('action-recordPayout'), findsNothing);
    });
  });
}
