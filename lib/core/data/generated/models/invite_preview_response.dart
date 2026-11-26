// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'invite_preview_response.g.dart';

@JsonSerializable()
class InvitePreviewResponse {
  const InvitePreviewResponse({
    required this.stokvelId,
    required this.name,
    required this.contributionAmountCents,
    required this.schedule,
    required this.rules,
    required this.memberCount,
  });
  
  factory InvitePreviewResponse.fromJson(Map<String, Object?> json) => _$InvitePreviewResponseFromJson(json);
  
  final String stokvelId;
  final String name;
  final int contributionAmountCents;
  final String schedule;
  final String rules;
  final int memberCount;

  Map<String, Object?> toJson() => _$InvitePreviewResponseToJson(this);
}
