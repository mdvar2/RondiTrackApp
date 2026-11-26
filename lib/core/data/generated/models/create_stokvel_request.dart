// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_stokvel_request.g.dart';

@JsonSerializable()
class CreateStokvelRequest {
  const CreateStokvelRequest({
    required this.name,
    required this.contributionAmount,
  });
  
  factory CreateStokvelRequest.fromJson(Map<String, Object?> json) => _$CreateStokvelRequestFromJson(json);
  
  final String name;
  final double contributionAmount;

  Map<String, Object?> toJson() => _$CreateStokvelRequestToJson(this);
}
