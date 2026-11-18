// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_stokvel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeStokvelResponse _$HomeStokvelResponseFromJson(Map<String, dynamic> json) =>
    HomeStokvelResponse(
      stokvelId: json['stokvelId'] as String,
      stokvelName: json['stokvelName'] as String,
      role: json['role'] as String,
      currentCycle: json['currentCycle'] == null
          ? null
          : HomeCycleResponse.fromJson(
              json['currentCycle'] as Map<String, dynamic>,
            ),
      amountPaid: (json['amountPaid'] as num).toInt(),
      amountOwed: (json['amountOwed'] as num).toInt(),
      nextPayoutDate: json['nextPayoutDate'] == null
          ? null
          : DateTime.parse(json['nextPayoutDate'] as String),
      arrearsCents: (json['arrearsCents'] as num).toInt(),
    );

Map<String, dynamic> _$HomeStokvelResponseToJson(
  HomeStokvelResponse instance,
) => <String, dynamic>{
  'stokvelId': instance.stokvelId,
  'stokvelName': instance.stokvelName,
  'role': instance.role,
  'currentCycle': instance.currentCycle,
  'amountPaid': instance.amountPaid,
  'amountOwed': instance.amountOwed,
  'nextPayoutDate': instance.nextPayoutDate?.toIso8601String(),
  'arrearsCents': instance.arrearsCents,
};
