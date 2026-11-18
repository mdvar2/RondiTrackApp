// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_cycle_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeCycleResponse _$HomeCycleResponseFromJson(Map<String, dynamic> json) =>
    HomeCycleResponse(
      period: json['period'] as String,
      status: json['status'] as String,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
    );

Map<String, dynamic> _$HomeCycleResponseToJson(HomeCycleResponse instance) =>
    <String, dynamic>{
      'period': instance.period,
      'status': instance.status,
      'dueDate': instance.dueDate?.toIso8601String(),
    };
