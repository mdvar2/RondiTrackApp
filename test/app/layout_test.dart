import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/theme/status_colors.dart';
import 'package:ronditrack_app/features/home/presentation/home_screen.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

import '../helpers/app_harness.dart';

const String _mabena = FakeSeed.mabenaFamilyId;
const String _mabenaCycle = FakeSeed.mabenaCycleId;

// A RenderFlex overflow is reported as an error, and a reported error fails
// a widget test, so each test below fails on an overflow stripe.
void main() {
  group('360 by 640 dp, text at 200%: no overflow, nothing out of reach', () {
    testWidgets('Home', (tester) async {
      await pumpApp(tester, as: FakeSeed.sipho, size: phone, textScale: 2);

      expect(find.byType(HomeStokvelCard), findsWidgets);
      // Sipho's Mabena card is the one with arrears, the longest card.
      await tester.scrollUntilVisible(
        find.text('In arrears'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(find.text('In arrears'));
      await tester.pumpAndSettle();
      expect(find.text('In arrears').hitTestable(), findsOneWidget);
    });

    testWidgets('the stokvel list', (tester) async {
      await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: phone,
        textScale: 2,
        coldStart: '/stokvels',
      );

      expect(
        find.byKey(const Key('stokvel-tile-$_mabena')).hitTestable(),
        findsOneWidget,
      );
    });

    testWidgets("stokvel detail, with every one of a treasurer's actions "
        'reachable', (tester) async {
      await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: phone,
        textScale: 2,
        coldStart: '/stokvels/$_mabena',
      );

      for (final action in [
        'action-pay',
        'action-uploadProof',
        'action-confirmContributions',
        'action-closeCycle',
        'action-recordPayout',
      ]) {
        final finder = find.byKey(Key(action));
        await tester.scrollUntilVisible(
          finder,
          150,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        expect(finder.hitTestable(), findsOneWidget, reason: action);
      }
    });

    for (final (name, location) in [
      ('a cycle', '/stokvels/$_mabena/cycles/$_mabenaCycle'),
      ('Activity', '/activity'),
      ('Profile', '/profile'),
      ('an invite', '/join/MABENA26'),
    ]) {
      testWidgets(name, (tester) async {
        await pumpApp(
          tester,
          as: FakeSeed.lerato,
          size: phone,
          textScale: 2,
          coldStart: location,
        );
      });
    }

    testWidgets('sign-in', (tester) async {
      await pumpApp(tester, size: phone, textScale: 2);

      await tester.scrollUntilVisible(
        find.byKey(const Key('sign-in-submit')),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(find.byKey(const Key('sign-in-submit')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('sign-in-submit')).hitTestable(),
        findsOneWidget,
      );
    });

    testWidgets('the bottom bar keeps all four labels', (tester) async {
      await pumpApp(tester, as: FakeSeed.lerato, size: phone, textScale: 2);

      for (final label in ['Home', 'Stokvels', 'Activity', 'Profile']) {
        expect(
          find.descendant(
            of: find.byKey(const Key('nav-bar')),
            matching: find.text(label),
          ),
          findsOneWidget,
        );
      }
    });
  });

  group('a tablet on its side (1280 by 800 dp)', () {
    testWidgets('list and detail side by side, on one address', (tester) async {
      final app = await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: tabletLandscape,
        coldStart: '/stokvels/$_mabena',
      );

      expect(locationOf(app), '/stokvels/$_mabena');
      expect(find.byKey(const Key('stokvels-list-detail')), findsOneWidget);
      expect(
        find.byKey(const Key('stokvel-tile-$_mabena')).hitTestable(),
        findsOneWidget,
      );
      expect(
        find
            .byKey(const Key('stokvel-tile-${FakeSeed.sowetoTeachersId}'))
            .hitTestable(),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('stokvel-data-$_mabena')).hitTestable(),
        findsOneWidget,
      );
      expect(find.byKey(const Key('nav-rail')), findsOneWidget);
      expect(find.byKey(const Key('nav-bar')), findsNothing);
    });

    testWidgets('choosing another stokvel in the list changes the address', (
      tester,
    ) async {
      final app = await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: tabletLandscape,
        coldStart: '/stokvels/$_mabena',
      );

      await tester.tap(
        find.byKey(const Key('stokvel-tile-${FakeSeed.sowetoTeachersId}')),
      );
      await tester.pumpAndSettle();

      expect(locationOf(app), '/stokvels/${FakeSeed.sowetoTeachersId}');
      expect(
        find.byKey(const Key('stokvel-data-${FakeSeed.sowetoTeachersId}')),
        findsOneWidget,
      );
    });

    testWidgets(
      'turned upright, the selected stokvel stays; back is the list',
      (tester) async {
        final app = await pumpApp(
          tester,
          as: FakeSeed.lerato,
          size: tabletLandscape,
          coldStart: '/stokvels/$_mabena',
        );

        tester.view.physicalSize = tabletPortrait;
        await tester.pumpAndSettle();

        expect(locationOf(app), '/stokvels/$_mabena');
        expect(find.byKey(const Key('stokvels-list-detail')), findsNothing);
        expect(find.byKey(const Key('stokvel-data-$_mabena')), findsOneWidget);

        await pressBack(tester);
        expect(locationOf(app), '/stokvels');
        expect(find.byKey(const Key('stokvel-tile-$_mabena')), findsOneWidget);
      },
    );

    testWidgets('/stokvels alone: the list beside an empty pane', (
      tester,
    ) async {
      await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: tabletLandscape,
        coldStart: '/stokvels',
      );

      expect(find.byKey(const Key('stokvels-none-selected')), findsOneWidget);
    });
  });

  group('breakpoints come from the window', () {
    for (final (width, rail) in [
      (360.0, false),
      (599.0, false),
      (600.0, true),
      (839.0, true),
      (840.0, true),
    ]) {
      testWidgets('$width dp wide: ${rail ? 'side rail' : 'bottom bar'}', (
        tester,
      ) async {
        await pumpApp(tester, as: FakeSeed.lerato, size: Size(width, 800));

        expect(
          find.byKey(const Key('nav-rail')),
          rail ? findsOneWidget : findsNothing,
        );
        expect(
          find.byKey(const Key('nav-bar')),
          rail ? findsNothing : findsOneWidget,
        );
      });
    }

    testWidgets('a phone on its side (medium) is one pane, not side by side', (
      tester,
    ) async {
      await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: const Size(800, 360),
        coldStart: '/stokvels/$_mabena',
      );

      expect(find.byKey(const Key('stokvels-list-detail')), findsNothing);
      expect(find.byKey(const Key('nav-rail')), findsOneWidget);
    });
  });

  testWidgets('the app follows the phone into dark mode', (tester) async {
    await pumpApp(tester, as: FakeSeed.lerato, brightness: Brightness.dark);

    final context = tester.element(find.byType(HomeStokvelCard).first);
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(StatusColors.of(context), same(StatusColors.dark));
  });
}
