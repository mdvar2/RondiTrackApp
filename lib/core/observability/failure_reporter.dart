import 'package:ronditrack_app/core/errors/failure.dart';

/// The single boundary for failures sent to an external error service.
abstract interface class FailureReporter {
  /// Reports a failure that is worth investigating.
  Future<void> report(Failure failure);
}
