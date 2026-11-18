// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle_close_preview_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CycleClosePreviewResponse _$CycleClosePreviewResponseFromJson(
  Map<String, dynamic> json,
) => CycleClosePreviewResponse(
  cycleId: json['cycleId'] as String,
  period: json['period'] as String,
  asOfDate: DateTime.parse(json['asOfDate'] as String),
  version: json['version'] as String,
  arrears: (json['arrears'] as List<dynamic>)
      .map((e) => CycleArrearPreview.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCents: (json['totalCents'] as num).toInt(),
);

Map<String, dynamic> _$CycleClosePreviewResponseToJson(
  CycleClosePreviewResponse instance,
) => <String, dynamic>{
  'cycleId': instance.cycleId,
  'period': instance.period,
  'asOfDate': instance.asOfDate.toIso8601String(),
  'version': instance.version,
  'arrears': instance.arrears,
  'totalCents': instance.totalCents,
};
