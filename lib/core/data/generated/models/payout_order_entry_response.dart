// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'payout_order_entry_response.g.dart';

@JsonSerializable()
class PayoutOrderEntryResponse {
  const PayoutOrderEntryResponse({
    required this.position,
    required this.userId,
    required this.memberName,
    required this.amountCents,
    required this.paidAtUtc,
    required this.status,
  });
  
  factory PayoutOrderEntryResponse.fromJson(Map<String, Object?> json) => _$PayoutOrderEntryResponseFromJson(json);
  
  final int position;
  final String userId;
  final String memberName;
  final int amountCents;
  final DateTime? paidAtUtc;
  final String status;

  Map<String, Object?> toJson() => _$PayoutOrderEntryResponseToJson(this);
}
