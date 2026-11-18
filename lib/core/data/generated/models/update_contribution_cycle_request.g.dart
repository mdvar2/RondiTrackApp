// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_contribution_cycle_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateContributionCycleRequest _$UpdateContributionCycleRequestFromJson(
  Map<String, dynamic> json,
) => UpdateContributionCycleRequest(
  period: json['period'] as String,
  targetAmount: (json['targetAmount'] as num).toDouble(),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
);

Map<String, dynamic> _$UpdateContributionCycleRequestToJson(
  UpdateContributionCycleRequest instance,
) => <String, dynamic>{
  'period': instance.period,
  'targetAmount': instance.targetAmount,
  'endDate': instance.endDate?.toIso8601String(),
};
