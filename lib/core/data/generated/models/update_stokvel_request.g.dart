// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_stokvel_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateStokvelRequest _$UpdateStokvelRequestFromJson(
  Map<String, dynamic> json,
) => UpdateStokvelRequest(
  name: json['name'] as String,
  contributionAmount: (json['contributionAmount'] as num).toDouble(),
);

Map<String, dynamic> _$UpdateStokvelRequestToJson(
  UpdateStokvelRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'contributionAmount': instance.contributionAmount,
};
