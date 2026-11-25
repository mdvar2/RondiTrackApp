// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'contribution_confirmation_client.g.dart';

@RestApi()
abstract class ContributionConfirmationClient {
  factory ContributionConfirmationClient(Dio dio, {String? baseUrl}) =
      _ContributionConfirmationClient;

  /// 204 when confirmed, or already confirmed (nothing is sent twice).
  /// 404 for a stokvel the caller isn't in, or a contribution not in this.
  /// cycle; 403 for a member who isn't its treasurer or chairperson; 409.
  /// for a contribution that isn't paid.
  @POST(
    '/api/v1/stokvels/{stokvelId}/cycles/{cycleId}/contributions/{contributionId}/confirm',
  )
  Future<HttpResponse<void>>
  postApiV1StokvelsStokvelIdCyclesCycleIdContributionsContributionIdConfirm({
    @Path('stokvelId') required String stokvelId,
    @Path('cycleId') required String cycleId,
    @Path('contributionId') required String contributionId,
  });
}
