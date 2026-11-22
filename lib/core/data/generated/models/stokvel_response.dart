// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'stokvel_response.g.dart';

@JsonSerializable()
class StokvelResponse {
  const StokvelResponse({
    required this.id,
    required this.name,
    required this.contributionAmount,
    required this.memberCount,
    required this.version,
  });

  factory StokvelResponse.fromJson(Map<String, Object?> json) =>
      _$StokvelResponseFromJson(json);

  final String id;
  final String name;
  final double contributionAmount;
  final int memberCount;
  final int version;

  Map<String, Object?> toJson() => _$StokvelResponseToJson(this);
}
