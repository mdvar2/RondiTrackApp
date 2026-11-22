// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'contribution_cycle_response.g.dart';

@JsonSerializable()
class ContributionCycleResponse {
  const ContributionCycleResponse({
    required this.id,
    required this.stokvelId,
    required this.period,
    required this.targetAmount,
    required this.version,
    required this.endDate,
    required this.status,
    required this.dueDate,
    required this.totalCollectedCents,
    required this.amountDueCents,
  });

  factory ContributionCycleResponse.fromJson(Map<String, Object?> json) =>
      _$ContributionCycleResponseFromJson(json);

  final String id;
  final String stokvelId;
  final String period;
  final double targetAmount;
  final int version;
  final DateTime? endDate;
  final String status;
  final DateTime? dueDate;
  final int totalCollectedCents;
  final int amountDueCents;

  Map<String, Object?> toJson() => _$ContributionCycleResponseToJson(this);
}
