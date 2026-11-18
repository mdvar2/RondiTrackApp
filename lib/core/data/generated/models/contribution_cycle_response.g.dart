// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contribution_cycle_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContributionCycleResponse _$ContributionCycleResponseFromJson(
  Map<String, dynamic> json,
) => ContributionCycleResponse(
  id: json['id'] as String,
  stokvelId: json['stokvelId'] as String,
  period: json['period'] as String,
  targetAmount: (json['targetAmount'] as num).toDouble(),
  version: (json['version'] as num).toInt(),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  status: json['status'] as String,
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  totalCollectedCents: (json['totalCollectedCents'] as num).toInt(),
  amountDueCents: (json['amountDueCents'] as num).toInt(),
);

Map<String, dynamic> _$ContributionCycleResponseToJson(
  ContributionCycleResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'stokvelId': instance.stokvelId,
  'period': instance.period,
  'targetAmount': instance.targetAmount,
  'version': instance.version,
  'endDate': instance.endDate?.toIso8601String(),
  'status': instance.status,
  'dueDate': instance.dueDate?.toIso8601String(),
  'totalCollectedCents': instance.totalCollectedCents,
  'amountDueCents': instance.amountDueCents,
};
