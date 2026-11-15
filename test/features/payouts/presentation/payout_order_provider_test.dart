import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/fakes/fail_every.dart';
import 'package:ronditrack_app/core/logging/lifecycle_log.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_order.dart';
import 'package:ronditrack_app/features/payouts/presentation/payout_order_provider.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';

import '../../../helpers/test_repositories.dart';

const CycleKey _mabena = (
  stokvelId: FakeSeed.mabenaFamilyId,
  cycleId: FakeSeed.mabenaCycleId,
);
const CycleKey _soweto = (
  stokvelId: FakeSeed.sowetoTeachersId,
  cycleId: FakeSeed.sowetoCycleId,
);

PayoutOrder _seeded(CycleKey key) => PayoutOrder(
  stokvelId: key.stokvelId,
  cycleId: key.cycleId,
  entries: FakeSeed.payoutOrders[key.cycleId]!,
);

PayoutOrder _empty(CycleKey key) =>
    PayoutOrder(stokvelId: key.stokvelId, cycleId: key.cycleId, entries: []);

void main() {
  late List<String> log;

  ProviderContainer containerWith(ScriptedPayoutRepository repository) {
    log = [];
    return ProviderContainer.test(
      overrides: [
        payoutRepositoryProvider.overrideWithValue(repository),
        lifecycleLogProvider.overrideWithValue(log.add),
      ],
      retry: (retryCount, error) => null,
    );
  }

  group('the view state: each of the four maps once', () {
    test('loading', () {
      expect(
        payoutsViewState(_mabena, const AsyncLoading()),
        isA<ViewLoading<PayoutOrder>>(),
      );
    });

    test('empty is empty, not data: a cycle with no payout order', () {
      final view = payoutsViewState(_mabena, AsyncData(_empty(_mabena)));

      expect(view, isA<ViewEmpty<PayoutOrder>>());
      expect(view, isNot(isA<ViewData<PayoutOrder>>()));
    });

    test('data, the order exactly as sent', () {
      final order = _seeded(_mabena);
      final view = payoutsViewState(_mabena, AsyncData(order));

      expect(view, isA<ViewData<PayoutOrder>>());
      expect((view as ViewData<PayoutOrder>).value, same(order));
    });

    test('failure: "not found" for a cycle the person is not in', () {
      final view = payoutsViewState(
        _mabena,
        const AsyncError(CycleNotFoundException(), StackTrace.empty),
      );

      expect(view, isA<ViewFailure<PayoutOrder>>());
      expect(
        (view as ViewFailure<PayoutOrder>).message,
        "We couldn't find that cycle.",
      );
    });

    test('failure: any other error reads as a connection problem', () {
      final view = payoutsViewState(
        _mabena,
        const AsyncError(FakeNetworkException(), StackTrace.empty),
      );

      expect((view as ViewFailure<PayoutOrder>).message, genericFailureMessage);
    });

    test("another cycle's order is never shown under this one", () {
      expect(
        payoutsViewState(_soweto, AsyncData(_seeded(_mabena))),
        isA<ViewLoading<PayoutOrder>>(),
      );
    });
  });

  group('the family, through a container', () {
    test('a key built twice is the same family member', () {
      const key = (
        stokvelId: FakeSeed.mabenaFamilyId,
        cycleId: FakeSeed.mabenaCycleId,
      );
      expect(payoutOrderProvider(key), payoutOrderProvider(_mabena));
    });

    test('empty comes through as empty, not as data', () async {
      final container = containerWith(
        ScriptedPayoutRepository({_mabena.cycleId: _empty(_mabena)}),
      )..listen(payoutOrderProvider(_mabena), (_, _) {});

      await container.read(payoutOrderProvider(_mabena).future);

      expect(
        payoutsViewState(_mabena, container.read(payoutOrderProvider(_mabena))),
        isA<ViewEmpty<PayoutOrder>>(),
      );
    });

    test('loading, then data', () async {
      final answer = Completer<PayoutOrder>();
      final container = containerWith(
        ScriptedPayoutRepository({_mabena.cycleId: answer}),
      )..listen(payoutOrderProvider(_mabena), (_, _) {});

      expect(
        payoutsViewState(_mabena, container.read(payoutOrderProvider(_mabena))),
        isA<ViewLoading<PayoutOrder>>(),
      );

      answer.complete(_seeded(_mabena));
      await container.read(payoutOrderProvider(_mabena).future);

      expect(
        payoutsViewState(_mabena, container.read(payoutOrderProvider(_mabena))),
        isA<ViewData<PayoutOrder>>(),
      );
    });

    test('two cycles keep separate state', () async {
      final repository = ScriptedPayoutRepository({
        _mabena.cycleId: _seeded(_mabena),
        _soweto.cycleId: const CycleNotFoundException(),
      });
      final container = containerWith(repository)
        ..listen(payoutOrderProvider(_mabena), (_, _) {})
        ..listen(payoutOrderProvider(_soweto), (_, _) {});

      final mabena = await container.read(payoutOrderProvider(_mabena).future);
      await expectLater(
        container.read(payoutOrderProvider(_soweto).future),
        throwsA(isA<CycleNotFoundException>()),
      );

      expect(mabena.cycleId, _mabena.cycleId);
      expect(container.read(payoutOrderProvider(_soweto)).hasError, isTrue);

      // Refreshing one leaves the other alone.
      container.invalidate(payoutOrderProvider(_mabena));
      expect(container.read(payoutOrderProvider(_mabena)).isLoading, isTrue);
      expect(container.read(payoutOrderProvider(_soweto)).hasError, isTrue);
      // Mabena refetched; Soweto Teachers was never asked again.
      expect(repository.calls, {_mabena.cycleId: 2, _soweto.cycleId: 1});
    });

    test('disposed with its last listener, logging ids only', () async {
      final container = containerWith(
        ScriptedPayoutRepository({_mabena.cycleId: _seeded(_mabena)}),
      );
      final subscription = container.listen(
        payoutOrderProvider(_mabena),
        (_, _) {},
      );
      await container.read(payoutOrderProvider(_mabena).future);

      subscription.close();
      await container.pump();

      expect(container.exists(payoutOrderProvider(_mabena)), isFalse);
      expect(log, [
        'payoutOrder created cycleId=${_mabena.cycleId}',
        'payoutOrder disposed cycleId=${_mabena.cycleId}',
      ]);
      expect(log.join(), isNot(contains('Lerato')));
    });
  });
}
