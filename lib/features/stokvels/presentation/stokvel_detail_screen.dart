import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/app/router/routes.dart';
import 'package:ronditrack_app/core/money/rand_format.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/core/time/date_format.dart';
import 'package:ronditrack_app/core/widgets/message_panel.dart';
import 'package:ronditrack_app/features/home/presentation/home_controller.dart';
import 'package:ronditrack_app/features/stokvels/domain/status_labels.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_actions.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/presentation/contribution_row.dart';
import 'package:ronditrack_app/features/stokvels/presentation/status_chips.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_detail_provider.dart';

/// One stokvel: its current cycle, contributions and what I can do here.
///
/// The stokvel comes from the address (`/stokvels/:id`). On a phone the app
/// bar's picker switches stokvels by going to the other stokvel's address.
/// Each id is its own family member, so the moment the address changes,
/// the screen shows the new stokvel loading, never the old one's
/// contributions.
class StokvelDetailScreen extends ConsumerWidget {
  /// Shows stokvel [stokvelId]. [showPicker] is false beside the tablet's
  /// list, which does the picking there.
  const new({required this.stokvelId, this.showPicker = true, super.key});

  /// The stokvel, from the address.
  final String stokvelId;

  /// Whether the app bar offers the other stokvels.
  final bool showPicker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myStokvels = ref.watch(homeControllerProvider).value ?? const [];
    final pickerEntry = myStokvels
        .where((entry) => entry.stokvelId == stokvelId)
        .firstOrNull;
    final view = stokvelDetailViewState(
      stokvelId,
      ref.watch(stokvelDetailProvider(stokvelId)),
    );
    final myUserId = ref.watch(signedInUserIdProvider);
    void retry() => ref.invalidate(stokvelDetailProvider(stokvelId));

    return Scaffold(
      appBar: AppBar(
        title: !showPicker || pickerEntry == null
            ? Text(pickerEntry?.stokvelName ?? 'Stokvel')
            : DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  key: const Key('stokvel-picker'),
                  value: stokvelId,
                  isExpanded: true,
                  items: [
                    for (final entry in myStokvels)
                      DropdownMenuItem(
                        value: entry.stokvelId,
                        child: Text(
                          entry.stokvelName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: (id) {
                    if (id != null && id != stokvelId) {
                      StokvelRoute(id: id).go(context);
                    }
                  },
                ),
              ),
      ),
      body: switch (view) {
        ViewLoading() => Center(
          key: Key('stokvel-loading-$stokvelId'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Loading ${pickerEntry?.stokvelName ?? 'stokvel'}…'),
            ],
          ),
        ),
        ViewEmpty() => MessagePanel(
          key: const Key('stokvel-empty'),
          title: 'No open cycle',
          body:
              'This stokvel has no cycle yet. When your treasurer opens '
              'the next one, it shows here.',
          action: OutlinedButton(
            onPressed: retry,
            child: const Text('Refresh'),
          ),
        ),
        ViewFailure(:final message) => MessagePanel(
          key: const Key('stokvel-failure'),
          title: message,
          action: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              FilledButton(onPressed: retry, child: const Text('Try again')),
              OutlinedButton(
                onPressed: () => const StokvelsRoute().go(context),
                child: const Text('Back to my stokvels'),
              ),
            ],
          ),
        ),
        ViewData(value: final detail) => _StokvelBody(
          key: Key('stokvel-data-${detail.stokvel.id}'),
          detail: detail,
          actions: actionsFor(detail, myUserId),
          onRefresh: () => ref.refresh(stokvelDetailProvider(stokvelId).future),
        ),
      },
    );
  }
}

class _StokvelBody extends StatelessWidget {
  const new({
    required this.detail,
    required this.actions,
    required this.onRefresh,
    super.key,
  });

  final StokvelDetail detail;
  final Set<StokvelAction> actions;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cycle = detail.currentCycle!;
    final dueDate = cycle.dueDate;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        key: PageStorageKey('stokvel-list-${detail.stokvel.id}'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Text(detail.stokvel.name, style: theme.textTheme.headlineSmall),
          Text('Your role: ${stokvelRoleLabel(detail.membership.role)}'),
          Text(
            'Contribution: ${formatRand(detail.stokvel.contributionAmount)}',
          ),
          const SizedBox(height: 16),
          Card(
            child: InkWell(
              key: Key('open-cycle-${cycle.id}'),
              onTap: () => CycleRoute(
                id: detail.stokvel.id,
                cycleId: cycle.id,
              ).go(context),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Cycle ${cycle.period}',
                          style: theme.textTheme.titleMedium,
                        ),
                        CycleStatusChip(cycle.status),
                      ],
                    ),
                    if (dueDate != null)
                      Text('Due ${formatCalendarDate(dueDate)}'),
                    Text(
                      '${cycle.membersPaid} of ${detail.stokvel.memberCount} '
                      'members paid',
                    ),
                    Text(
                      'Collected ${formatRand(cycle.collected)} of '
                      '${formatRand(cycle.target)}',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'View this cycle',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (actions.isNotEmpty) ...[
            Text('What you can do', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final action in StokvelAction.values)
                  if (actions.contains(action))
                    FilledButton.tonal(
                      key: Key('action-${action.name}'),
                      // The actions arrive in Week 11.
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
                            SnackBar(
                              content: Text(
                                '${stokvelActionLabel(action)} is coming soon.',
                              ),
                            ),
                          ),
                      child: Text(stokvelActionLabel(action)),
                    ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          Text('Contributions', style: theme.textTheme.titleMedium),
          if (detail.contributions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Nobody has paid in this cycle yet.'),
            ),
          for (final contribution in detail.contributions)
            ContributionRow(contribution: contribution),
        ],
      ),
    );
  }
}
