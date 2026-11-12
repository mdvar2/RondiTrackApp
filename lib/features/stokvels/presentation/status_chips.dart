import 'package:flutter/material.dart';
import 'package:ronditrack_app/core/theme/status_chip.dart';
import 'package:ronditrack_app/core/theme/status_colors.dart';
import 'package:ronditrack_app/features/stokvels/domain/status_labels.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';

// Each switch is exhaustive with no wildcard: a new status is a compile
// error here until someone picks its colour.

/// The colour token for a cycle's status.
StatusToken cycleStatusToken(CycleStatus status) => switch (status) {
  CycleStatus.open => StatusToken.cycleOpen,
  CycleStatus.closed => StatusToken.cycleClosed,
  CycleStatus.paidOut => StatusToken.cyclePaidOut,
  CycleStatus.unknown => StatusToken.unknown,
};

/// The colour token for a contribution's status.
StatusToken contributionStatusToken(ContributionStatus status) =>
    switch (status) {
      ContributionStatus.pending => StatusToken.contributionPending,
      ContributionStatus.paid => StatusToken.contributionPaid,
      ContributionStatus.confirmed => StatusToken.contributionConfirmed,
      ContributionStatus.unknown => StatusToken.unknown,
    };

/// A cycle's status, in words, on its colour.
class CycleStatusChip extends StatelessWidget {
  /// Creates the chip.
  const new(this.status, {super.key});

  /// The status.
  final CycleStatus status;

  @override
  Widget build(BuildContext context) => StatusChip(
    label: cycleStatusLabel(status),
    token: cycleStatusToken(status),
  );
}

/// A contribution's status, in words, on its colour.
class ContributionStatusChip extends StatelessWidget {
  /// Creates the chip.
  const new(this.status, {super.key});

  /// The status.
  final ContributionStatus status;

  @override
  Widget build(BuildContext context) => StatusChip(
    label: contributionStatusLabel(status),
    token: contributionStatusToken(status),
  );
}
