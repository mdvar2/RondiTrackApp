import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/auth/data/last_user_store.dart';
import 'package:ronditrack_app/features/auth/domain/auth_repository.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/domain/auth_user.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_app/features/home/data/home_cache.dart';
import 'package:ronditrack_app/features/home/domain/home_entry.dart';
import 'package:ronditrack_app/features/home/domain/home_repository.dart';
import 'package:ronditrack_app/features/home/presentation/home_screen.dart';
import 'package:ronditrack_app/features/payments/domain/payment_outbox.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

import '../helpers/app_harness.dart';
import '../helpers/test_database.dart';

/// No signal: every restore and every Home fetch gets no answer.
class _Offline implements AuthRepository, HomeRepository, PaymentSender {
  @override
  Future<Result<AuthUser?>> restore() async => const Err(NoAnswerFailure());

  @override
  Future<Result<List<HomeEntry>>> fetchHome() async =>
      const Err(NoAnswerFailure());

  @override
  Future<Result<void>> send(PendingPayment payment) async =>
      const Err(NoAnswerFailure());

  @override
  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  }) async => const Err(NoAnswerFailure());

  @override
  Future<Result<AuthUser>> register({
    required String name,
    required String email,
    required String password,
  }) async => const Err(NoAnswerFailure());

  @override
  Future<void> signOut() async {}
}

final _lerato = AuthUser(
  id: FakeSeed.lerato.id,
  name: FakeSeed.lerato.name,
  email: FakeSeed.lerato.email,
);

void main() {
  testWidgets('opened with no signal, the app opens as the person last '
      'signed in, on their cached Home, with the banner and its age', (
    tester,
  ) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.runAsync(() async {
      await DriftLastUser(db).remember(_lerato);
      await HomeCache(
        db,
        FakeHomeRepository(userId: _lerato.id, delay: Duration.zero),
        clock: () => DateTime.now().subtract(const Duration(hours: 3)),
      ).refresh();
    });
    final offline = _Offline();

    final app = await pumpApp(
      tester,
      size: phone,
      database: db,
      overrides: [
        authRepositoryProvider.overrideWithValue(offline),
        homeRepositoryProvider.overrideWithValue(offline),
      ],
    );

    expect(app.read(authControllerProvider), SignedIn(_lerato));
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Mabena Family'), findsOneWidget);
    expect(
      find.text("You're offline. Showing what this phone saved 3 hours ago."),
      findsOneWidget,
    );
    expect(find.byKey(const Key('cache-banner-retry')), findsOneWidget);
  });

  testWidgets('sign-out asks first while a payment is unsent; signing out '
      'anyway empties the database', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final offline = _Offline();
    final app = await pumpApp(
      tester,
      as: FakeSeed.sipho,
      size: phone,
      coldStart:
          '/stokvels/${FakeSeed.mabenaFamilyId}/cycles/'
          '${FakeSeed.mabenaCycleId}/pay',
      database: db,
      overrides: [paymentSenderProvider.overrideWithValue(offline)],
    );

    // Pay with no signal: saved, pending.
    await tester.tap(find.byKey(const Key('pay-submit')));
    await tester.pumpAndSettle();
    expect(
      await tester.runAsync(() => app.read(paymentOutboxProvider).waiting()),
      hasLength(1),
    );

    // The outcome's snack bar times out.
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sign-out')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sign-out-pending-dialog')), findsOneWidget);

    // Cancel keeps it.
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(app.read(authControllerProvider), isA<SignedIn>());

    await tester.tap(find.byKey(const Key('sign-out')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sign-out-anyway')));
    await tester.pumpAndSettle();

    expect(app.read(authControllerProvider), const SignedOut());
    final leftOver = await tester.runAsync(() async {
      final rows = <String, int>{};
      for (final table in db.allTables) {
        rows[table.actualTableName] = (await db.select(table).get()).length;
      }
      return rows;
    });
    expect(leftOver!.values, everyElement(0), reason: '$leftOver');
  });
}
