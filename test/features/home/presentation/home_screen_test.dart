import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_app/features/home/domain/home_entry.dart';
import 'package:ronditrack_app/features/home/presentation/home_screen.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

import '../../../helpers/test_repositories.dart';

/// Loads a persona's Home on the real clock. Inside testWidgets the fake
/// clock only moves when the test pumps, so a plain `await` here would wait
/// forever on the fake's zero-length delay.
Future<List<HomeEntry>> _homeOf(
  WidgetTester tester,
  FakePersona persona,
) async {
  final entries = await tester.runAsync(
    () => FakeHomeRepository(
      userId: persona.id,
      delay: Duration.zero,
    ).fetchHome(),
  );
  return entries!;
}

void main() {
  testWidgets('loading: a spinner and no cards', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            ScriptedHomeRepository([Completer<List<HomeEntry>>()]),
          ),
        ],
        child: const MaterialApp(home: HomeScreen(title: 'RondiTrack Dev')),
      ),
    );

    expect(find.byKey(const Key('home-loading')), findsOneWidget);
    expect(find.byType(HomeStokvelCard), findsNothing);
  });

  testWidgets('empty: Thabo, in no stokvel, is told so and what to do next', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            FakeHomeRepository(userId: FakeSeed.thabo.id, delay: Duration.zero),
          ),
        ],
        child: const MaterialApp(home: HomeScreen(title: 'RondiTrack Dev')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-empty')), findsOneWidget);
    expect(find.text("You're not in a stokvel yet"), findsOneWidget);
    expect(find.textContaining('invite link'), findsOneWidget);
    expect(find.byType(HomeStokvelCard), findsNothing);
  });

  testWidgets('data: Lerato sees one card per stokvel, with her role there '
      'and the API figures in rands', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            FakeHomeRepository(
              userId: FakeSeed.lerato.id,
              delay: Duration.zero,
            ),
          ),
        ],
        child: const MaterialApp(home: HomeScreen(title: 'RondiTrack Dev')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HomeStokvelCard), findsNWidgets(2));

    final mabena = find.byKey(
      const Key('home-card-${FakeSeed.mabenaFamilyId}'),
    );
    expect(
      find.descendant(of: mabena, matching: find.text('Mabena Family')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: mabena, matching: find.text('Treasurer')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: mabena, matching: find.text('R 500,00')),
      findsOneWidget,
    );

    final soweto = find.byKey(
      const Key('home-card-${FakeSeed.sowetoTeachersId}'),
    );
    expect(
      find.descendant(of: soweto, matching: find.text('Member')),
      findsOneWidget,
    );
    // Paid and owed are both R 750,00 here.
    expect(
      find.descendant(of: soweto, matching: find.text('R 750,00')),
      findsNWidgets(2),
    );
    expect(
      find.descendant(of: soweto, matching: find.text('No payout scheduled')),
      findsOneWidget,
    );
  });

  testWidgets('failure: a message and a retry that works', (tester) async {
    final entries = await _homeOf(tester, FakeSeed.lerato);
    final repository = ScriptedHomeRepository([Exception('offline'), entries]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [homeRepositoryProvider.overrideWithValue(repository)],
        retry: (retryCount, error) => null,
        child: const MaterialApp(home: HomeScreen(title: 'RondiTrack Dev')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-failure')), findsOneWidget);
    expect(find.textContaining("couldn't load"), findsOneWidget);

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.byType(HomeStokvelCard), findsNWidgets(2));
    expect(repository.calls, 2);
  });

  testWidgets('pull to refresh keeps the old cards on screen while it loads', (
    tester,
  ) async {
    final entries = await _homeOf(tester, FakeSeed.lerato);
    final reload = Completer<List<HomeEntry>>();
    final repository = ScriptedHomeRepository([entries, reload]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [homeRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: HomeScreen(title: 'RondiTrack Dev')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(repository.calls, 2);
    expect(find.byKey(const Key('home-refreshing')), findsOneWidget);
    expect(find.byType(HomeStokvelCard), findsNWidgets(2));
    expect(find.byKey(const Key('home-loading')), findsNothing);

    reload.complete(entries);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-refreshing')), findsNothing);
    expect(find.byType(HomeStokvelCard), findsNWidgets(2));
  });
}
