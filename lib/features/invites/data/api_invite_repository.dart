import 'package:dio/dio.dart';
import 'package:ronditrack_app/core/data/api_values.dart';
import 'package:ronditrack_app/core/data/generated/models/invite_preview_response.dart';
import 'package:ronditrack_app/core/data/generated/rondi_track_api.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/features/invites/domain/invite_preview.dart';
import 'package:ronditrack_app/features/invites/domain/invite_repository.dart';

/// `InvitePreviewResponse` for invite [code] as an [InvitePreview].
InvitePreview invitePreviewFrom(String code, InvitePreviewResponse response) =>
    InvitePreview(
      code: code,
      stokvelId: response.stokvelId,
      stokvelName: response.name,
      contributionAmount: Cents(response.contributionAmountCents),
      schedule: response.schedule,
      rules: response.rules,
      memberCount: response.memberCount,
    );

/// [InviteRepository] on the API: `GET /invites/{code}` and
/// `POST /invites/{code}/join`.
class ApiInviteRepository implements InviteRepository {
  /// Creates the repository over the generated client.
  new(this._api);

  final RondiTrackApi _api;

  @override
  Future<Result<InvitePreview>> fetchInvite(String code) => guard(() async {
    final response = await _api.invites.getApiV1InvitesCode(code: code);
    return invitePreviewFrom(code, response.data);
  });

  /// The join answers `204` with no body, so the stokvel's id comes from
  /// the preview, read first: a wrong code is its `404`, an expired one its
  /// `410`. The join's only `409` is "You are already a member of this
  /// stokvel." (README "Contract notes › Auth", question 7), so someone
  /// already in it gets the stokvel's id too, and lands in it.
  @override
  Future<Result<String>> join(String code) => guard(() async {
    final preview = await _api.invites.getApiV1InvitesCode(code: code);
    try {
      await _api.invites.postApiV1InvitesCodeJoin(code: code);
    } on DioException catch (error) {
      if (error.response?.statusCode != 409) rethrow;
    }
    return preview.data.stokvelId;
  });
}
