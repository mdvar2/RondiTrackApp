// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'record_contribution_request.g.dart';

@JsonSerializable()
class RecordContributionRequest {
  const RecordContributionRequest({
    required this.amountInCents,
    required this.contributionCycleId,
  });

  factory RecordContributionRequest.fromJson(Map<String, Object?> json) =>
      _$RecordContributionRequestFromJson(json);

  final int amountInCents;
  final String contributionCycleId;

  Map<String, Object?> toJson() => _$RecordContributionRequestToJson(this);
}
