import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/observability/failure_reporter.dart';
import 'package:ronditrack_app/core/observability/sentry_provider_observer.dart';

class _RecordingReporter implements FailureReporter {
  final failures = <Failure>[];

  @override
  Future<void> report(Failure failure) async {
    failures.add(failure);
  }
}

void main() {
  test(
    'reports server failures once and ignores expected offline failures',
    () async {
      final reporter = _RecordingReporter();
      const serverFailure = ServerFailure(correlationId: 'request-123');
      final serverProvider = FutureProvider<int>(
        (ref) async => throw serverFailure,
      );
      final offlineProvider = FutureProvider<int>(
        (ref) async => throw const NoAnswerFailure(),
      );
      final container =
          ProviderContainer.test(
              observers: [SentryProviderObserver(reporter: reporter)],
              retry: (retryCount, error) => null,
            )
            ..listen(serverProvider, (_, _) {})
            ..listen(offlineProvider, (_, _) {});

      await expectLater(
        container.read(serverProvider.future),
        throwsA(same(serverFailure)),
      );
      await expectLater(
        container.read(offlineProvider.future),
        throwsA(isA<NoAnswerFailure>()),
      );

      expect(reporter.failures, [same(serverFailure)]);
    },
  );
}
