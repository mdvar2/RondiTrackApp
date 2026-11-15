import 'package:flutter/material.dart';
import 'package:ronditrack_app/core/theme/status_chip.dart';
import 'package:ronditrack_app/core/theme/status_colors.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_status.dart';

/// The colour token for a payout status.
///
/// Exhaustive, with no wildcard: a new status is a compile error here until
/// someone picks its colour.
StatusToken payoutStatusToken(PayoutStatus status) => switch (status) {
  PayoutStatus.paid => StatusToken.payoutPaid,
  PayoutStatus.next => StatusToken.payoutNext,
  PayoutStatus.waiting => StatusToken.payoutWaiting,
  PayoutStatus.unknown => StatusToken.unknown,
};

/// A payout status, in words, on its colour. The words always say it; the
/// colour only helps.
class PayoutStatusChip extends StatelessWidget {
  /// Creates the chip.
  const new(this.status, {super.key});

  /// The status.
  final PayoutStatus status;

  @override
  Widget build(BuildContext context) => StatusChip(
    label: payoutStatusLabel(status),
    token: payoutStatusToken(status),
  );
}
