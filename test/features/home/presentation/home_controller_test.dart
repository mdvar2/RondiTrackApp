import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_app/features/home/domain/home_entry.dart';
import 'package:ronditrack_app/features/home/domain/home_repository.dart';
import 'package:ronditrack_app/features/home/presentation/home_controller.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

import '../../../helpers/test_database.dart';

class _MockHomeRepository extends Mock implements HomeRepository;

class _SignedOutAuthController extends AuthController {
  @override
  AuthState build() => const SignedOut();
}

void main() {
  test('loads once from a listened provider', () async {
    final response = Completer<Result<List<HomeEntry>>>();
    final repository = _MockHomeRepository();
    when(repository.fetchHome).thenAnswer((_) => response.future);
    final container = ProviderContainer.test(
      overrides: [
        inMemoryDatabase(),
        authControllerProvider.overrideWith(_SignedOutAuthController.new),
        homeRepositoryProvider.overrideWithValue(repository),
      ],
      retry: (retryCount, error) => null,
    )..listen(homeControllerProvider, (_, _) {});

    expect(container.read(homeControllerProvider).isLoading, isTrue);
    await untilCalled(repository.fetchHome);
    verify(repository.fetchHome).called(1);

    response.complete(
      await FakeHomeRepository(
        userId: FakeSeed.lerato.id,
        delay: Duration.zero,
      ).fetchHome(),
    );
    final entries = await container.read(homeControllerProvider.future);

    expect(entries, hasLength(2));
    verifyNoMoreInteractions(repository);
  });

  test('keeps cached Home when refresh fails, without retrying', () async {
    final repository = _MockHomeRepository();
    when(repository.fetchHome).thenAnswer(
      (_) => FakeHomeRepository(
        userId: FakeSeed.lerato.id,
        delay: Duration.zero,
      ).fetchHome(),
    );
    final container = ProviderContainer.test(
      overrides: [
        inMemoryDatabase(),
        authControllerProvider.overrideWith(_SignedOutAuthController.new),
        homeRepositoryProvider.overrideWithValue(repository),
      ],
      retry: (retryCount, error) => null,
    )..listen(homeControllerProvider, (_, _) {});

    final cached = await container.read(homeControllerProvider.future);
    when(repository.fetchHome)
        .thenAnswer((_) => Future.value(const Err(NoAnswerFailure())));
    clearInteractions(repository);

    await container.read(homeControllerProvider.notifier).refresh();

    expect(container.read(homeControllerProvider).value, cached);
    verify(repository.fetchHome).called(1);
    verifyNoMoreInteractions(repository);
  });
}
