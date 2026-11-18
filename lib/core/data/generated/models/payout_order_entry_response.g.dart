// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_order_entry_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayoutOrderEntryResponse _$PayoutOrderEntryResponseFromJson(
  Map<String, dynamic> json,
) => PayoutOrderEntryResponse(
  position: (json['position'] as num).toInt(),
  userId: json['userId'] as String,
  memberName: json['memberName'] as String,
  amountCents: (json['amountCents'] as num).toInt(),
  paidAtUtc: json['paidAtUtc'] == null
      ? null
      : DateTime.parse(json['paidAtUtc'] as String),
  status: json['status'] as String,
);

Map<String, dynamic> _$PayoutOrderEntryResponseToJson(
  PayoutOrderEntryResponse instance,
) => <String, dynamic>{
  'position': instance.position,
  'userId': instance.userId,
  'memberName': instance.memberName,
  'amountCents': instance.amountCents,
  'paidAtUtc': instance.paidAtUtc?.toIso8601String(),
  'status': instance.status,
};
