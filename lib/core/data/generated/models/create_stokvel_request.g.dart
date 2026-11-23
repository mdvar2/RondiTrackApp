// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_stokvel_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateStokvelRequest _$CreateStokvelRequestFromJson(
  Map<String, dynamic> json,
) => CreateStokvelRequest(
  name: json['name'] as String,
  contributionAmount: (json['contributionAmount'] as num).toDouble(),
);

Map<String, dynamic> _$CreateStokvelRequestToJson(
  CreateStokvelRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'contributionAmount': instance.contributionAmount,
};
