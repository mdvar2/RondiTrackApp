// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_contribution_cycle_request.g.dart';

@JsonSerializable()
class UpdateContributionCycleRequest {
  const UpdateContributionCycleRequest({
    required this.period,
    required this.targetAmount,
    this.endDate,
  });
  
  factory UpdateContributionCycleRequest.fromJson(Map<String, Object?> json) => _$UpdateContributionCycleRequestFromJson(json);
  
  final String period;
  final double targetAmount;
  final DateTime? endDate;

  Map<String, Object?> toJson() => _$UpdateContributionCycleRequestToJson(this);
}
