// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stokvel_member_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StokvelMemberResponse _$StokvelMemberResponseFromJson(
  Map<String, dynamic> json,
) => StokvelMemberResponse(
  stokvelId: json['stokvelId'] as String,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  userEmail: json['userEmail'] as String,
  role: json['role'] as String,
  joinedAtUtc: DateTime.parse(json['joinedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$StokvelMemberResponseToJson(
  StokvelMemberResponse instance,
) => <String, dynamic>{
  'stokvelId': instance.stokvelId,
  'userId': instance.userId,
  'userName': instance.userName,
  'userEmail': instance.userEmail,
  'role': instance.role,
  'joinedAtUtc': instance.joinedAtUtc.toIso8601String(),
  'version': instance.version,
};
