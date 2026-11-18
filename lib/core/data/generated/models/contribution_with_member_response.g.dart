// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contribution_with_member_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContributionWithMemberResponse _$ContributionWithMemberResponseFromJson(
  Map<String, dynamic> json,
) => ContributionWithMemberResponse(
  id: json['id'] as String,
  stokvelId: json['stokvelId'] as String,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  userEmail: json['userEmail'] as String,
  memberRole: json['memberRole'] as String,
  contributionCycleId: json['contributionCycleId'] as String,
  amount: (json['amount'] as num).toInt(),
  status: json['status'] as String,
  recordedAtUtc: DateTime.parse(json['recordedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$ContributionWithMemberResponseToJson(
  ContributionWithMemberResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'stokvelId': instance.stokvelId,
  'userId': instance.userId,
  'userName': instance.userName,
  'userEmail': instance.userEmail,
  'memberRole': instance.memberRole,
  'contributionCycleId': instance.contributionCycleId,
  'amount': instance.amount,
  'status': instance.status,
  'recordedAtUtc': instance.recordedAtUtc.toIso8601String(),
  'version': instance.version,
};
