// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle_arrear_preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CycleArrearPreview _$CycleArrearPreviewFromJson(Map<String, dynamic> json) =>
    CycleArrearPreview(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      amountCents: (json['amountCents'] as num).toInt(),
    );

Map<String, dynamic> _$CycleArrearPreviewToJson(CycleArrearPreview instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'amountCents': instance.amountCents,
    };
