// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'stokvel_cycle_summary_response.g.dart';

@JsonSerializable()
class StokvelCycleSummaryResponse {
  const StokvelCycleSummaryResponse({
    required this.id,
    required this.period,
    required this.status,
    required this.dueDate,
    required this.membersPaid,
    required this.collectedCents,
    required this.targetCents,
  });
  
  factory StokvelCycleSummaryResponse.fromJson(Map<String, Object?> json) => _$StokvelCycleSummaryResponseFromJson(json);
  
  final String id;
  final String period;
  final String status;
  final DateTime? dueDate;
  final int membersPaid;
  final int collectedCents;
  final int targetCents;

  Map<String, Object?> toJson() => _$StokvelCycleSummaryResponseToJson(this);
}
