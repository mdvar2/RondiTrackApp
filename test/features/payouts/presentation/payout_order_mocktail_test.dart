import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_order.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_repository.dart';
import 'package:ronditrack_app/features/payouts/presentation/payout_order_provider.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

import '../../../helpers/test_database.dart';

class _MockPayoutRepository extends Mock implements PayoutRepository;

void main() {
  test('a watched autoDispose provider fetches its data once', () async {
    final repository = _MockPayoutRepository();
    final order = PayoutOrder(
      stokvelId: FakeSeed.mabenaFamilyId,
      cycleId: FakeSeed.mabenaCycleId,
      entries: FakeSeed.payoutOrders[FakeSeed.mabenaCycleId]!,
    );
    when(
      () => repository.fetchPayoutOrder(
        FakeSeed.mabenaFamilyId,
        FakeSeed.mabenaCycleId,
      ),
    ).thenAnswer((_) async => Ok(order));
    final provider = payoutOrderProvider((
      stokvelId: FakeSeed.mabenaFamilyId,
      cycleId: FakeSeed.mabenaCycleId,
    ));
    final container = ProviderContainer.test(
      overrides: [
        inMemoryDatabase(),
        payoutRepositoryProvider.overrideWithValue(repository),
      ],
      retry: (retryCount, error) => null,
    )..listen(provider, (_, _) {});

    expect(await container.read(provider.future), same(order));
    verify(
      () => repository.fetchPayoutOrder(
        FakeSeed.mabenaFamilyId,
        FakeSeed.mabenaCycleId,
      ),
    ).called(1);
    verifyNoMoreInteractions(repository);
  });
}
