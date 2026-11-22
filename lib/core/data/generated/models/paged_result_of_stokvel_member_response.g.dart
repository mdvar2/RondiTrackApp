// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_result_of_stokvel_member_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedResultOfStokvelMemberResponse _$PagedResultOfStokvelMemberResponseFromJson(
  Map<String, dynamic> json,
) => PagedResultOfStokvelMemberResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => StokvelMemberResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextPageToken: json['nextPageToken'] as String,
  pageSize: (json['pageSize'] as num).toInt(),
  hasMore: json['hasMore'] as bool?,
);

Map<String, dynamic> _$PagedResultOfStokvelMemberResponseToJson(
  PagedResultOfStokvelMemberResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'nextPageToken': instance.nextPageToken,
  'pageSize': instance.pageSize,
  'hasMore': instance.hasMore,
};
