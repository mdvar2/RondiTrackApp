import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/features/stokvels/domain/membership.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';

part 'home_entry.freezed.dart';

/// One card on Home: what `GET /api/v1/me/home` returns for one stokvel
/// (`HomeStokvelResponse`).
///
/// Every number here is the API's. The app shows them and never computes
/// them.
@freezed
abstract class HomeEntry with _$HomeEntry {
  /// Creates a Home entry.
  const factory({
    /// `stokvelId` and `role`.
    required Membership membership,

    /// `stokvelName`.
    required String stokvelName,

    /// `currentCycle`, `null` when the stokvel has no cycle this month.
    required HomeCycle? currentCycle,

    /// `amountPaid`: what this person has paid in the current cycle.
    required Cents amountPaid,

    /// `amountOwed`: what this person still owes in the current cycle.
    required Cents amountOwed,

    /// `arrearsCents`: this person's recorded arrears in the stokvel.
    required Cents arrears,

    /// `nextPayoutDate`, an instant. The API always sends `null` today.
    required DateTime? nextPayoutDate,
  }) = _HomeEntry;

  const new _();

  /// The stokvel's id.
  String get stokvelId => membership.stokvelId;
}

/// The current cycle on a Home card (`HomeCycleResponse`).
@freezed
abstract class HomeCycle with _$HomeCycle {
  /// Creates a Home cycle.
  const factory({
    /// `period`, such as `2026-11`.
    required String period,

    /// `status`.
    required CycleStatus status,

    /// `dueDate`, a date-only value, `null` when the cycle has no end date.
    required CalendarDate? dueDate,
  }) = _HomeCycle;
}
