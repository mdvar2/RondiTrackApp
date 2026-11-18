// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/contribution_cycle_response.dart';
import '../models/paged_result_of_contribution_with_member_response.dart';
import '../models/update_contribution_cycle_request.dart';

part 'contribution_cycles_client.g.dart';

@RestApi()
abstract class ContributionCyclesClient {
  factory ContributionCyclesClient(Dio dio, {String? baseUrl}) = _ContributionCyclesClient;

  /// Gets a contribution cycle by ID.
  ///
  /// Returns the requested contribution cycle when it belongs to the specified stokvel.
  /// Returns 404 when the stokvel does not exist, the cycle does not exist,.
  /// or the cycle does not belong to the specified stokvel.
  @GET('/api/v1/stokvels/{stokvelId}/cycles/{cycleId}')
  Future<HttpResponse<ContributionCycleResponse>> getApiV1StokvelsStokvelIdCyclesCycleId({
    @Path('stokvelId') required String stokvelId,
    @Path('cycleId') required String cycleId,
  });

  /// Updates an existing contribution cycle.
  ///
  /// Updates the period, target amount and optional end date.
  /// of an existing contribution cycle.
  /// Returns 400 when the request fails validation.
  /// Returns 404 when the stokvel or contribution cycle does not exist,.
  /// or when the cycle does not belong to the specified stokvel.
  @PUT('/api/v1/stokvels/{stokvelId}/cycles/{cycleId}')
  Future<HttpResponse<void>> putApiV1StokvelsStokvelIdCyclesCycleId({
    @Path('stokvelId') required String stokvelId,
    @Path('cycleId') required String cycleId,
    @Body() required UpdateContributionCycleRequest body,
    @Header('If-Match') String? ifMatch,
  });

  /// Deletes a contribution cycle.
  ///
  /// Deletes an existing contribution cycle from the specified stokvel.
  /// Returns 404 when the stokvel or contribution cycle does not exist,.
  /// or when the cycle does not belong to the specified stokvel.
  @DELETE('/api/v1/stokvels/{stokvelId}/cycles/{cycleId}')
  Future<HttpResponse<void>> deleteApiV1StokvelsStokvelIdCyclesCycleId({
    @Path('stokvelId') required String stokvelId,
    @Path('cycleId') required String cycleId,
  });

  /// Gets contributions for a contribution cycle.
  ///
  /// Returns contributions together with membership and user information.
  /// The query projects directly to the response DTO so that only the.
  /// columns required by the API response are fetched.
  @GET('/api/v1/stokvels/{stokvelId}/cycles/{cycleId}/contributions')
  Future<HttpResponse<PagedResultOfContributionWithMemberResponse>> getApiV1StokvelsStokvelIdCyclesCycleIdContributions({
    @Path('stokvelId') required String stokvelId,
    @Path('cycleId') required String cycleId,
    @Query('pageToken') String? pageToken,
    @Query('userId') String? userId,
    @Query('role') String? role,
    @Query('minAmount') double? minAmount,
    @Query('maxAmount') double? maxAmount,
    @Query('pageSize') int? pageSize = 25,
    @Query('sortBy') String? sortBy = 'recordedAtUtc',
    @Query('sortDirection') String? sortDirection = 'desc',
  });
}
