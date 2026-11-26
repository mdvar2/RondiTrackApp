// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_stokvel_request.g.dart';

@JsonSerializable()
class UpdateStokvelRequest {
  const UpdateStokvelRequest({
    required this.name,
    required this.contributionAmount,
  });
  
  factory UpdateStokvelRequest.fromJson(Map<String, Object?> json) => _$UpdateStokvelRequestFromJson(json);
  
  final String name;
  final double contributionAmount;

  Map<String, Object?> toJson() => _$UpdateStokvelRequestToJson(this);
}
