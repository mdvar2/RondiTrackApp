import 'package:ronditrack_app/core/data/api_values.dart';
import 'package:ronditrack_app/core/data/generated/rondi_track_api.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/stokvels/data/stokvel_mapper.dart';
import 'package:ronditrack_app/features/stokvels/domain/cycle_close_preview.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';

/// [StokvelRepository] on the API.
///
/// A non-member's `404` and a stokvel that doesn't exist arrive as the same
/// `NotFoundFailure`, as the API intends.
class ApiStokvelRepository implements StokvelRepository {
  /// Creates the repository over the generated client.
  new(this._api);

  final RondiTrackApi _api;

  /// How many contributions to ask for at a time: the API's largest page.
  static const pageSize = 100;

  @override
  Future<Result<StokvelDetail>> fetchStokvel(String stokvelId) =>
      guard(() async {
        final response = await _api.stokvels.getApiV1StokvelsId(id: stokvelId);
        final body = response.data;
        final summary = body.currentCycle;
        return StokvelDetail(
          stokvel: stokvelFrom(body, etagOf(response)),
          membership: membershipFrom(body),
          currentCycle: summary == null ? null : cycleFromSummary(summary),
          contributions: summary == null
              ? const []
              : List.unmodifiable(await _contributions(stokvelId, summary.id)),
        );
      });

  /// The stokvel, the cycle and its contributions, asked for together. If
  /// any fails they fail together (a `ParallelWaitError`), and the failure
  /// is the most telling of them: a `404` among them is still not found.
  @override
  Future<Result<CycleDetail>> fetchCycle(String stokvelId, String cycleId) =>
      guard(() async {
        final (stokvel, cycle, contributions) = await (
          _api.stokvels.getApiV1StokvelsId(id: stokvelId),
          _api.contributionCycles.getApiV1StokvelsStokvelIdCyclesCycleId(
            stokvelId: stokvelId,
            cycleId: cycleId,
          ),
          _contributions(stokvelId, cycleId),
        ).wait;
        final summary = stokvel.data.currentCycle;
        return CycleDetail(
          stokvel: stokvelFrom(stokvel.data, etagOf(stokvel)),
          cycle: summary != null && summary.id == cycleId
              ? cycleFromSummary(summary, etag: etagOf(cycle))
              : cycleFromResponse(
                  cycle.data,
                  contributions: contributions,
                  etag: etagOf(cycle),
                ),
          contributions: List.unmodifiable(contributions),
        );
      });

  @override
  Future<Result<CycleClosePreview>> fetchClosePreview(
    String stokvelId,
    String cycleId,
  ) => guard(() async {
    final response = await _api.cycleClose
        .getApiV1StokvelsStokvelIdCyclesCycleIdClosePreview(
          stokvelId: stokvelId,
          cycleId: cycleId,
        );
    return closePreviewFrom(response.data);
  });

  /// Every contribution of the cycle, newest first (the API's default
  /// order), following page tokens to the end marker.
  Future<List<Contribution>> _contributions(String stokvelId, String cycleId) =>
      allPages((token) async {
        final response = await _api.contributionCycles
            .getApiV1StokvelsStokvelIdCyclesCycleIdContributions(
              stokvelId: stokvelId,
              cycleId: cycleId,
              pageToken: token,
              pageSize: pageSize,
            );
        return contributionPageFrom(response.data);
      });
}
