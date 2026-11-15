import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/app/retry.dart';
import 'package:ronditrack_app/core/errors/not_found.dart';
import 'package:ronditrack_app/core/fakes/fail_every.dart';
import 'package:ronditrack_app/features/invites/domain/invite_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';

import '../helpers/app_harness.dart';
import '../helpers/test_repositories.dart';

const String _mabena = FakeSeed.mabenaFamilyId;
const String _mabenaCycle = FakeSeed.mabenaCycleId;

void main() {
  group('appRetry', () {
    final notFound = <NotFoundException>[
      const StokvelNotFoundException(),
      const CycleNotFoundException(),
      const InviteNotFoundException(),
    ];

    for (final error in notFound) {
      test('never retries $error', () {
        for (var count = 0; count < 3; count++) {
          expect(appRetry(count, error), isNull);
        }
      });
    }

    test('retries anything else as Riverpod would', () {
      const offline = FakeNetworkException();
      for (var count = 0; count < 12; count++) {
        expect(
          appRetry(count, offline),
          ProviderContainer.defaultRetry(count, offline),
        );
      }
      expect(appRetry(0, offline), isNotNull);
    });
  });

  // The whole app, retrying as main does. Frame by frame, not
  // pumpAndSettle, which would wait out every retry.
  group('a link to a stokvel I am not in says "not found" at once', () {
    for (final (name, address, message) in [
      ('a stokvel', '/stokvels/$_mabena', "We couldn't find that stokvel."),
      (
        'its payouts',
        '/stokvels/$_mabena/cycles/$_mabenaCycle/payouts',
        "We couldn't find that cycle.",
      ),
    ]) {
      testWidgets('$name, opened by Thabo from cold: no spinner, in any '
          'frame', (tester) async {
        await pumpApp(
          tester,
          as: FakeSeed.thabo,
          coldStart: address,
          settle: false,
        );
        for (var frame = 0; frame < 60; frame++) {
          await tester.pump(const Duration(milliseconds: 100));
          expect(find.text(message), findsOneWidget, reason: 'frame $frame');
          expect(find.byType(CircularProgressIndicator), findsNothing);
        }
      });
    }
  });

  group('"not found" is asked once, never retried', () {
    Future<ScriptedPayoutRepository> openThabosLink(
      WidgetTester tester,
      Duration? Function(int retryCount, Object error) retry,
    ) async {
      final repository = ScriptedPayoutRepository({
        _mabenaCycle: const CycleNotFoundException(),
      });
      await pumpApp(
        tester,
        as: FakeSeed.thabo,
        coldStart: '/stokvels/$_mabena/cycles/$_mabenaCycle/payouts',
        settle: false,
        retry: retry,
        overrides: [payoutRepositoryProvider.overrideWithValue(repository)],
      );
      // Twenty seconds: long enough for Riverpod's default to retry often.
      for (var second = 0; second < 20; second++) {
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.text("We couldn't find that cycle."), findsOneWidget);
      return repository;
    }

    testWidgets("with the app's retry: one request", (tester) async {
      final repository = await openThabosLink(tester, appRetry);

      expect(repository.calls, {_mabenaCycle: 1});
    });

    testWidgets("with Riverpod's default retry, the same link asks again and "
        'again: what appRetry prevents', (tester) async {
      final repository = await openThabosLink(
        tester,
        ProviderContainer.defaultRetry,
      );

      expect(repository.calls[_mabenaCycle], greaterThan(3));
      // Let the remaining retries (ten at most) run out, so no retry timer
      // outlives the test.
      for (var second = 0; second < 90; second++) {
        await tester.pump(const Duration(seconds: 1));
      }
    });
  });
}
