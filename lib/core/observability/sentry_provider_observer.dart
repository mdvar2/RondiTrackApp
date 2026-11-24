import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/observability/failure_reporter.dart';
import 'package:ronditrack_app/core/observability/sentry_event_scrubber.dart';
import 'package:ronditrack_app/core/observability/sentry_failure_reporter.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';

/// One reporting point for provider failures, and the current member name
/// used by the Sentry scrubber.
base class SentryProviderObserver extends ProviderObserver {
  /// Creates the observer with the real reporter or a test recorder.
  new({FailureReporter? reporter})
    : _reporter = reporter ?? const SentryFailureReporter();

  final FailureReporter _reporter;

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    if (context.provider == authControllerProvider) {
      SentryMemberIdentity.name = switch (newValue) {
        SignedIn(:final user) => user.name,
        _ => null,
      };
    }

    if (newValue case AsyncError(:final error) when error is ServerFailure) {
      unawaited(_reporter.report(error));
    }
  }
}
