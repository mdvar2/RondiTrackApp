// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'home_cycle_response.dart';

part 'home_stokvel_response.g.dart';

@JsonSerializable()
class HomeStokvelResponse {
  const HomeStokvelResponse({
    required this.stokvelId,
    required this.stokvelName,
    required this.role,
    required this.currentCycle,
    required this.amountPaid,
    required this.amountOwed,
    required this.nextPayoutDate,
    required this.arrearsCents,
  });

  factory HomeStokvelResponse.fromJson(Map<String, Object?> json) =>
      _$HomeStokvelResponseFromJson(json);

  final String stokvelId;
  final String stokvelName;
  final String role;
  final HomeCycleResponse? currentCycle;
  final int amountPaid;
  final int amountOwed;
  final DateTime? nextPayoutDate;
  final int arrearsCents;

  Map<String, Object?> toJson() => _$HomeStokvelResponseToJson(this);
}
