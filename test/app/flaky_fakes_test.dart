import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/config/app_config.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_app/features/home/data/flaky_home_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/flaky_stokvel_repository.dart';

import '../helpers/result_matchers.dart';

void main() {
  group('FAKE_FAIL_EVERY is for the dev flavour only', () {
    test('dev uses the requested value', () {
      expect(fakeFailEveryFor(AppEnvironment.dev, 3), 3);
    });

    test('staging and prod never fail on purpose', () {
      expect(fakeFailEveryFor(AppEnvironment.staging, 3), 0);
      expect(fakeFailEveryFor(AppEnvironment.prod, 3), 0);
    });

    test('unset or not positive means never', () {
      expect(fakeFailEveryFor(AppEnvironment.dev, 0), 0);
      expect(fakeFailEveryFor(AppEnvironment.dev, -2), 0);
    });
  });

  group('the composition root', () {
    test('by default the repositories are the plain fakes', () {
      final container = ProviderContainer.test();

      expect(container.read(homeRepositoryProvider), isA<FakeHomeRepository>());
      expect(
        container.read(stokvelRepositoryProvider),
        isA<FakeStokvelRepository>(),
      );
    });

    test('with FAKE_FAIL_EVERY set, both are wrapped as flaky', () {
      final container = ProviderContainer.test(
        overrides: [fakeFailEveryProvider.overrideWithValue(3)],
      );

      expect(
        container.read(homeRepositoryProvider),
        isA<FlakyHomeRepository>(),
      );
      expect(
        container.read(stokvelRepositoryProvider),
        isA<FlakyStokvelRepository>(),
      );
    });
  });

  test('flaky Home fails the first call and the retry works', () async {
    final repository = FlakyHomeRepository(
      FakeHomeRepository(userId: FakeSeed.lerato.id, delay: Duration.zero),
      failEvery: 3,
    );

    expect(await repository.fetchHome(), failsWith<NoAnswerFailure>());
    expect((await repository.fetchHome()).valueOrThrow, hasLength(2));
  });

  test('flaky stokvel fails the first call and the retry works', () async {
    final repository = FlakyStokvelRepository(
      FakeStokvelRepository(userId: FakeSeed.lerato.id, delay: Duration.zero),
      failEvery: 3,
    );

    expect(
      await repository.fetchStokvel(FakeSeed.mabenaFamilyId),
      failsWith<NoAnswerFailure>(),
    );
    final detail = (await repository.fetchStokvel(FakeSeed.mabenaFamilyId))
        .valueOrThrow;
    expect(detail.stokvel.name, 'Mabena Family');
  });
}
