// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/stokvel_detail_response.dart';
import '../models/update_stokvel_request.dart';

part 'stokvels_client.g.dart';

@RestApi()
abstract class StokvelsClient {
  factory StokvelsClient(Dio dio, {String? baseUrl}) = _StokvelsClient;

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
}
