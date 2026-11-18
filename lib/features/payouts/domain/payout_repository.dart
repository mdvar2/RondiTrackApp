import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_order.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';

/// Reads a cycle's payout order for the signed-in person
/// (`GET /stokvels/{stokvelId}/cycles/{cycleId}/payouts`).
abstract interface class PayoutRepository {
  /// The payout order of cycle [cycleId] of stokvel [stokvelId], as the API
  /// sends it.
  ///
  /// Fails with a [NotFoundFailure] (the fake's is a
  /// [CycleNotFoundException]) when the caller isn't a member of the
  /// stokvel, when the cycle doesn't exist, and when it belongs to another
  /// stokvel: the API answers all three with the same `404`, so nobody can
  /// tell whether a stokvel they aren't in exists.
  Future<Result<PayoutOrder>> fetchPayoutOrder(
    String stokvelId,
    String cycleId,
  );
}
