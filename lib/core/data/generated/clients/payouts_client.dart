// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_payout_request.dart';
import '../models/payout_order_response.dart';
import '../models/payout_response.dart';

part 'payouts_client.g.dart';

@RestApi()
abstract class PayoutsClient {
  factory PayoutsClient(Dio dio, {String? baseUrl}) = _PayoutsClient;

  /// Gets the payout order as seen from one cycle.
  ///
  /// Lists every member of the stokvel in rotation order (the order they.
  /// joined), each with a 1-based position, the amount in cents, when they.
  /// were paid, and a status: Paid, Next or Waiting. The server decides.
  /// every status: Next is the member the next payout goes to, so no client.
  /// works it out. Items is empty for a cycle that isn't open and had no.
  /// payout. Any member may read it. Returns 404 when the caller isn't a.
  /// member, and when the cycle doesn't exist or belongs to another stokvel.
  @GET('/api/v1/stokvels/{stokvelId}/cycles/{cycleId}/payouts')
  Future<HttpResponse<PayoutOrderResponse>>
  getApiV1StokvelsStokvelIdCyclesCycleIdPayouts({
    @Path('stokvelId') required String stokvelId,
    @Path('cycleId') required String cycleId,
  });

  /// Creates a payout for the next eligible stokvel member.
  ///
  /// Selects the next eligible member according to the stokvel.
  /// payout rotation and creates the payout inside an explicit.
  /// database transaction.
  @POST('/api/v1/stokvels/{stokvelId}/cycles/{cycleId}/payouts')
  Future<HttpResponse<PayoutResponse>>
  postApiV1StokvelsStokvelIdCyclesCycleIdPayouts({
    @Path('stokvelId') required String stokvelId,
    @Path('cycleId') required String cycleId,
    @Body() required CreatePayoutRequest body,
  });
}
