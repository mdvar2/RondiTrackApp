import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/logging/lifecycle_log.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_order.dart';

part 'payout_order_provider.g.dart';

/// Which cycle's payout order: both ids, as in the address
/// `/stokvels/:id/cycles/:cycleId/payouts`.
///
/// A record, so two keys with the same ids are equal: building the screen
/// again finds the same family member, never a new one.
typedef CycleKey = ({String stokvelId, String cycleId});

/// One cycle's payout order, keyed by [CycleKey].
///
/// A family: every cycle has its own state, so opening another cycle's
/// payouts can never show this one's order under its name.
/// Lifetime: autoDispose, like `cycleDetailProvider`: it holds other
/// members' names and amounts, and goes when the screen does.
@riverpod
Future<PayoutOrder> payoutOrder(Ref ref, CycleKey cycle) async {
  // Ids only: never a member's name or an amount.
  final log = ref.watch(lifecycleLogProvider)
    ..call('payoutOrder created cycleId=${cycle.cycleId}');
  ref.onDispose(() => log('payoutOrder disposed cycleId=${cycle.cycleId}'));
  final repository = ref.watch(payoutRepositoryProvider);
  final result = await repository.fetchPayoutOrder(
    cycle.stokvelId,
    cycle.cycleId,
  );
  return result.valueOrThrow;
}

/// The message for a payout order that can't be shown: the same words as
/// the cycle screen's, whether the cycle doesn't exist, belongs to another
/// stokvel, or is in a stokvel the person isn't in.
const payoutsNotFoundMessage = "We couldn't find that cycle.";

/// The payouts view's state for [requested].
///
/// * Loading, until the API answers.
/// * [ViewEmpty] when the cycle has no payout order (the API sent no
///   items): its own state, never an empty list of [ViewData].
/// * [ViewData] with the order exactly as sent.
/// * [ViewFailure], with "not found" for a `NotFoundFailure`.
///
/// As a second guard against showing the wrong cycle, an order for any
/// other cycle counts as still loading.
ViewState<PayoutOrder> payoutsViewState(
  CycleKey requested,
  AsyncValue<PayoutOrder> value,
) {
  final loaded = value.value;
  if (loaded != null &&
      (loaded.cycleId != requested.cycleId ||
          loaded.stokvelId != requested.stokvelId)) {
    return const ViewLoading();
  }
  return viewStateFrom(
    value,
    isEmpty: (order) => order.entries.isEmpty,
    notFoundMessage: payoutsNotFoundMessage,
  );
}
