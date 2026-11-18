// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stokvel_cycle_summary_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StokvelCycleSummaryResponse _$StokvelCycleSummaryResponseFromJson(
  Map<String, dynamic> json,
) => StokvelCycleSummaryResponse(
  id: json['id'] as String,
  period: json['period'] as String,
  status: json['status'] as String,
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  membersPaid: (json['membersPaid'] as num).toInt(),
  collectedCents: (json['collectedCents'] as num).toInt(),
  targetCents: (json['targetCents'] as num).toInt(),
);

Map<String, dynamic> _$StokvelCycleSummaryResponseToJson(
  StokvelCycleSummaryResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'period': instance.period,
  'status': instance.status,
  'dueDate': instance.dueDate?.toIso8601String(),
  'membersPaid': instance.membersPaid,
  'collectedCents': instance.collectedCents,
  'targetCents': instance.targetCents,
};
