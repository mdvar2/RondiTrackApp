import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_detail_screen.dart';

import '../../../helpers/test_repositories.dart';

const _treasurerActionKeys = [
  Key('action-confirmContributions'),
  Key('action-closeCycle'),
  Key('action-recordPayout'),
];

void main() {
  const lerato = FakeSeed.lerato;

  testWidgets('loading', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          signedInUserIdProvider.overrideWithValue(lerato.id),
          homeRepositoryProvider.overrideWithValue(
            FakeHomeRepository(userId: lerato.id, delay: Duration.zero),
          ),
          stokvelRepositoryProvider.overrideWithValue(
            PendingStokvelRepository(),
          ),
        ],
        child: const MaterialApp(
          home: StokvelDetailScreen(initialStokvelId: FakeSeed.mabenaFamilyId),
        ),
      ),
    );
    await tester.pump();

    expect(
      find.byKey(const Key('stokvel-loading-${FakeSeed.mabenaFamilyId}')),
      findsOneWidget,
    );

    // Let the fake Home's zero-length delay finish before the test ends.
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('data where Lerato is Treasurer: treasurer actions show', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          signedInUserIdProvider.overrideWithValue(lerato.id),
          homeRepositoryProvider.overrideWithValue(
            FakeHomeRepository(userId: lerato.id, delay: Duration.zero),
          ),
          stokvelRepositoryProvider.overrideWithValue(
            FakeStokvelRepository(userId: lerato.id, delay: Duration.zero),
          ),
        ],
        child: const MaterialApp(
          home: StokvelDetailScreen(initialStokvelId: FakeSeed.mabenaFamilyId),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Your role: Treasurer'), findsOneWidget);
    expect(find.text('Nomsa Mabena'), findsOneWidget);
    expect(find.text('Confirmed'), findsOneWidget);
    for (final key in _treasurerActionKeys) {
      expect(find.byKey(key), findsOneWidget);
    }
    expect(find.byKey(const Key('action-pay')), findsOneWidget);
  });

  testWidgets('data where Lerato is Member: no treasurer actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          signedInUserIdProvider.overrideWithValue(lerato.id),
          homeRepositoryProvider.overrideWithValue(
            FakeHomeRepository(userId: lerato.id, delay: Duration.zero),
          ),
          stokvelRepositoryProvider.overrideWithValue(
            FakeStokvelRepository(userId: lerato.id, delay: Duration.zero),
          ),
        ],
        child: const MaterialApp(
          home: StokvelDetailScreen(
            initialStokvelId: FakeSeed.sowetoTeachersId,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Your role: Member'), findsOneWidget);
    for (final key in _treasurerActionKeys) {
      expect(find.byKey(key), findsNothing);
    }
    expect(find.byKey(const Key('action-pay')), findsOneWidget);
    expect(find.byKey(const Key('action-uploadProof')), findsOneWidget);
  });

  testWidgets('empty: a stokvel with no cycle says so', (tester) async {
    final stokvels = [
      for (final entry in FakeSeed.stokvels)
        (
          stokvel: entry.stokvel,
          roles: entry.roles,
          cycle: null,
          contributions: entry.contributions,
          home: entry.home,
        ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          signedInUserIdProvider.overrideWithValue(lerato.id),
          homeRepositoryProvider.overrideWithValue(
            FakeHomeRepository(userId: lerato.id, delay: Duration.zero),
          ),
          stokvelRepositoryProvider.overrideWithValue(
            FakeStokvelRepository(
              userId: lerato.id,
              delay: Duration.zero,
              stokvels: stokvels,
            ),
          ),
        ],
        child: const MaterialApp(
          home: StokvelDetailScreen(initialStokvelId: FakeSeed.mabenaFamilyId),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('stokvel-empty')), findsOneWidget);
    expect(find.text('No open cycle'), findsOneWidget);
  });

  testWidgets('failure: a message and a retry that works', (tester) async {
    final repository = CountingStokvelRepository(
      FakeStokvelRepository(userId: lerato.id, delay: Duration.zero),
      failures: 1,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          signedInUserIdProvider.overrideWithValue(lerato.id),
          homeRepositoryProvider.overrideWithValue(
            FakeHomeRepository(userId: lerato.id, delay: Duration.zero),
          ),
          stokvelRepositoryProvider.overrideWithValue(repository),
        ],
        retry: (retryCount, error) => null,
        child: const MaterialApp(
          home: StokvelDetailScreen(initialStokvelId: FakeSeed.mabenaFamilyId),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('stokvel-failure')), findsOneWidget);
    expect(find.textContaining("couldn't load"), findsOneWidget);

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Your role: Treasurer'), findsOneWidget);
    expect(repository.calls, {FakeSeed.mabenaFamilyId: 2});
  });

  for (final (label, stokvelId) in [
    ("a stokvel Thabo isn't in", FakeSeed.mabenaFamilyId),
    ("a stokvel that doesn't exist", '00000000-0000-0000-0000-000000000000'),
  ]) {
    testWidgets('$label shows "not found", never "no access"', (tester) async {
      final thabo = FakeSeed.thabo.id;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            signedInUserIdProvider.overrideWithValue(thabo),
            homeRepositoryProvider.overrideWithValue(
              FakeHomeRepository(userId: thabo, delay: Duration.zero),
            ),
            stokvelRepositoryProvider.overrideWithValue(
              FakeStokvelRepository(userId: thabo, delay: Duration.zero),
            ),
          ],
          retry: (retryCount, error) => null,
          child: MaterialApp(
            home: StokvelDetailScreen(initialStokvelId: stokvelId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("We couldn't find that stokvel."), findsOneWidget);
      expect(find.textContaining('access'), findsNothing);
      expect(find.text('Mabena Family'), findsNothing);
    });
  }
}
