import 'package:ronditrack_app/core/data/api_values.dart';
import 'package:ronditrack_app/core/data/generated/models/home_cycle_response.dart';
import 'package:ronditrack_app/core/data/generated/models/home_stokvel_response.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/features/home/domain/home_entry.dart';
import 'package:ronditrack_app/features/stokvels/domain/membership.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';

/// `HomeStokvelResponse` as a [HomeEntry]: the role and cycle status into
/// their enums (an unknown spelling is `unknown`), money as [Cents], the
/// due date as a calendar day, the next payout as a UTC instant.
HomeEntry homeEntryFrom(HomeStokvelResponse response) => HomeEntry(
  membership: Membership(
    stokvelId: response.stokvelId,
    role: StokvelRole.fromApi(response.role),
  ),
  stokvelName: response.stokvelName,
  currentCycle: switch (response.currentCycle) {
    null => null,
    final HomeCycleResponse cycle => HomeCycle(
      period: cycle.period,
      status: CycleStatus.fromApi(cycle.status),
      dueDate: switch (cycle.dueDate) {
        null => null,
        final DateTime due => calendarDateOf(due),
      },
    ),
  },
  amountPaid: Cents(response.amountPaid),
  amountOwed: Cents(response.amountOwed),
  arrears: Cents(response.arrearsCents),
  nextPayoutDate: switch (response.nextPayoutDate) {
    null => null,
    final DateTime next => instantOf(next),
  },
);
