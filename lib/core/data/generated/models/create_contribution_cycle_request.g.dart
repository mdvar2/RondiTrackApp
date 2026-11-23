// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_contribution_cycle_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateContributionCycleRequest _$CreateContributionCycleRequestFromJson(
  Map<String, dynamic> json,
) => CreateContributionCycleRequest(
  period: json['period'] as String,
  targetAmount: (json['targetAmount'] as num).toDouble(),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
);

Map<String, dynamic> _$CreateContributionCycleRequestToJson(
  CreateContributionCycleRequest instance,
) => <String, dynamic>{
  'period': instance.period,
  'targetAmount': instance.targetAmount,
  'endDate': instance.endDate?.toIso8601String(),
};
