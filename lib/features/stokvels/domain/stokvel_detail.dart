import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/features/stokvels/domain/membership.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';

part 'stokvel_detail.freezed.dart';

/// Everything the stokvel detail screen shows for one stokvel.
@freezed
abstract class StokvelDetail with _$StokvelDetail {
  /// Creates a stokvel detail.
  const factory({
    /// The stokvel (`GET /stokvels/{id}`).
    required Stokvel stokvel,

    /// The caller's membership: `id` and `role` from the same response.
    required Membership membership,

    /// The current cycle, `null` when there is none.
    required StokvelCycle? currentCycle,

    /// The current cycle's contributions, newest first.
    required List<Contribution> contributions,
  }) = _StokvelDetail;
}

/// One cycle of one stokvel, for the cycle screen
/// (`GET /stokvels/{stokvelId}/cycles/{cycleId}` and its contributions).
@freezed
abstract class CycleDetail with _$CycleDetail {
  /// Creates a cycle detail.
  const factory({
    /// The stokvel the cycle belongs to.
    required Stokvel stokvel,

    /// The cycle.
    required StokvelCycle cycle,

    /// The cycle's contributions, newest first.
    required List<Contribution> contributions,
  }) = _CycleDetail;
}

/// A stokvel (`StokvelDetailResponse`).
@freezed
abstract class Stokvel with _$Stokvel {
  /// Creates a stokvel.
  const factory({
    /// `id`.
    required String id,

    /// `name`.
    required String name,

    /// `contributionAmountCents`. The API's `contributionAmount` is a
    /// double and is never read.
    required Cents contributionAmount,

    /// `memberCount`.
    required int memberCount,
  }) = _Stokvel;
}

/// A contribution cycle (`ContributionCycleResponse` and
/// `StokvelCycleSummaryResponse`).
@freezed
abstract class StokvelCycle with _$StokvelCycle {
  /// Creates a cycle.
  const factory({
    /// `id`, from `GET /stokvels/{id}/cycles`. The detail response's
    /// `currentCycle` has no id; see README "Contract notes".
    required String id,

    /// `period`, such as `2026-11`.
    required String period,

    /// `status`.
    required CycleStatus status,

    /// `dueDate`, date-only, `null` when the cycle has no end date.
    required CalendarDate? dueDate,

    /// `membersPaid`.
    required int membersPaid,

    /// `collectedCents`.
    required Cents collected,

    /// `targetCents`.
    required Cents target,
  }) = _StokvelCycle;
}

/// One member's contribution (`ContributionWithMemberResponse`).
///
/// The API's `userEmail` is deliberately not kept: the screen doesn't show
/// it, and the app keeps no personal data it doesn't need.
@freezed
abstract class Contribution with _$Contribution {
  /// Creates a contribution.
  const factory({
    /// `id`.
    required String id,

    /// `userId`.
    required String userId,

    /// `userName`.
    required String memberName,

    /// `memberRole`.
    required StokvelRole memberRole,

    /// `amount`, in cents.
    required Cents amount,

    /// `status`.
    required ContributionStatus status,

    /// `recordedAtUtc`, an instant.
    required DateTime recordedAt,
  }) = _Contribution;
}
