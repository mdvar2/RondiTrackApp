import 'package:ronditrack_app/core/concurrency/concurrency_token.dart';
import 'package:ronditrack_app/core/data/api_values.dart';
import 'package:ronditrack_app/core/data/generated/models/contribution_cycle_response.dart';
import 'package:ronditrack_app/core/data/generated/models/contribution_with_member_response.dart';
import 'package:ronditrack_app/core/data/generated/models/cycle_close_preview_response.dart';
import 'package:ronditrack_app/core/data/generated/models/paged_result_of_contribution_with_member_response.dart';
import 'package:ronditrack_app/core/data/generated/models/stokvel_cycle_summary_response.dart';
import 'package:ronditrack_app/core/data/generated/models/stokvel_detail_response.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/features/stokvels/domain/cycle_close_preview.dart';
import 'package:ronditrack_app/features/stokvels/domain/membership.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';

// The stokvels feature's generated types become domain types here, and go
// no further. Statuses and roles into their enums (`unknown` for a spelling
// the app doesn't know), money as Cents (never the API's rands doubles),
// due dates as calendar days, instants in UTC, the ETag kept as sent.

/// `StokvelDetailResponse` as a [Stokvel], with the response's [etag].
Stokvel stokvelFrom(StokvelDetailResponse response, ConcurrencyToken? etag) =>
    Stokvel(
      id: response.id,
      name: response.name,
      contributionAmount: Cents(response.contributionAmountCents),
      memberCount: response.memberCount,
      concurrencyToken: etag,
    );

/// The caller's [Membership], from the same response's `role`.
Membership membershipFrom(StokvelDetailResponse response) => Membership(
  stokvelId: response.id,
  role: StokvelRole.fromApi(response.role),
);

/// The current cycle's summary as a [StokvelCycle]. [etag] is
/// `GET …/cycles/{cycleId}`'s, when that was fetched too.
StokvelCycle cycleFromSummary(
  StokvelCycleSummaryResponse summary, {
  ConcurrencyToken? etag,
}) => StokvelCycle(
  id: summary.id,
  period: summary.period,
  status: CycleStatus.fromApi(summary.status),
  dueDate: switch (summary.dueDate) {
    null => null,
    final DateTime due => calendarDateOf(due),
  },
  membersPaid: summary.membersPaid,
  collected: Cents(summary.collectedCents),
  target: Cents(summary.targetCents),
  concurrencyToken: etag,
);

/// A cycle that isn't the stokvel's current one, from
/// `ContributionCycleResponse`, which has no `membersPaid` and no target in
/// cents (README "Contract notes", gap 14). They follow the API's own
/// definitions: members paid is the number of members with a contribution
/// (as `StokvelDetailService` counts it), and the target is what was
/// collected plus `amountDueCents`, which the API sends as the target less
/// what was collected. The app's own links only ever open current cycles,
/// which come from the summary instead.
StokvelCycle cycleFromResponse(
  ContributionCycleResponse response, {
  required List<Contribution> contributions,
  ConcurrencyToken? etag,
}) => StokvelCycle(
  id: response.id,
  period: response.period,
  status: CycleStatus.fromApi(response.status),
  dueDate: switch (response.dueDate) {
    null => null,
    final DateTime due => calendarDateOf(due),
  },
  membersPaid: contributions.map((c) => c.userId).toSet().length,
  collected: Cents(response.totalCollectedCents),
  target: Cents(response.totalCollectedCents + response.amountDueCents),
  concurrencyToken: etag,
);

/// `ContributionWithMemberResponse` as a [Contribution]. `amount` is int64
/// cents on the wire; `userEmail` is never kept.
Contribution contributionFrom(ContributionWithMemberResponse response) =>
    Contribution(
      id: response.id,
      userId: response.userId,
      memberName: response.userName,
      memberRole: StokvelRole.fromApi(response.memberRole),
      amount: Cents(response.amount),
      status: ContributionStatus.fromApi(response.status),
      recordedAt: instantOf(response.recordedAtUtc),
    );

/// One page of contributions, its end marker as "no more pages".
Page<Contribution> contributionPageFrom(
  PagedResultOfContributionWithMemberResponse page,
) => (
  items: [for (final item in page.items) contributionFrom(item)],
  next: nextPageOf(page.nextPageToken),
);

/// `CycleClosePreviewResponse` as a [CycleClosePreview], its `version`
/// kept exactly as sent.
CycleClosePreview closePreviewFrom(CycleClosePreviewResponse response) =>
    CycleClosePreview(
      cycleId: response.cycleId,
      period: response.period,
      asOf: calendarDateOf(response.asOfDate),
      version: ConcurrencyToken(response.version),
      arrears: [
        for (final arrear in response.arrears)
          CloseArrear(
            userId: arrear.userId,
            memberName: arrear.userName,
            amount: Cents(arrear.amountCents),
          ),
      ],
      total: Cents(response.totalCents),
    );
