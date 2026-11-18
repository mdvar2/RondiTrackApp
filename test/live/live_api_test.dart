@Tags(['live'])
library;

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/app/retry.dart';
import 'package:ronditrack_app/core/config/app_config.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/home/presentation/home_controller.dart';
import 'package:ronditrack_app/features/payouts/presentation/payout_order_provider.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';
import 'package:ronditrack_app/features/stokvels/presentation/close_cycle_provider.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_detail_provider.dart';

// The app's own providers against the real API on a fresh seed (README
// "Running against the API"). Skipped unless asked for:
//
//   $env:SEED_PASSWORD = '<the seed password>'
//   flutter test --tags live --run-skipped
//
// LIVE_API_BASE_URL overrides the address (default: config/dev.json's).
// It signs in three times; the API allows five sign-ins a minute per IP.

final String _base =
    Platform.environment['LIVE_API_BASE_URL'] ?? 'http://127.0.0.1:8081';
final String _password = Platform.environment['SEED_PASSWORD'] ?? '';

ProviderContainer _app({String? base}) {
  final container = ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(
        AppConfig.fromValues(
          environment: 'dev',
          appName: 'RondiTrack Dev',
          apiBaseUrl: base ?? _base,
          nativeFlavor: 'dev',
        ),
      ),
      seedPasswordProvider.overrideWithValue(_password),
      // The app's own log lines, printed for the pull request.
      apiLogProvider.overrideWithValue((line) => stdout.writeln('  $line')),
    ],
    retry: appRetry,
  );
  addTearDown(container.dispose);
  return container;
}

Future<ProviderContainer> _signedInAs(FakePersona persona) async {
  final app = _app();
  await app.read(authControllerProvider.notifier).signIn(persona.email);
  expect(app.read(authControllerProvider), isA<SignedIn>());
  return app;
}

/// What [future] failed with: the Failure a provider holds.
Future<Failure> _failureOf(Future<Object?> future) async {
  try {
    await future;
  } on Failure catch (failure) {
    return failure;
  }
  fail('Expected a failure');
}

void main() {
  setUpAll(() {
    expect(
      _password,
      isNotEmpty,
      reason: 'Set SEED_PASSWORD to the API seed password',
    );
    stdout.writeln('Live API: $_base');
  });

  test("Lerato's Home: Treasurer of one stokvel, Member of the other, and "
      'treasurer actions only in the first', () async {
    final app = await _signedInAs(FakeSeed.lerato);

    final home = await app.read(homeControllerProvider.future);
    for (final entry in home) {
      final cycle = entry.currentCycle;
      stdout.writeln(
        '  Lerato: ${entry.stokvelName} as ${entry.membership.role.name}, '
        'cycle ${cycle?.period} ${cycle?.status.name}',
      );
    }
    expect(home.map((e) => (e.stokvelName, e.membership.role)), [
      ('Mabena Family', StokvelRole.treasurer),
      ('Soweto Teachers', StokvelRole.member),
    ]);

    final userId = app.read(signedInUserIdProvider);
    final mabena = await app.read(
      stokvelDetailProvider(FakeSeed.mabenaFamilyId).future,
    );
    final soweto = await app.read(
      stokvelDetailProvider(FakeSeed.sowetoTeachersId).future,
    );
    final mabenaActions = actionsFor(mabena, userId).map((a) => a.name);
    final sowetoActions = actionsFor(soweto, userId).map((a) => a.name);
    stdout
      ..writeln('  Lerato in Mabena Family may: ${mabenaActions.join(', ')}')
      ..writeln('  Lerato in Soweto Teachers may: ${sowetoActions.join(', ')}');
    expect(mabenaActions, contains('closeCycle'));
    expect(sowetoActions, isNot(contains('closeCycle')));
    expect(mabena.stokvel.concurrencyToken, isNotNull, reason: 'the ETag');

    final order = await app.read(
      payoutOrderProvider((
        stokvelId: FakeSeed.mabenaFamilyId,
        cycleId: mabena.currentCycle!.id,
      )).future,
    );
    final rotation = [
      for (final e in order.entries) '${e.memberName} ${e.status.name}',
    ];
    stdout.writeln('  Mabena Family payout order: ${rotation.join(', ')}');
  });

  test("Sipho's Home, and a treasurer action is the API's 403: forbidden, "
      'and he stays signed in', () async {
    final app = await _signedInAs(FakeSeed.sipho);

    final home = await app.read(homeControllerProvider.future);
    final cards = [
      for (final e in home) '${e.stokvelName} as ${e.membership.role.name}',
    ];
    stdout.writeln('  Sipho: ${cards.join('; ')}');
    expect(home.map((e) => e.membership.role).toSet(), {StokvelRole.member});

    final failure = await _failureOf(
      app.read(
        closePreviewProvider(
          FakeSeed.mabenaFamilyId,
          FakeSeed.mabenaCycleId,
        ).future,
      ),
    );
    stdout.writeln('  Sipho opening Close cycle: $failure: ${failure.message}');
    expect(failure, isA<ForbiddenFailure>());
    expect(app.read(authControllerProvider), isA<SignedIn>());
  });

  test("Thabo's empty Home, and a stokvel he isn't in is the API's 404: not "
      'found, like one that does not exist', () async {
    final app = await _signedInAs(FakeSeed.thabo);

    final home = await app.read(homeControllerProvider.future);
    stdout.writeln('  Thabo: ${home.length} stokvels');
    expect(home, isEmpty);

    final notMine = await _failureOf(
      app.read(stokvelDetailProvider(FakeSeed.mabenaFamilyId).future),
    );
    final noSuch = await _failureOf(
      app.read(
        stokvelDetailProvider('00000000-0000-0000-0000-000000000000').future,
      ),
    );
    stdout
      ..writeln('  Thabo opening Mabena Family: $notMine')
      ..writeln('  Thabo opening a stokvel that does not exist: $noSuch');
    expect(notMine, isA<NotFoundFailure>());
    expect(noSuch, isA<NotFoundFailure>());
  });

  test('a wrong address is no answer', () async {
    // A port nothing listens on.
    final app = _app(base: 'http://127.0.0.1:9');

    final failure = await _failureOf(
      app.read(authControllerProvider.notifier).signIn(FakeSeed.lerato.email),
    );
    stdout.writeln('  Wrong address: $failure: ${failure.message}');
    expect(failure, isA<NoAnswerFailure>());
  });
}
