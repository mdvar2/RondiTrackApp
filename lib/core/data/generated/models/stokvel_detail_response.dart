// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'stokvel_cycle_summary_response.dart';

part 'stokvel_detail_response.g.dart';

@JsonSerializable()
class StokvelDetailResponse {
  const StokvelDetailResponse({
    required this.id,
    required this.name,
    required this.contributionAmount,
    required this.memberCount,
    required this.version,
    required this.contributionAmountCents,
    required this.role,
    required this.currentCycle,
  });

  factory StokvelDetailResponse.fromJson(Map<String, Object?> json) =>
      _$StokvelDetailResponseFromJson(json);

  final String id;
  final String name;
  final double contributionAmount;
  final int memberCount;
  final int version;
  final int contributionAmountCents;
  final String role;
  final StokvelCycleSummaryResponse? currentCycle;

  Map<String, Object?> toJson() => _$StokvelDetailResponseToJson(this);
}
