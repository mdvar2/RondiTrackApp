// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'stokvel_member_response.dart';

part 'paged_result_of_stokvel_member_response.g.dart';

@JsonSerializable()
class PagedResultOfStokvelMemberResponse {
  const PagedResultOfStokvelMemberResponse({
    required this.items,
    required this.nextPageToken,
    required this.pageSize,
    this.hasMore,
  });

  factory PagedResultOfStokvelMemberResponse.fromJson(
    Map<String, Object?> json,
  ) => _$PagedResultOfStokvelMemberResponseFromJson(json);

  final List<StokvelMemberResponse> items;
  final String nextPageToken;
  final int pageSize;
  final bool? hasMore;

  Map<String, Object?> toJson() =>
      _$PagedResultOfStokvelMemberResponseToJson(this);
}
