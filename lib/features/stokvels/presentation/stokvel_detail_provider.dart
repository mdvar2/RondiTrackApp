import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/logging/lifecycle_log.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_actions.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';

part 'stokvel_detail_provider.g.dart';

/// One stokvel's detail, keyed by its id.
///
/// A family: every stokvel has its own state, so switching stokvels can
/// never show the previous one's data under the new one's name.
/// Lifetime: autoDispose. See README "Provider lifetimes".
@riverpod
Future<StokvelDetail> stokvelDetail(Ref ref, String stokvelId) {
  // Ids only: never a stokvel's name or an amount.
  final log = ref.watch(lifecycleLogProvider)
    ..call('stokvelDetail created id=$stokvelId');
  ref.onDispose(() => log('stokvelDetail disposed id=$stokvelId'));
  return ref.watch(stokvelRepositoryProvider).fetchStokvel(stokvelId);
}

/// The message for a stokvel that can't be shown. The same words whether it
/// doesn't exist or the person isn't in it.
const stokvelNotFoundMessage = "We couldn't find that stokvel.";

/// The detail screen's view state for [requestedId].
///
/// A stokvel with no current cycle is [ViewEmpty]. As a second guard
/// against showing the wrong stokvel, a value for any other id is treated
/// as still loading.
ViewState<StokvelDetail> stokvelDetailViewState(
  String requestedId,
  AsyncValue<StokvelDetail> value,
) {
  final loaded = value.value;
  if (loaded != null && loaded.stokvel.id != requestedId) {
    return const ViewLoading();
  }
  return viewStateFrom(
    value,
    isEmpty: (detail) => detail.currentCycle == null,
    describeError: (error) => error is StokvelNotFoundException
        ? stokvelNotFoundMessage
        : genericFailureMessage,
  );
}

/// What [myUserId] may do in this stokvel's current cycle, from their role
/// in *this* stokvel.
Set<StokvelAction> actionsFor(StokvelDetail detail, String myUserId) {
  final cycle = detail.currentCycle;
  if (cycle == null) return const {};
  final mine = detail.contributions
      .where((contribution) => contribution.userId == myUserId)
      .map((contribution) => contribution.status)
      .firstOrNull;
  return allowedActions((
    role: detail.membership.role,
    cycle: cycle.status,
    mine: mine,
  ));
}
