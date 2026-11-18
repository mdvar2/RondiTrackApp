import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/router/routes.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/money/rand_format.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/presentation/close_cycle_screen.dart';

import '../../helpers/app_harness.dart';

const String _mabena = FakeSeed.mabenaFamilyId;
const String _mabenaCycle = FakeSeed.mabenaCycleId;
final String _close = const CloseCycleRoute(
  id: _mabena,
  cycleId: _mabenaCycle,
).location;

void main() {
  test('the typed route spells the address of README "Routes"', () {
    expect(_close, '/stokvels/$_mabena/cycles/$_mabenaCycle/close');
  });

  testWidgets('Lerato, Treasurer of Mabena Family, sees what closing would '
      'record', (tester) async {
    await pumpApp(tester, as: FakeSeed.lerato, size: phone, coldStart: _close);

    expect(find.byKey(const Key('close-data-$_mabenaCycle')), findsOneWidget);
    expect(find.text('Sipho Dlamini'), findsOneWidget);
    expect(
      find.text(formatRand(const Cents(50000))),
      findsNWidgets(2),
      reason: 'his shortfall and the total',
    );
  });

  testWidgets('Sipho, a Member, opening it by link reads the 403 message and '
      'stays signed in', (tester) async {
    final app = await pumpApp(
      tester,
      as: FakeSeed.sipho,
      size: phone,
      coldStart: _close,
    );

    expect(find.byKey(const Key('close-failure')), findsOneWidget);
    expect(find.text(const ForbiddenFailure().message), findsOneWidget);
    expect(
      find.textContaining('find'),
      findsNothing,
      reason: 'not "not found"',
    );
    expect(app.read(authControllerProvider), isA<SignedIn>());
    expect(locationOf(app), _close, reason: 'no redirect to sign-in');
  });

  testWidgets('Thabo, not a member, gets "not found" at once, with no '
      'spinner in any frame', (tester) async {
    await pumpApp(
      tester,
      as: FakeSeed.thabo,
      size: phone,
      coldStart: _close,
      settle: false,
    );
    for (var frame = 0; frame < 30; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        find.text("We couldn't find that cycle."),
        findsOneWidget,
        reason: 'frame $frame',
      );
      expect(find.byKey(const Key('close-loading')), findsNothing);
    }
  });

  testWidgets('back from a cold start goes to the cycle', (tester) async {
    final app = await pumpApp(
      tester,
      as: FakeSeed.lerato,
      size: phone,
      coldStart: _close,
    );

    await pressBack(tester);
    expect(locationOf(app), '/stokvels/$_mabena/cycles/$_mabenaCycle');
  });

  testWidgets("the stokvel's Close cycle action opens it", (tester) async {
    final app = await pumpApp(
      tester,
      as: FakeSeed.lerato,
      size: phone,
      coldStart: '/stokvels/$_mabena',
    );

    final action = find.byKey(const Key('action-closeCycle'));
    await tester.ensureVisible(action);
    await tester.tap(action);
    await tester.pumpAndSettle();

    expect(locationOf(app), _close);
    expect(find.byType(CloseCycleScreen), findsOneWidget);
  });

  testWidgets('signed out, the link survives sign-in', (tester) async {
    final app = await pumpApp(tester, coldStart: _close);

    expect(locationOf(app), SignInRoute(from: _close).location);
    await tester.enterText(
      find.byKey(const Key('sign-in-email')),
      FakeSeed.lerato.email,
    );
    await tester.tap(find.byKey(const Key('sign-in-submit')));
    await tester.pumpAndSettle();

    expect(locationOf(app), _close);
  });
}
