import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/logging/lifecycle_log.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_detail_provider.dart';

import '../../../helpers/test_repositories.dart';

void main() {
  const mabena = FakeSeed.mabenaFamilyId;
  const soweto = FakeSeed.sowetoTeachersId;

  late CountingStokvelRepository repository;
  late List<String> log;
  late ProviderContainer container;

  // A fresh container for every test.
  setUp(() {
    repository = CountingStokvelRepository(
      FakeStokvelRepository(userId: FakeSeed.lerato.id, delay: Duration.zero),
    );
    log = [];
    container = ProviderContainer.test(
      overrides: [
        stokvelRepositoryProvider.overrideWithValue(repository),
        lifecycleLogProvider.overrideWithValue(log.add),
      ],
      retry: (retryCount, error) => null,
    );
  });

  test('two ids keep separate state', () async {
    container
      ..listen(stokvelDetailProvider(mabena), (_, _) {})
      ..listen(stokvelDetailProvider(soweto), (_, _) {});

    final a = await container.read(stokvelDetailProvider(mabena).future);
    final b = await container.read(stokvelDetailProvider(soweto).future);

    expect(a.stokvel.name, 'Mabena Family');
    expect(b.stokvel.name, 'Soweto Teachers');

    // Refreshing one leaves the other alone.
    container.invalidate(stokvelDetailProvider(mabena));
    expect(container.read(stokvelDetailProvider(mabena)).isLoading, isTrue);
    expect(container.read(stokvelDetailProvider(soweto)).value, b);
  });

  test('two listeners on one id share one fetch', () async {
    container
      ..listen(stokvelDetailProvider(mabena), (_, _) {})
      ..listen(stokvelDetailProvider(mabena), (_, _) {});

    await container.read(stokvelDetailProvider(mabena).future);

    expect(repository.calls, {mabena: 1});
  });

  test("a stokvel's detail is disposed when nothing watches it, and the "
      'log names only its id', () async {
    final subscription = container.listen(
      stokvelDetailProvider(mabena),
      (_, _) {},
    );
    await container.read(stokvelDetailProvider(mabena).future);
    expect(container.exists(stokvelDetailProvider(mabena)), isTrue);

    subscription.close();
    await container.pump();

    expect(container.exists(stokvelDetailProvider(mabena)), isFalse);
    expect(log, [
      'stokvelDetail created id=$mabena',
      'stokvelDetail disposed id=$mabena',
    ]);
    for (final line in log) {
      expect(line, isNot(contains('Mabena Family')));
      expect(line, isNot(contains('R ')));
    }

    // Watching it again is a refetch.
    container.listen(stokvelDetailProvider(mabena), (_, _) {});
    await container.read(stokvelDetailProvider(mabena).future);
    expect(repository.calls, {mabena: 2});
  });
}
