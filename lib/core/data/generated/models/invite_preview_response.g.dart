// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_preview_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvitePreviewResponse _$InvitePreviewResponseFromJson(
  Map<String, dynamic> json,
) => InvitePreviewResponse(
  stokvelId: json['stokvelId'] as String,
  name: json['name'] as String,
  contributionAmountCents: (json['contributionAmountCents'] as num).toInt(),
  schedule: json['schedule'] as String,
  rules: json['rules'] as String,
  memberCount: (json['memberCount'] as num).toInt(),
);

Map<String, dynamic> _$InvitePreviewResponseToJson(
  InvitePreviewResponse instance,
) => <String, dynamic>{
  'stokvelId': instance.stokvelId,
  'name': instance.name,
  'contributionAmountCents': instance.contributionAmountCents,
  'schedule': instance.schedule,
  'rules': instance.rules,
  'memberCount': instance.memberCount,
};
