// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stokvel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StokvelResponse _$StokvelResponseFromJson(Map<String, dynamic> json) =>
    StokvelResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      contributionAmount: (json['contributionAmount'] as num).toDouble(),
      memberCount: (json['memberCount'] as num).toInt(),
      version: (json['version'] as num).toInt(),
    );

Map<String, dynamic> _$StokvelResponseToJson(StokvelResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'contributionAmount': instance.contributionAmount,
      'memberCount': instance.memberCount,
      'version': instance.version,
    };
