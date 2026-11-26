// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'cycle_arrear_preview.g.dart';

@JsonSerializable()
class CycleArrearPreview {
  const CycleArrearPreview({
    required this.userId,
    required this.userName,
    required this.amountCents,
  });
  
  factory CycleArrearPreview.fromJson(Map<String, Object?> json) => _$CycleArrearPreviewFromJson(json);
  
  final String userId;
  final String userName;
  final int amountCents;

  Map<String, Object?> toJson() => _$CycleArrearPreviewToJson(this);
}
