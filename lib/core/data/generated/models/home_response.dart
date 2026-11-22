// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'home_stokvel_response.dart';

part 'home_response.g.dart';

@JsonSerializable()
class HomeResponse {
  const HomeResponse({required this.stokvels});

  factory HomeResponse.fromJson(Map<String, Object?> json) =>
      _$HomeResponseFromJson(json);

  final List<HomeStokvelResponse> stokvels;

  Map<String, Object?> toJson() => _$HomeResponseToJson(this);
}
