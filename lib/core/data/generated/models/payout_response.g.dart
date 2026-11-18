// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayoutResponse _$PayoutResponseFromJson(Map<String, dynamic> json) =>
    PayoutResponse(
      id: json['id'] as String,
      stokvelId: json['stokvelId'] as String,
      recipientUserId: json['recipientUserId'] as String,
      contributionCycleId: json['contributionCycleId'] as String,
      amount: (json['amount'] as num).toDouble(),
      paidAtUtc: DateTime.parse(json['paidAtUtc'] as String),
      version: (json['version'] as num).toInt(),
    );

Map<String, dynamic> _$PayoutResponseToJson(PayoutResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stokvelId': instance.stokvelId,
      'recipientUserId': instance.recipientUserId,
      'contributionCycleId': instance.contributionCycleId,
      'amount': instance.amount,
      'paidAtUtc': instance.paidAtUtc.toIso8601String(),
      'version': instance.version,
    };
