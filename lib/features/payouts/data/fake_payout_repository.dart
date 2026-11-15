import 'package:ronditrack_app/features/payouts/domain/payout_order.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';

/// A [PayoutRepository] over [FakeSeed], signed in as [userId].
///
/// It answers like the API: a member gets the order exactly as seeded (in
/// rotation order, with the API's statuses and amounts), and anyone else
/// gets the same "not found" as a cycle that doesn't exist, the API's `404`.
class FakePayoutRepository implements PayoutRepository {
  /// Creates the fake. [delay] pretends to be the network; tests pass
  /// [Duration.zero].
  new({
    required this.userId,
    this.delay = const Duration(milliseconds: 600),
    List<FakeStokvel>? stokvels,
    Map<String, List<PayoutEntry>>? orders,
  }) : _stokvels = stokvels ?? FakeSeed.stokvels,
       _orders = orders ?? FakeSeed.payoutOrders;

  /// The signed-in person, `null` when nobody is: every order is then not
  /// found.
  final String? userId;

  /// The pretend network delay.
  final Duration delay;

  final List<FakeStokvel> _stokvels;
  final Map<String, List<PayoutEntry>> _orders;

  @override
  Future<PayoutOrder> fetchPayoutOrder(String stokvelId, String cycleId) async {
    await Future<void>.delayed(delay);

    for (final entry in _stokvels) {
      if (entry.stokvel.id != stokvelId) continue;
      // Not a member, or a cycle of another stokvel: the same answer as a
      // cycle that doesn't exist.
      if (entry.roles[userId] == null) break;
      if (entry.cycle?.id != cycleId) break;
      return PayoutOrder(
        stokvelId: stokvelId,
        cycleId: cycleId,
        entries: List.unmodifiable(_orders[cycleId] ?? const <PayoutEntry>[]),
      );
    }
    throw const CycleNotFoundException();
  }
}
