// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'payout_order_entry_response.dart';

part 'payout_order_response.g.dart';

@JsonSerializable()
class PayoutOrderResponse {
  const PayoutOrderResponse({
    required this.stokvelId,
    required this.cycleId,
    required this.items,
  });

  factory PayoutOrderResponse.fromJson(Map<String, Object?> json) =>
      _$PayoutOrderResponseFromJson(json);

  final String stokvelId;
  final String cycleId;
  final List<PayoutOrderEntryResponse> items;

  Map<String, Object?> toJson() => _$PayoutOrderResponseToJson(this);
}
