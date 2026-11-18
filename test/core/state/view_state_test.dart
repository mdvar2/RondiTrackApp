import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_app/features/home/domain/home_entry.dart';
import 'package:ronditrack_app/features/home/presentation/home_controller.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_detail_provider.dart';

import '../../helpers/test_repositories.dart';

void main() {
  group('homeViewState', () {
    test('loading with nothing yet is loading', () {
      expect(homeViewState(const AsyncLoading()), isA<ViewLoading<Object>>());
    });

    test('no stokvels is empty, not data', () {
      expect(homeViewState(const AsyncData([])), isA<ViewEmpty<Object>>());
    });

    test('stokvels are data', () async {
      final entries = (await FakeHomeRepository(
        userId: FakeSeed.lerato.id,
        delay: Duration.zero,
      ).fetchHome()).valueOrThrow;

      expect(
        homeViewState(AsyncData(entries)),
        isA<ViewData<List<HomeEntry>>>()
            .having((view) => view.value, 'value', entries)
            .having((view) => view.refreshing, 'refreshing', isFalse),
      );
    });

    test('a refresh keeps the old data on screen, marked refreshing', () async {
      final entries = (await FakeHomeRepository(
        userId: FakeSeed.lerato.id,
        delay: Duration.zero,
      ).fetchHome()).valueOrThrow;
      final reload = Completer<List<HomeEntry>>();
      final container = ProviderContainer.test(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            ScriptedHomeRepository([entries, reload]),
          ),
        ],
      )..listen(homeControllerProvider, (_, _) {});
      await container.read(homeControllerProvider.future);

      unawaited(container.read(homeControllerProvider.notifier).refresh());

      expect(
        homeViewState(container.read(homeControllerProvider)),
        isA<ViewData<List<HomeEntry>>>()
            .having((view) => view.value, 'value', entries)
            .having((view) => view.refreshing, 'refreshing', isTrue),
      );
      reload.complete(entries);
    });

    test('an error with nothing to show is a failure with words', () {
      expect(
        homeViewState(const AsyncError(NoAnswerFailure(), StackTrace.empty)),
        isA<ViewFailure<List<HomeEntry>>>()
            .having(
              (view) => view.message,
              'message',
              const NoAnswerFailure().message,
            )
            .having((view) => view.reference, 'reference', isNull),
      );
    });

    test('a server failure shows its words and its reference', () {
      expect(
        homeViewState(
          const AsyncError(
            ServerFailure(correlationId: '9f21773e18af553124148fb4140b5bc4'),
            StackTrace.empty,
          ),
        ),
        isA<ViewFailure<List<HomeEntry>>>()
            .having(
              (view) => view.message,
              'message',
              const ServerFailure().message,
            )
            .having(
              (view) => view.reference,
              'reference',
              '9f21773e18af553124148fb4140b5bc4',
            ),
      );
    });

    test('an error that is not a Failure is shown as a server failure, '
        'never raw', () {
      final view = homeViewState(
        AsyncError(StateError('a bug with a name in it'), StackTrace.empty),
      );
      expect(
        (view as ViewFailure<List<HomeEntry>>).message,
        const ServerFailure().message,
      );
    });
  });

  group('stokvelDetailViewState', () {
    final repository = FakeStokvelRepository(
      userId: FakeSeed.lerato.id,
      delay: Duration.zero,
    );

    test('data for the requested id is data', () async {
      final detail = (await repository.fetchStokvel(FakeSeed.mabenaFamilyId))
          .valueOrThrow;

      expect(
        stokvelDetailViewState(FakeSeed.mabenaFamilyId, AsyncData(detail)),
        isA<ViewData<Object>>(),
      );
    });

    test('data for any other id is never shown: it is loading', () async {
      final mabena = (await repository.fetchStokvel(FakeSeed.mabenaFamilyId))
          .valueOrThrow;

      expect(
        stokvelDetailViewState(FakeSeed.sowetoTeachersId, AsyncData(mabena)),
        isA<ViewLoading<Object>>(),
      );
    });

    test('a stokvel with no current cycle is empty', () async {
      final detail = (await repository.fetchStokvel(FakeSeed.mabenaFamilyId))
          .valueOrThrow;

      expect(
        stokvelDetailViewState(
          FakeSeed.mabenaFamilyId,
          AsyncData(detail.copyWith(currentCycle: null)),
        ),
        isA<ViewEmpty<Object>>(),
      );
    });

    test('not found says "not found", never "no access"', () {
      final view = stokvelDetailViewState(
        FakeSeed.mabenaFamilyId,
        const AsyncError(StokvelNotFoundException(), StackTrace.empty),
      );

      expect(
        view,
        isA<ViewFailure<StokvelDetail>>().having(
          (view) => view.message,
          'message',
          stokvelNotFoundMessage,
        ),
      );
      expect(stokvelNotFoundMessage.toLowerCase(), isNot(contains('access')));
      expect(
        stokvelNotFoundMessage.toLowerCase(),
        isNot(contains('permission')),
      );
    });
  });
}
