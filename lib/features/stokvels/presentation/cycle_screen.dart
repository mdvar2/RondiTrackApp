import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/router/routes.dart';
import 'package:ronditrack_app/core/money/rand_format.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/core/time/date_format.dart';
import 'package:ronditrack_app/core/widgets/message_panel.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/presentation/contribution_row.dart';
import 'package:ronditrack_app/features/stokvels/presentation/status_chips.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_detail_provider.dart';

/// One cycle of one stokvel (`/stokvels/:id/cycles/:cycleId`): its
/// progress and contributions.
///
/// A cycle id that doesn't exist, belongs to another stokvel, or sits in a
/// stokvel I'm not in shows the same "not found".
class CycleScreen extends ConsumerWidget {
  /// Shows cycle [cycleId] of stokvel [stokvelId].
  const new({required this.stokvelId, required this.cycleId, super.key});

  /// The stokvel, from the address.
  final String stokvelId;

  /// The cycle, from the address.
  final String cycleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = cycleDetailProvider(stokvelId, cycleId);
    final view = cycleDetailViewState(ref.watch(provider));

    return Scaffold(
      appBar: AppBar(
        title: Text(switch (view) {
          ViewData(value: final detail) => 'Cycle ${detail.cycle.period}',
          _ => 'Cycle',
        }),
      ),
      body: switch (view) {
        ViewLoading() || ViewEmpty() => const Center(
          key: Key('cycle-loading'),
          child: CircularProgressIndicator(semanticsLabel: 'Loading'),
        ),
        ViewFailure(:final message) => MessagePanel(
          key: const Key('cycle-failure'),
          title: message,
          action: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              FilledButton(
                onPressed: () => ref.invalidate(provider),
                child: const Text('Try again'),
              ),
              OutlinedButton(
                onPressed: () => const StokvelsRoute().go(context),
                child: const Text('Back to my stokvels'),
              ),
            ],
          ),
        ),
        ViewData(value: final detail) => _CycleBody(
          key: Key('cycle-data-${detail.cycle.id}'),
          detail: detail,
        ),
      },
    );
  }
}

class _CycleBody extends StatelessWidget {
  const new({required this.detail, super.key});

  final CycleDetail detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cycle = detail.cycle;
    final dueDate = cycle.dueDate;
    final target = cycle.target.value;
    final progress = target <= 0
        ? 0.0
        : (cycle.collected.value / target).clamp(0.0, 1.0);

    return ListView(
      // Keeps the scroll position when another tab is visited and left.
      key: PageStorageKey('cycle-list-${cycle.id}'),
      padding: const EdgeInsets.all(16),
      children: [
        Text(detail.stokvel.name, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Cycle ${cycle.period}', style: theme.textTheme.titleMedium),
            CycleStatusChip(cycle.status),
          ],
        ),
        if (dueDate != null) Text('Due ${formatCalendarDate(dueDate)}'),
        const SizedBox(height: 16),
        Text(
          'Collected ${formatRand(cycle.collected)} of '
          '${formatRand(cycle.target)}',
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          // Flutter announces the value as a percentage.
          semanticsLabel: 'Collected',
        ),
        const SizedBox(height: 8),
        Text(
          '${cycle.membersPaid} of ${detail.stokvel.memberCount} members paid',
        ),
        const SizedBox(height: 24),
        Text('Contributions', style: theme.textTheme.titleMedium),
        if (detail.contributions.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Nobody has paid in this cycle yet.'),
          ),
        for (final contribution in detail.contributions)
          ContributionRow(contribution: contribution),
      ],
    );
  }
}
