import 'package:flutter/material.dart';
import 'package:ronditrack_app/core/money/rand_format.dart';
import 'package:ronditrack_app/features/stokvels/domain/status_labels.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/presentation/status_chips.dart';

/// One member's contribution: who, their role, how much, and its status in
/// words. Laid out to wrap, not overflow, with very large text.
class ContributionRow extends StatelessWidget {
  /// Creates the row.
  new({required this.contribution})
    : super(key: Key('contribution-${contribution.id}'));

  /// The contribution.
  final Contribution contribution;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contribution.memberName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(stokvelRoleLabel(contribution.memberRole)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatRand(contribution.amount), textAlign: TextAlign.end),
                const SizedBox(height: 4),
                ContributionStatusChip(contribution.status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
