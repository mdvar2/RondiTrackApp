// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'contribution_with_member_response.g.dart';

@JsonSerializable()
class ContributionWithMemberResponse {
  const ContributionWithMemberResponse({
    required this.id,
    required this.stokvelId,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.memberRole,
    required this.contributionCycleId,
    required this.amount,
    required this.status,
    required this.recordedAtUtc,
    required this.version,
  });

  factory ContributionWithMemberResponse.fromJson(Map<String, Object?> json) =>
      _$ContributionWithMemberResponseFromJson(json);

  final String id;
  final String stokvelId;
  final String userId;
  final String userName;
  final String userEmail;
  final String memberRole;
  final String contributionCycleId;
  final int amount;
  final String status;
  final DateTime recordedAtUtc;
  final int version;

  Map<String, Object?> toJson() => _$ContributionWithMemberResponseToJson(this);
}
