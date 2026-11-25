// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_payout_request.g.dart';

@JsonSerializable()
class CreatePayoutRequest {
  const CreatePayoutRequest({required this.amount});

  factory CreatePayoutRequest.fromJson(Map<String, Object?> json) =>
      _$CreatePayoutRequestFromJson(json);

  final double amount;

  Map<String, Object?> toJson() => _$CreatePayoutRequestToJson(this);
}
