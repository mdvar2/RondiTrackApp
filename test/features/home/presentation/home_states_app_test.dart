import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/features/auth/data/last_user_store.dart';
import 'package:ronditrack_app/features/auth/domain/auth_user.dart';
import 'package:ronditrack_app/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_app/features/home/data/home_cache.dart';
import 'package:ronditrack_app/features/home/domain/home_entry.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/test_database.dart';
import '../../../helpers/test_repositories.dart';

/// Every state of Home, through the real app: its theme, its router and its
/// gate, with a scripted repository behind them (README "Test plan").
/// Each test finds what a person sees: words and semantics labels.
void main() {
  Future<List<HomeEntry>> homeOf(WidgetTester tester, FakePersona who) async =>
      (await tester.runAsync(
        () => FakeHomeRepository(
          userId: who.id,
          delay: Duration.zero,
        ).fetchHome(),
      ))!.valueOrThrow;

  testWidgets('loading: a spinner a screen reader calls "Loading", and no '
      'stokvel yet', (tester) async {
    final pending = Completer<List<HomeEntry>>();
    await pumpApp(
      tester,
      as: FakeSeed.lerato,
      size: phone,
      settle: false,
      overrides: [
        homeRepositoryProvider.overrideWithValue(
          ScriptedHomeRepository([pending]),
        ),
      ],
    );
    await tester.pump();

    expect(find.bySemanticsLabel('Loading'), findsOneWidget);
    expect(find.text('Mabena Family'), findsNothing);

    pending.complete(await homeOf(tester, FakeSeed.lerato));
    await tester.pumpAndSettle();
  });

  testWidgets('your stokvels: one card each, with the role you hold there', (
    tester,
  ) async {
    await pumpApp(
      tester,
      as: FakeSeed.lerato,
      size: phone,
      overrides: [
        homeRepositoryProvider.overrideWithValue(
          ScriptedHomeRepository([await homeOf(tester, FakeSeed.lerato)]),
        ),
      ],
    );

    expect(find.text('Mabena Family'), findsOneWidget);
    expect(find.text('Soweto Teachers'), findsOneWidget);
    expect(find.text('Treasurer'), findsOneWidget);
    expect(find.text('Member'), findsOneWidget);
  });

  testWidgets('none yet: says so, and what to do next', (tester) async {
    await pumpApp(
      tester,
      as: FakeSeed.thabo,
      size: phone,
      overrides: [
        homeRepositoryProvider.overrideWithValue(
          ScriptedHomeRepository([await homeOf(tester, FakeSeed.thabo)]),
        ),
      ],
    );

    expect(find.text("You're not in a stokvel yet"), findsOneWidget);
    expect(find.textContaining('Ask your stokvel'), findsOneWidget);
    expect(find.text('Refresh'), findsOneWidget);
  });

  testWidgets('a failure: in words, with its reference, and Try again that '
      'works', (tester) async {
    const reference = '0HN8B6TQ1QK3G:00000001';
    final repository = ScriptedHomeRepository([
      const ServerFailure(correlationId: reference),
      await homeOf(tester, FakeSeed.lerato),
    ]);
    await pumpApp(
      tester,
      as: FakeSeed.lerato,
      size: phone,
      retry: (_, _) => null,
      overrides: [homeRepositoryProvider.overrideWithValue(repository)],
    );

    expect(
      find.text(
        'Sorry, something went wrong on our side. If it keeps happening, '
        'quote the reference.',
      ),
      findsOneWidget,
    );
    expect(find.text('Reference'), findsOneWidget);
    expect(find.text(reference), findsOneWidget);
    expect(find.text('Mabena Family'), findsNothing);

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Mabena Family'), findsOneWidget);
    expect(repository.calls, 2);
  });

  testWidgets('offline: the cached stokvels, with how old they are and Try '
      'again', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final lerato = AuthUser(
      id: FakeSeed.lerato.id,
      name: FakeSeed.lerato.name,
      email: FakeSeed.lerato.email,
    );
    // Seeded outside the test clock: a database file is real I/O.
    await tester.runAsync(() async {
      await DriftLastUser(db).remember(lerato);
      await HomeCache(
        db,
        FakeHomeRepository(userId: lerato.id, delay: Duration.zero),
        clock: () => DateTime.now().subtract(const Duration(minutes: 5)),
      ).refresh();
    });

    await pumpApp(
      tester,
      as: FakeSeed.lerato,
      size: phone,
      database: db,
      overrides: [
        homeRepositoryProvider.overrideWithValue(
          ScriptedHomeRepository([const NoAnswerFailure()]),
        ),
      ],
    );

    expect(find.text('Mabena Family'), findsOneWidget);
    expect(
      find.text("You're offline. Showing what this phone saved 5 minutes ago."),
      findsOneWidget,
    );
    expect(find.text('Try again'), findsOneWidget);
  });

  for (final brightness in Brightness.values) {
    testWidgets('Home meets the tap-target, label and contrast guidelines '
        'in ${brightness.name} mode, through the real theme', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: phone,
        brightness: brightness,
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            ScriptedHomeRepository([await homeOf(tester, FakeSeed.lerato)]),
          ),
        ],
      );
      expect(find.text('Mabena Family'), findsOneWidget);

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      semantics.dispose();
    });
  }
}
