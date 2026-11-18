import 'package:ronditrack_app/core/data/api_values.dart';
import 'package:ronditrack_app/core/data/generated/rondi_track_api.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/activity/domain/activity_item.dart';
import 'package:ronditrack_app/features/activity/domain/activity_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/stokvel_mapper.dart';

/// [ActivityRepository] on the API.
///
/// The API has no feed (README "Contract notes", gap 7), so the feed is my
/// stokvels' current-cycle contributions, as the fake built it: Home for my
/// stokvels, then each stokvel (for its current cycle's id) and that
/// cycle's contributions, all stokvels at once. If one fails, the feed
/// fails with the most telling failure.
class ApiActivityRepository implements ActivityRepository {
  /// Creates the repository over the generated client.
  new(this._api);

  final RondiTrackApi _api;

  @override
  Future<Result<List<ActivityItem>>> fetchActivity() => guard(() async {
    final home = await _api.me.getApiV1MeHome();
    final perStokvel = await [
      for (final stokvel in home.data.stokvels) _activityOf(stokvel.stokvelId),
    ].wait;
    final items = [for (final list in perStokvel) ...list]
      ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return List.unmodifiable(items);
  });

  Future<List<ActivityItem>> _activityOf(String stokvelId) async {
    final detail = (await _api.stokvels.getApiV1StokvelsId(id: stokvelId)).data;
    final cycle = detail.currentCycle;
    if (cycle == null) return const [];
    final contributions = await allPages((token) async {
      final response = await _api.contributionCycles
          .getApiV1StokvelsStokvelIdCyclesCycleIdContributions(
            stokvelId: stokvelId,
            cycleId: cycle.id,
            pageToken: token,
            pageSize: 100,
          );
      return contributionPageFrom(response.data);
    });
    return [
      for (final contribution in contributions)
        ActivityItem(
          id: contribution.id,
          stokvelId: stokvelId,
          stokvelName: detail.name,
          cycleId: cycle.id,
          memberName: contribution.memberName,
          amount: contribution.amount,
          status: contribution.status,
          occurredAt: contribution.recordedAt,
        ),
    ];
  }
}
