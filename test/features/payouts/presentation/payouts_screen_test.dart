import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/theme/app_theme.dart';
import 'package:ronditrack_app/core/theme/status_colors.dart';
import 'package:ronditrack_app/features/payouts/data/fake_payout_repository.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_order.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_repository.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_status.dart';
import 'package:ronditrack_app/features/payouts/presentation/payout_status_chip.dart';
import 'package:ronditrack_app/features/payouts/presentation/payouts_screen.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_app/l10n/generated/app_localizations.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/test_database.dart';
import '../../../helpers/test_repositories.dart';

const String _mabena = FakeSeed.mabenaFamilyId;
const String _soweto = FakeSeed.sowetoTeachersId;
const String _mabenaCycle = FakeSeed.mabenaCycleId;
const String _sowetoCycle = FakeSeed.sowetoCycleId;

/// Pumps the payouts screen alone, signed in as [persona], with the app's
/// own theme (a bare MaterialApp would leave the chips on fallbacks).
Future<void> _pumpScreen(
  WidgetTester tester, {
  required FakePersona persona,
  required String stokvelId,
  required String cycleId,
  PayoutRepository? payouts,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        inMemoryDatabase(),
        signedInUserIdProvider.overrideWithValue(persona.id),
        stokvelRepositoryProvider.overrideWithValue(
          FakeStokvelRepository(userId: persona.id, delay: Duration.zero),
        ),
        payoutRepositoryProvider.overrideWithValue(
          payouts ??
              FakePayoutRepository(userId: persona.id, delay: Duration.zero),
        ),
      ],
      retry: (retryCount, error) => null,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: PayoutsScreen(stokvelId: stokvelId, cycleId: cycleId),
      ),
    ),
  );
}

PayoutOrder _order(List<PayoutEntry> entries) =>
    PayoutOrder(stokvelId: _mabena, cycleId: _mabenaCycle, entries: entries);

PayoutEntry _entry(int position, String name, PayoutStatus status) =>
    PayoutEntry(
      position: position,
      userId: 'user-$position',
      memberName: name,
      amount: const Cents(150000),
      paidAt: null,
      status: status,
    );

void main() {
  group('every state shows', () {
    testWidgets('loading', (tester) async {
      await _pumpScreen(
        tester,
        persona: FakeSeed.lerato,
        stokvelId: _mabena,
        cycleId: _mabenaCycle,
        payouts: ScriptedPayoutRepository({
          _mabenaCycle: Completer<PayoutOrder>(),
        }),
      );
      await tester.pump();

      expect(find.byKey(const Key('payouts-loading')), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1));
    });

    testWidgets('empty: a cycle with no payout order says so, and offers a '
        'refresh', (tester) async {
      await _pumpScreen(
        tester,
        persona: FakeSeed.lerato,
        stokvelId: _mabena,
        cycleId: _mabenaCycle,
        payouts: ScriptedPayoutRepository({_mabenaCycle: _order(const [])}),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('payouts-empty')), findsOneWidget);
      expect(find.text('No payout order yet'), findsOneWidget);
      expect(find.text('Refresh'), findsOneWidget);
    });

    testWidgets('data: the order as seeded, with amounts in rands, statuses '
        'in words and the paid date', (tester) async {
      await _pumpScreen(
        tester,
        persona: FakeSeed.sipho,
        stokvelId: _mabena,
        cycleId: _mabenaCycle,
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('payouts-data-$_mabenaCycle')), findsOne);
      expect(find.text('Nomsa Mabena'), findsOneWidget);
      expect(find.text('R 1 500,00'), findsNWidgets(3));
      expect(find.text('Paid'), findsOneWidget);
      expect(find.text('Next to be paid'), findsOneWidget);
      expect(find.text('Waiting'), findsOneWidget);
      expect(find.text('Paid on 31 Oct 2026'), findsOneWidget);
    });

    testWidgets('failure: a message, and a retry that works', (tester) async {
      final repository = ScriptedPayoutRepository({
        _mabenaCycle: Exception('offline'),
      });
      await _pumpScreen(
        tester,
        persona: FakeSeed.lerato,
        stokvelId: _mabena,
        cycleId: _mabenaCycle,
        payouts: repository,
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('payouts-failure')), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);

      repository.answers[_mabenaCycle] = _order([
        _entry(1, 'Nomsa Mabena', PayoutStatus.next),
      ]);
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('payouts-data-$_mabenaCycle')), findsOne);
      expect(repository.calls[_mabenaCycle], 2);
    });

    testWidgets('not found: a cycle the person is not in', (tester) async {
      await _pumpScreen(
        tester,
        persona: FakeSeed.thabo,
        stokvelId: _mabena,
        cycleId: _mabenaCycle,
      );
      await tester.pumpAndSettle();

      expect(find.text("We couldn't find that cycle."), findsOneWidget);
      expect(find.text('Nomsa Mabena'), findsNothing);
      expect(find.byKey(const Key('action-recordPayout')), findsNothing);
    });

    testWidgets('an unknown status still shows, in words', (tester) async {
      await _pumpScreen(
        tester,
        persona: FakeSeed.lerato,
        stokvelId: _mabena,
        cycleId: _mabenaCycle,
        payouts: ScriptedPayoutRepository({
          _mabenaCycle: _order([
            _entry(1, 'Nomsa Mabena', PayoutStatus.unknown),
          ]),
        }),
      );
      await tester.pumpAndSettle();

      expect(find.text('Status not recognised'), findsOneWidget);
    });
  });

  group('shown as the API sends it', () {
    testWidgets('in the order sent, even when positions are not 1, 2, 3', (
      tester,
    ) async {
      await _pumpScreen(
        tester,
        persona: FakeSeed.lerato,
        stokvelId: _mabena,
        cycleId: _mabenaCycle,
        payouts: ScriptedPayoutRepository({
          _mabenaCycle: _order([
            _entry(3, 'Charlie', PayoutStatus.waiting),
            _entry(1, 'Alpha', PayoutStatus.waiting),
            _entry(2, 'Bravo', PayoutStatus.next),
          ]),
        }),
      );
      await tester.pumpAndSettle();

      final ys = [
        for (final name in ['Charlie', 'Alpha', 'Bravo'])
          tester.getTopLeft(find.text(name)).dy,
      ];
      expect(ys, orderedEquals([...ys]..sort()), reason: 'not re-sorted');
    });

    testWidgets('the next member is the one the API marked, highlighted', (
      tester,
    ) async {
      await _pumpScreen(
        tester,
        persona: FakeSeed.lerato,
        stokvelId: _mabena,
        cycleId: _mabenaCycle,
        payouts: ScriptedPayoutRepository({
          _mabenaCycle: _order([
            _entry(1, 'Alpha', PayoutStatus.waiting),
            _entry(2, 'Bravo', PayoutStatus.waiting),
            _entry(3, 'Charlie', PayoutStatus.next),
          ]),
        }),
      );
      await tester.pumpAndSettle();

      final next = find.byKey(const Key('payout-next'));
      expect(next, findsOneWidget);
      expect(
        find.descendant(of: next, matching: find.text('Charlie')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: next, matching: find.byIcon(Icons.arrow_forward)),
        findsOneWidget,
      );
    });
  });

  group('"Record payout" follows this stokvel\'s membership', () {
    for (final (who, persona, stokvelId, cycleId, shown) in [
      (
        'Lerato, Treasurer of Mabena Family',
        FakeSeed.lerato,
        _mabena,
        _mabenaCycle,
        true,
      ),
      (
        'Lerato, Member of Soweto Teachers',
        FakeSeed.lerato,
        _soweto,
        _sowetoCycle,
        false,
      ),
      (
        'Sipho, Member of Mabena Family',
        FakeSeed.sipho,
        _mabena,
        _mabenaCycle,
        false,
      ),
      (
        'Sipho, Member of Soweto Teachers',
        FakeSeed.sipho,
        _soweto,
        _sowetoCycle,
        false,
      ),
    ]) {
      testWidgets('$who: ${shown ? 'shown' : 'not shown'}', (tester) async {
        await _pumpScreen(
          tester,
          persona: persona,
          stokvelId: stokvelId,
          cycleId: cycleId,
        );
        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key('action-recordPayout')),
          shown ? findsOneWidget : findsNothing,
        );
      });
    }

    testWidgets('tapping it says it is coming, and records nothing', (
      tester,
    ) async {
      await _pumpScreen(
        tester,
        persona: FakeSeed.lerato,
        stokvelId: _mabena,
        cycleId: _mabenaCycle,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('action-recordPayout')));
      await tester.pump();

      expect(find.text('Record payout is coming soon.'), findsOneWidget);
    });
  });

  group('the whole app', () {
    testWidgets('360 dp with text at 200%: no overflow, every row and the '
        'action reachable', (tester) async {
      await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: phone,
        textScale: 2,
        coldStart: '/stokvels/$_mabena/cycles/$_mabenaCycle/payouts',
      );

      for (final finder in [
        find.byKey(const Key('action-recordPayout')),
        find.text('Nomsa Mabena'),
        find.byKey(const Key('payout-next')),
        find.text('Sipho Dlamini'),
      ]) {
        await tester.scrollUntilVisible(
          finder,
          150,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        expect(finder.hitTestable(), findsOneWidget);
      }
    });

    testWidgets('dark mode reads the dark tokens', (tester) async {
      await pumpApp(
        tester,
        as: FakeSeed.sipho,
        brightness: Brightness.dark,
        coldStart: '/stokvels/$_mabena/cycles/$_mabenaCycle/payouts',
      );

      final chip = find.descendant(
        of: find.byKey(const Key('payout-next')),
        matching: find.byType(PayoutStatusChip),
      );
      final box = tester.widget<DecoratedBox>(
        find.descendant(of: chip, matching: find.byType(DecoratedBox)),
      );
      final fill = (box.decoration as BoxDecoration).color;

      expect(
        fill,
        StatusColors.dark[payoutStatusToken(PayoutStatus.next)].background,
      );
      expect(
        fill,
        isNot(StatusColors.light[StatusToken.payoutNext].background),
      );
    });

    testWidgets('a link to a cycle of another stokvel is "not found"', (
      tester,
    ) async {
      await pumpApp(
        tester,
        as: FakeSeed.lerato,
        coldStart: '/stokvels/$_mabena/cycles/$_sowetoCycle/payouts',
      );

      expect(find.text("We couldn't find that cycle."), findsOneWidget);
      expect(find.text('Kagiso Molefe'), findsNothing);
    });
  });
}
