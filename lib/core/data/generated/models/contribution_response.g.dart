// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contribution_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContributionResponse _$ContributionResponseFromJson(
  Map<String, dynamic> json,
) => ContributionResponse(
  id: json['id'] as String,
  stokvelId: json['stokvelId'] as String,
  userId: json['userId'] as String,
  contributionCycleId: json['contributionCycleId'] as String,
  amount: (json['amount'] as num).toInt(),
  status: json['status'] as String,
  recordedAtUtc: DateTime.parse(json['recordedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$ContributionResponseToJson(
  ContributionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'stokvelId': instance.stokvelId,
  'userId': instance.userId,
  'contributionCycleId': instance.contributionCycleId,
  'amount': instance.amount,
  'status': instance.status,
  'recordedAtUtc': instance.recordedAtUtc.toIso8601String(),
  'version': instance.version,
};
