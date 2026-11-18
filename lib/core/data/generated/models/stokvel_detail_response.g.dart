// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stokvel_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StokvelDetailResponse _$StokvelDetailResponseFromJson(
  Map<String, dynamic> json,
) => StokvelDetailResponse(
  id: json['id'] as String,
  name: json['name'] as String,
  contributionAmount: (json['contributionAmount'] as num).toDouble(),
  memberCount: (json['memberCount'] as num).toInt(),
  version: (json['version'] as num).toInt(),
  contributionAmountCents: (json['contributionAmountCents'] as num).toInt(),
  role: json['role'] as String,
  currentCycle: json['currentCycle'] == null
      ? null
      : StokvelCycleSummaryResponse.fromJson(
          json['currentCycle'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$StokvelDetailResponseToJson(
  StokvelDetailResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'contributionAmount': instance.contributionAmount,
  'memberCount': instance.memberCount,
  'version': instance.version,
  'contributionAmountCents': instance.contributionAmountCents,
  'role': instance.role,
  'currentCycle': instance.currentCycle,
};
