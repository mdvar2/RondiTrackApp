// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/cycle_close_preview_response.dart';

part 'cycle_close_client.g.dart';

@RestApi()
abstract class CycleCloseClient {
  factory CycleCloseClient(Dio dio, {String? baseUrl}) = _CycleCloseClient;

  @GET('/api/v1/stokvels/{stokvelId}/cycles/{cycleId}/close/preview')
  Future<HttpResponse<CycleClosePreviewResponse>>
  getApiV1StokvelsStokvelIdCyclesCycleIdClosePreview({
    @Path('stokvelId') required String stokvelId,
    @Path('cycleId') required String cycleId,
  });
}
