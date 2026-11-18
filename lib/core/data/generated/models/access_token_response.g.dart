// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessTokenResponse _$AccessTokenResponseFromJson(Map<String, dynamic> json) =>
    AccessTokenResponse(
      accessToken: json['accessToken'] as String,
      expiresAtUtc: DateTime.parse(json['expiresAtUtc'] as String),
    );

Map<String, dynamic> _$AccessTokenResponseToJson(
  AccessTokenResponse instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'expiresAtUtc': instance.expiresAtUtc.toIso8601String(),
};
