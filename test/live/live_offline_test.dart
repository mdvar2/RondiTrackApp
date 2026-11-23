@Tags(['live'])
library;

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/app/retry.dart';
import 'package:ronditrack_app/core/config/app_config.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/session/refresh_token_store.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/core/time/sast.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/payments/domain/payment_outbox.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/domain/contributions_list.dart';
import 'package:uuid/uuid.dart';

import '../helpers/flavour_config.dart';
import '../helpers/test_database.dart';

// Assignment 11.3 against the real API on a fresh seed (README "Running
// against the API"), skipped unless asked for:
//
//   $env:SEED_PASSWORD = '<the seed password>'
//   flutter test --tags live --run-skipped test/live/live_offline_test.dart
//
// It signs in twice. Paying records a real contribution, so run it on a
// fresh seed.

final String _base =
    Platform.environment['LIVE_API_BASE_URL'] ?? 'http://127.0.0.1:8081';
final String _password = Platform.environment['SEED_PASSWORD'] ?? '';

Future<ProviderContainer> _signedInAs(FakePersona persona) async {
  final app = ProviderContainer(
    overrides: [
      inMemoryDatabase(),
      appConfigProvider.overrideWithValue(
        AppConfig.fromValues(
          environment: 'dev',
          appName: 'RondiTrack Dev',
          apiBaseUrl: _base,
          refreshCookieName: refreshCookieName,
          nativeFlavor: 'dev',
        ),
      ),
      refreshTokenStoreProvider.overrideWithValue(InMemoryRefreshTokenStore()),
      apiLogProvider.overrideWithValue((line) => stdout.writeln('  $line')),
    ],
    retry: appRetry,
  );
  addTearDown(app.dispose);
  await app
      .read(authControllerProvider.notifier)
      .signIn(email: persona.email, password: _password);
  expect(app.read(authControllerProvider), isA<SignedIn>());
  return app;
}

void main() {
  setUpAll(() {
    expect(_password, isNotEmpty, reason: 'Set SEED_PASSWORD');
    stdout.writeln('Live API: $_base');
  });

  test('the same payment sent twice with one key makes one '
      'contribution', () async {
    final app = await _signedInAs(FakeSeed.sipho);
    final key = const Uuid().v4();
    final payment = PendingPayment(
      id: 1,
      idempotencyKey: key,
      stokvelId: FakeSeed.mabenaFamilyId,
      cycleId: FakeSeed.mabenaCycleId,
      userId: FakeSeed.sipho.id,
      amount: const Cents(50000),
      createdAt: DateTime.now().toUtc(),
    );
    final sender = app.read(paymentSenderProvider);
    stdout.writeln('  Idempotency-Key: $key, sent twice:');

    final first = await sender.send(payment);
    final second = await sender.send(payment);

    expect(first, isA<Ok<void>>());
    expect(second, isA<Ok<void>>(), reason: 'the stored answer to a repeat');
    final page =
        (await app
                .read(contributionsRepositoryProvider)
                .fetchPage(
                  FakeSeed.mabenaFamilyId,
                  ContributionFilter(
                    cycleId: FakeSeed.mabenaCycleId,
                    userId: FakeSeed.sipho.id,
                  ),
                ))
            .valueOrThrow;
    stdout.writeln(
      "  Sipho's contributions to the cycle: ${page.items.length}",
    );
    expect(page.items, hasLength(1));
  });

  test('a stale edit is refused; and the 00:30 SAST contribution is on '
      'the 1st through the date filter', () async {
    final app = await _signedInAs(FakeSeed.lerato);
    final cycle =
        (await app
                .read(stokvelRepositoryProvider)
                .fetchCycle(FakeSeed.mabenaFamilyId, FakeSeed.mabenaCycleId))
            .valueOrThrow
            .cycle;
    final editor = app.read(stokvelEditorProvider);
    final due = cycle.dueDate!;

    final saved = await editor.updateCycle(
      stokvelId: FakeSeed.mabenaFamilyId,
      cycle: cycle,
      target: cycle.target,
      dueDate: due,
    );
    final stale = await editor.updateCycle(
      stokvelId: FakeSeed.mabenaFamilyId,
      cycle: cycle,
      target: cycle.target + const Cents(100),
      dueDate: due,
    );
    stdout
      ..writeln('  Edit with the current ETag: $saved')
      ..writeln('  Edit again with the same, now stale, ETag: $stale');
    expect(saved, isA<Ok<void>>());
    expect(stale, isA<Err<void>>());
    expect((stale as Err<void>).failure, isA<ConflictFailure>());

    // The seed records Kagiso's Soweto Teachers contribution at 00:30 SAST
    // on the 1st of this month: the day before, in UTC.
    final today = Sast.today(DateTime.now());
    final first = CalendarDate(today.year, today.month, 1);
    final page =
        (await app
                .read(contributionsRepositoryProvider)
                .fetchPage(
                  FakeSeed.sowetoTeachersId,
                  ContributionFilter(
                    cycleId: FakeSeed.sowetoCycleId,
                    firstDay: first,
                  ),
                ))
            .valueOrThrow;
    for (final c in page.items) {
      stdout.writeln(
        '  On $first (SAST): ${c.memberName}, recorded '
        '${c.recordedAt.toIso8601String()} UTC',
      );
    }
    expect(
      page.items.where((c) => Sast.dayOf(c.recordedAt) == first),
      isNotEmpty,
    );
    expect(
      page.items.any((c) => c.recordedAt.toUtc().day != first.day),
      isTrue,
      reason: 'the 00:30 contribution is still the day before in UTC',
    );
  });
}
