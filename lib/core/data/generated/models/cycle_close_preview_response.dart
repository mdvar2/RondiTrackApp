// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'cycle_arrear_preview.dart';

part 'cycle_close_preview_response.g.dart';

@JsonSerializable()
class CycleClosePreviewResponse {
  const CycleClosePreviewResponse({
    required this.cycleId,
    required this.period,
    required this.asOfDate,
    required this.version,
    required this.arrears,
    required this.totalCents,
  });
  
  factory CycleClosePreviewResponse.fromJson(Map<String, Object?> json) => _$CycleClosePreviewResponseFromJson(json);
  
  final String cycleId;
  final String period;
  final DateTime asOfDate;
  final String version;
  final List<CycleArrearPreview> arrears;
  final int totalCents;

  Map<String, Object?> toJson() => _$CycleClosePreviewResponseToJson(this);
}
