// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_result_of_contribution_with_member_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedResultOfContributionWithMemberResponse
_$PagedResultOfContributionWithMemberResponseFromJson(
  Map<String, dynamic> json,
) => PagedResultOfContributionWithMemberResponse(
  items: (json['items'] as List<dynamic>)
      .map(
        (e) =>
            ContributionWithMemberResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  nextPageToken: json['nextPageToken'] as String,
  pageSize: (json['pageSize'] as num).toInt(),
  hasMore: json['hasMore'] as bool?,
);

Map<String, dynamic> _$PagedResultOfContributionWithMemberResponseToJson(
  PagedResultOfContributionWithMemberResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'nextPageToken': instance.nextPageToken,
  'pageSize': instance.pageSize,
  'hasMore': instance.hasMore,
};
