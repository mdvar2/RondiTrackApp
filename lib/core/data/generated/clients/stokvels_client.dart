// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/contribution_response.dart';
import '../models/create_stokvel_request.dart';
import '../models/paged_result_of_stokvel_member_response.dart';
import '../models/record_contribution_request.dart';
import '../models/stokvel_detail_response.dart';
import '../models/stokvel_response.dart';
import '../models/update_stokvel_request.dart';

part 'stokvels_client.g.dart';

@RestApi()
abstract class StokvelsClient {
  factory StokvelsClient(Dio dio, {String? baseUrl}) = _StokvelsClient;

  /// Gets all stokvels.
  ///
  /// Returns all stokvels currently available in RondiTrack.
  /// An empty collection is returned when no stokvels are available.
  @GET('/api/v1/stokvels')
  Future<HttpResponse<List<StokvelResponse>>> getApiV1Stokvels();

  /// Creates a new stokvel.
  ///
  /// Creates a stokvel from a valid name and contribution amount.
  /// Returns 400 when the request fails validation.
  @POST('/api/v1/stokvels')
  Future<HttpResponse<StokvelResponse>> postApiV1Stokvels({
    @Body() required CreateStokvelRequest body,
  });

  /// Gets a stokvel by ID.
  ///
  /// Returns the stokvel with its member count, the caller's role in it and a.
  /// summary of the current Johannesburg-month cycle (null when there is none).
  /// Returns 404 when no stokvel exists with the supplied ID, or when the caller.
  /// is not a member, so a non-member cannot learn that the stokvel exists.
  @GET('/api/v1/stokvels/{id}')
  Future<HttpResponse<StokvelDetailResponse>> getApiV1StokvelsId({
    @Path('id') required String id,
  });

  /// Updates an existing stokvel.
  ///
  /// Updates the name and contribution amount of an existing stokvel.
  /// Returns 400 when the request fails validation.
  /// Returns 404 when the stokvel does not exist.
  @PUT('/api/v1/stokvels/{id}')
  Future<HttpResponse<void>> putApiV1StokvelsId({
    @Path('id') required String id,
    @Body() required UpdateStokvelRequest body,
    @Header('If-Match') String? ifMatch,
  });

  /// Deletes a stokvel.
  ///
  /// Deletes the stokvel with the supplied ID.
  /// Returns 404 when the stokvel does not exist.
  @DELETE('/api/v1/stokvels/{id}')
  Future<HttpResponse<void>> deleteApiV1StokvelsId({
    @Path('id') required String id,
  });

  @GET('/api/v1/stokvels/{stokvelId}/members')
  Future<HttpResponse<PagedResultOfStokvelMemberResponse>>
  getApiV1StokvelsStokvelIdMembers({
    @Path('stokvelId') required String stokvelId,
    @Query('pageToken') String? pageToken,
    @Query('role') String? role,
    @Query('pageSize') int? pageSize = 25,
    @Query('sortBy') String? sortBy = 'joinedAtUtc',
    @Query('sortDirection') String? sortDirection = 'desc',
  });

  /// Records a contribution for a stokvel member.
  ///
  /// Records a contribution for an existing member and contribution cycle.
  /// An Idempotency-Key header is required to safely retry the request.
  /// Repeating the same request with the same key returns the stored response.
  /// without creating another contribution.
  /// Returns 400 when the Idempotency-Key is missing or the request fails validation.
  /// Returns 404 when the stokvel, user, or contribution cycle does not exist.
  /// Returns 409 when a business rule is violated, such as when the user is not.
  /// a member, the cycle belongs to another stokvel, a contribution already exists.
  /// for the member and cycle, or an idempotency key is reused with different data.
  @POST('/api/v1/stokvels/{stokvelId}/members/{userId}/contributions')
  Future<HttpResponse<ContributionResponse>>
  postApiV1StokvelsStokvelIdMembersUserIdContributions({
    @Path('stokvelId') required String stokvelId,
    @Path('userId') required String userId,
    @Header('Idempotency-Key') required String idempotencyKey,
    @Body() required RecordContributionRequest body,
  });
}
