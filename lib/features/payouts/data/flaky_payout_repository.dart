import 'package:ronditrack_app/core/fakes/fail_every.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_order.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_repository.dart';

/// Wraps a [PayoutRepository] so that some calls fail with
/// [FakeNetworkException], after the usual wait. The dev flavour uses it
/// behind `--dart-define=FAKE_FAIL_EVERY=`, to show the payouts view's
/// failure state and its retry on a phone.
class FlakyPayoutRepository implements PayoutRepository {
  /// Creates the wrapper; see [FailEvery] for which calls fail.
  new(this._inner, {required int failEvery}) : _failures = FailEvery(failEvery);

  final PayoutRepository _inner;
  final FailEvery _failures;

  @override
  Future<PayoutOrder> fetchPayoutOrder(String stokvelId, String cycleId) async {
    final fails = _failures.next();
    final order = await _inner.fetchPayoutOrder(stokvelId, cycleId);
    if (fails) throw const FakeNetworkException();
    return order;
  }
}
