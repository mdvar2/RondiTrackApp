import 'package:ronditrack_app/core/data/api_values.dart';
import 'package:ronditrack_app/core/data/generated/rondi_track_api.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/home/data/home_mapper.dart';
import 'package:ronditrack_app/features/home/domain/home_entry.dart';
import 'package:ronditrack_app/features/home/domain/home_repository.dart';

/// [HomeRepository] on the API: `GET /api/v1/me/home`, in the API's order
/// (by stokvel name).
class ApiHomeRepository implements HomeRepository {
  /// Creates the repository over the generated client.
  new(this._api);

  final RondiTrackApi _api;

  @override
  Future<Result<List<HomeEntry>>> fetchHome() => guard(() async {
    final response = await _api.me.getApiV1MeHome();
    return List.unmodifiable(response.data.stokvels.map(homeEntryFrom));
  });
}
