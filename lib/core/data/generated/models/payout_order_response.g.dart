// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayoutOrderResponse _$PayoutOrderResponseFromJson(Map<String, dynamic> json) =>
    PayoutOrderResponse(
      stokvelId: json['stokvelId'] as String,
      cycleId: json['cycleId'] as String,
      items: (json['items'] as List<dynamic>)
          .map(
            (e) => PayoutOrderEntryResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$PayoutOrderResponseToJson(
  PayoutOrderResponse instance,
) => <String, dynamic>{
  'stokvelId': instance.stokvelId,
  'cycleId': instance.cycleId,
  'items': instance.items,
};
