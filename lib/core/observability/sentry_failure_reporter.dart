import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/observability/failure_reporter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Sends only server-side failures. Offline, validation and business-rule
/// responses are expected states and are not error reports.
class SentryFailureReporter implements FailureReporter {
  /// Creates the Sentry reporter.
  const new();

  @override
  Future<void> report(Failure failure) async {
    if (failure is! ServerFailure) return;
    await Sentry.captureException(
      failure,
      withScope: (scope) async {
        final correlationId = failure.reference;
        if (correlationId != null) {
          await scope.setTag('correlationId', correlationId);
        }
      },
    );
  }
}
