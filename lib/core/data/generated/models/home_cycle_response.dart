// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'home_cycle_response.g.dart';

@JsonSerializable()
class HomeCycleResponse {
  const HomeCycleResponse({
    required this.period,
    required this.status,
    required this.dueDate,
  });
  
  factory HomeCycleResponse.fromJson(Map<String, Object?> json) => _$HomeCycleResponseFromJson(json);
  
  final String period;
  final String status;
  final DateTime? dueDate;

  Map<String, Object?> toJson() => _$HomeCycleResponseToJson(this);
}
