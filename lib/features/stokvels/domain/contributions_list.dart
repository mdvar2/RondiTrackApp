import 'package:flutter/foundation.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';

/// What the contributions list shows: one cycle, and optionally one
/// status, one member and a range of South African days ([firstDay] to
/// [lastDay], both included, as a person picks them).
@immutable
class ContributionFilter {
  /// Creates the filter.
  const new({
    required this.cycleId,
    this.status,
    this.userId,
    this.firstDay,
    this.lastDay,
  });

  /// The cycle.
  final String cycleId;

  /// Only this status.
  final ContributionStatus? status;

  /// Only this member.
  final String? userId;

  /// From this South African day.
  final CalendarDate? firstDay;

  /// To this South African day, included.
  final CalendarDate? lastDay;

  /// Whether anything beyond the cycle narrows it.
  bool get isNarrowed =>
      status != null || userId != null || firstDay != null || lastDay != null;

  /// The same cycle, nothing else.
  ContributionFilter cleared() => ContributionFilter(cycleId: cycleId);

  @override
  bool operator ==(Object other) =>
      other is ContributionFilter &&
      other.cycleId == cycleId &&
      other.status == status &&
      other.userId == userId &&
      other.firstDay == firstDay &&
      other.lastDay == lastDay;

  @override
  int get hashCode => Object.hash(cycleId, status, userId, firstDay, lastDay);
}

/// One page of the list, and the token for the next; `null` at the end.
@immutable
class ContributionPage {
  /// Creates the page.
  const new(this.items, {this.nextPageToken});

  /// The contributions on it.
  final List<Contribution> items;

  /// The next page's token; `null` when this is the last page.
  final String? nextPageToken;
}

/// A cycle the list can show.
typedef CycleOption = ({String id, String period, CalendarDate? dueDate});

/// A member the list can be narrowed to.
typedef MemberOption = ({String userId, String name});

/// The contributions list's data: `GET …/cycles`, `GET …/members` and
/// `GET …/cycles/{cycleId}/contributions` with its filters and paging.
abstract interface class ContributionsRepository {
  /// The largest page the API gives: asking for more gets this many.
  static const maxPageSize = 100;

  /// The stokvel's cycles, newest first.
  Future<Result<List<CycleOption>>> fetchCycles(String stokvelId);

  /// The stokvel's members.
  Future<Result<List<MemberOption>>> fetchMembers(String stokvelId);

  /// One page of [filter]'s contributions, newest first. [pageToken] is
  /// the previous page's, only ever with the same filter.
  Future<Result<ContributionPage>> fetchPage(
    String stokvelId,
    ContributionFilter filter, {
    String? pageToken,
    int pageSize,
  });
}
