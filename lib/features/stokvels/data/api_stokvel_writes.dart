import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ronditrack_app/core/data/api_values.dart';
import 'package:ronditrack_app/core/data/generated/models/stokvel_response.dart';
import 'package:ronditrack_app/core/data/generated/rondi_track_api.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/money/rand_decimal.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/core/time/sast.dart';
import 'package:ronditrack_app/features/stokvels/data/stokvel_mapper.dart';
import 'package:ronditrack_app/features/stokvels/domain/contributions_list.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_editor.dart';

/// [ContributionsRepository] on the API.
class ApiContributionsRepository implements ContributionsRepository {
  /// Creates the repository.
  new(this._api);

  final RondiTrackApi _api;

  @override
  Future<Result<List<CycleOption>>> fetchCycles(String stokvelId) =>
      guard(() async {
        final cycles =
            (await _api.contributionCycles.getApiV1StokvelsStokvelIdCycles(
              stokvelId: stokvelId,
            )).data;
        final options = [
          for (final cycle in cycles)
            (
              id: cycle.id,
              period: cycle.period,
              dueDate: switch (cycle.dueDate) {
                null => null,
                final DateTime due => calendarDateOf(due),
              },
            ),
        ]..sort((a, b) => b.period.compareTo(a.period));
        return options;
      });

  @override
  Future<Result<List<MemberOption>>> fetchMembers(String stokvelId) => guard(
    () => allPages((token) async {
      final page = (await _api.stokvels.getApiV1StokvelsStokvelIdMembers(
        stokvelId: stokvelId,
        pageToken: token,
        pageSize: ContributionsRepository.maxPageSize,
      )).data;
      // Names only: a member's email is never kept.
      return (
        items: [
          for (final m in page.items) (userId: m.userId, name: m.userName),
        ],
        next: nextPageOf(page.nextPageToken),
      );
    }),
  );

  @override
  Future<Result<ContributionPage>> fetchPage(
    String stokvelId,
    ContributionFilter filter, {
    String? pageToken,
    int pageSize = 25,
  }) => guard(() async {
    final first = filter.firstDay;
    final last = filter.lastDay ?? first;
    // South African days as the API's half-open instants (README "Money
    // and dates"), whatever zone the phone is in.
    final bounds = first == null || last == null
        ? null
        : Sast.bounds(first, last);
    final response = await _api.contributionCycles
        .getApiV1StokvelsStokvelIdCyclesCycleIdContributions(
          stokvelId: stokvelId,
          cycleId: filter.cycleId,
          pageToken: pageToken,
          pageSize: pageSize.clamp(1, ContributionsRepository.maxPageSize),
          userId: filter.userId,
          status: filter.status?.apiValue,
          recordedFrom: bounds?.from,
          recordedBefore: bounds?.before,
        );
    final page = contributionPageFrom(response.data);
    return ContributionPage(page.items, nextPageToken: page.next);
  });
}

/// [StokvelEditor] on the API. The bodies are written as JSON text, so the
/// amounts (rands, as the API takes them) are exact decimals.
class ApiStokvelEditor implements StokvelEditor {
  /// Creates the editor over the session's client.
  new(this._dio);

  final Dio _dio;

  static String _period(CalendarDate due) =>
      '${due.year}-${due.month.toString().padLeft(2, '0')}';

  Future<Response<Object?>> _send(
    String method,
    String path,
    String json, {
    Map<String, String> headers = const {},
  }) => _dio.request<Object?>(
    path,
    data: json,
    options: Options(
      method: method,
      contentType: Headers.jsonContentType,
      headers: headers,
    ),
  );

  @override
  Future<Result<String>> createStokvel({
    required String name,
    required Cents contribution,
    required CalendarDate firstDueDate,
  }) => guard(() async {
    final created = await _send(
      'POST',
      '/api/v1/stokvels',
      '{"name":${jsonEncode(name.trim())},'
          '"contributionAmount":${randDecimalText(contribution)}}',
    );
    final stokvel = StokvelResponse.fromJson(
      created.data! as Map<String, Object?>,
    );
    await _send(
      'POST',
      '/api/v1/stokvels/${stokvel.id}/cycles',
      '{"period":${jsonEncode(_period(firstDueDate))},'
          '"targetAmount":${randDecimalText(contribution)},'
          '"endDate":${jsonEncode(firstDueDate.toString())}}',
    );
    return stokvel.id;
  });

  @override
  Future<Result<void>> updateCycle({
    required String stokvelId,
    required StokvelCycle cycle,
    required Cents target,
    required CalendarDate dueDate,
  }) => guard(() async {
    await _send(
      'PUT',
      '/api/v1/stokvels/$stokvelId/cycles/${cycle.id}',
      '{"period":${jsonEncode(cycle.period)},'
          '"targetAmount":${randDecimalText(target)},'
          '"endDate":${jsonEncode(dueDate.toString())}}',
      headers: {
        if (cycle.concurrencyToken case final token?) 'If-Match': token.value,
      },
    );
  });
}
