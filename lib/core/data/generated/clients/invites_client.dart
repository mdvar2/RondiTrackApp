// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/invite_preview_response.dart';

part 'invites_client.g.dart';

@RestApi()
abstract class InvitesClient {
  factory InvitesClient(Dio dio, {String? baseUrl}) = _InvitesClient;

  @GET('/api/v1/invites/{code}')
  Future<HttpResponse<InvitePreviewResponse>> getApiV1InvitesCode({
    @Path('code') required String code,
  });

  @POST('/api/v1/invites/{code}/join')
  Future<HttpResponse<void>> postApiV1InvitesCodeJoin({
    @Path('code') required String code,
  });
}
