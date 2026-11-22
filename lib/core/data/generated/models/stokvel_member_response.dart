// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'stokvel_member_response.g.dart';

@JsonSerializable()
class StokvelMemberResponse {
  const StokvelMemberResponse({
    required this.stokvelId,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.role,
    required this.joinedAtUtc,
    required this.version,
  });

  factory StokvelMemberResponse.fromJson(Map<String, Object?> json) =>
      _$StokvelMemberResponseFromJson(json);

  final String stokvelId;
  final String userId;
  final String userName;
  final String userEmail;
  final String role;
  final DateTime joinedAtUtc;
  final int version;

  Map<String, Object?> toJson() => _$StokvelMemberResponseToJson(this);
}
