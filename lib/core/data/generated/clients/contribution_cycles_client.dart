// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/contribution_cycle_response.dart';
import '../models/create_contribution_cycle_request.dart';
import '../models/paged_result_of_contribution_with_member_response.dart';
import '../models/update_contribution_cycle_request.dart';

part 'contribution_cycles_client.g.dart';

@RestApi()
abstract class ContributionCyclesClient {
  factory ContributionCyclesClient(Dio dio, {String? baseUrl}) =
      _ContributionCyclesClient;

  /// Gets all contribution cycles for a stokvel.
  ///
  /// Returns all contribution cycles belonging to the specified stokvel.
  /// An empty collection is returned when the stokvel exists but has no cycles.
  /// Returns 404 when the stokvel does not exist.
  @GET('/api/v1/stokvels/{stokvelId}/cycles')
  Future<HttpResponse<List<ContributionCycleResponse>>>
  getApiV1StokvelsStokvelIdCycles({
    @Path('stokvelId') required String stokvelId,
  });

  /// Creates a contribution cycle for a stokvel.
  ///
  /// Creates a new contribution cycle for an existing stokvel.
  /// Returns 400 when the request fails validation.
  /// Returns 404 when the stokvel does not exist.
  @POST('/api/v1/stokvels/{stokvelId}/cycles')
  Future<HttpResponse<ContributionCycleResponse>>
  postApiV1StokvelsStokvelIdCycles({
    @Path('stokvelId') required String stokvelId,
    @Body() required CreateContributionCycleRequest body,
  });

  /// Gets a contribution cycle by ID.
  ///
  /// Returns the requested contribution cycle when it belongs to the specified stokvel.
  /// Returns 404 when the stokvel does not exist, the cycle does not exist,.
  /// or the cycle does not belong to the specified stokvel.
  @GET('/api/v1/stokvels/{stokvelId}/cycles/{cycleId}')
  Future<HttpResponse<ContributionCycleResponse>>
  getApiV1StokvelsStokvelIdCyclesCycleId({
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
  /// Filters: userId (the member), status (Pending, Paid, Confirmed), and.
  /// recordedFrom (inclusive) and recordedBefore (exclusive): two instants,.
  /// ISO 8601 with an offset, so a calendar day in any zone is.
  /// [its midnight, the next midnight). A page token works only with the.
  /// sort and filters that made it (400 otherwise).
  @GET('/api/v1/stokvels/{stokvelId}/cycles/{cycleId}/contributions')
  Future<HttpResponse<PagedResultOfContributionWithMemberResponse>>
  getApiV1StokvelsStokvelIdCyclesCycleIdContributions({
    @Path('stokvelId') required String stokvelId,
    @Path('cycleId') required String cycleId,
    @Query('pageToken') String? pageToken,
    @Query('userId') String? userId,
    @Query('role') String? role,
    @Query('minAmount') double? minAmount,
    @Query('maxAmount') double? maxAmount,
    @Query('status') String? status,
    @Query('recordedFrom') DateTime? recordedFrom,
    @Query('recordedBefore') DateTime? recordedBefore,
    @Query('pageSize') int? pageSize = 25,
    @Query('sortBy') String? sortBy = 'recordedAtUtc',
    @Query('sortDirection') String? sortDirection = 'desc',
  });
}
