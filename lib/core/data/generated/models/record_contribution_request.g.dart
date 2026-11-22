// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_contribution_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordContributionRequest _$RecordContributionRequestFromJson(
  Map<String, dynamic> json,
) => RecordContributionRequest(
  amountInCents: (json['amountInCents'] as num).toInt(),
  contributionCycleId: json['contributionCycleId'] as String,
);

Map<String, dynamic> _$RecordContributionRequestToJson(
  RecordContributionRequest instance,
) => <String, dynamic>{
  'amountInCents': instance.amountInCents,
  'contributionCycleId': instance.contributionCycleId,
};
