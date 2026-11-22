import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/app/router/routes.dart';
import 'package:ronditrack_app/app/sync_statuses.dart';
import 'package:ronditrack_app/core/money/rand_format.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/core/time/date_format.dart';
import 'package:ronditrack_app/core/widgets/cache_banner.dart';
import 'package:ronditrack_app/core/widgets/message_panel.dart';
import 'package:ronditrack_app/features/home/presentation/home_controller.dart';
import 'package:ronditrack_app/features/payments/presentation/pay_screen.dart';
import 'package:ronditrack_app/features/stokvels/domain/status_labels.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_actions.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/presentation/contribution_row.dart';
import 'package:ronditrack_app/features/stokvels/presentation/status_chips.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_detail_provider.dart';
import 'package:ronditrack_app/l10n/generated/app_localizations.dart';

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
      body: Column(
        children: [
          CacheBanner(
            status: ref.watch(syncStatusesProvider)[stokvelSyncKey(stokvelId)],
            onRetry: retry,
          ),
          Expanded(
            child: switch (view) {
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
              ViewFailure(:final message, :final reference) => MessagePanel(
                key: const Key('stokvel-failure'),
                title: message,
                reference: reference,
                action: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: retry,
                      child: const Text('Try again'),
                    ),
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
                onRefresh: () =>
                    ref.refresh(stokvelDetailProvider(stokvelId).future),
              ),
            },
          ),
        ],
      ),
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
          const SizedBox(height: 8),
          // A payment still in the outbox: beside the server's figures,
          // marked pending, never added in.
          PendingPaymentsFor(cycleId: cycle.id),
          Wrap(
            spacing: 8,
            children: [
              TextButton.icon(
                key: const Key('open-contributions'),
                onPressed: () =>
                    ContributionsRoute(id: detail.stokvel.id).go(context),
                icon: const Icon(Icons.list_alt),
                label: Text(AppLocalizations.of(context).viewContributions),
              ),
              if (actions.contains(StokvelAction.closeCycle))
                TextButton.icon(
                  key: const Key('open-edit-cycle'),
                  onPressed: () => EditCycleRoute(
                    id: detail.stokvel.id,
                    cycleId: cycle.id,
                  ).go(context),
                  icon: const Icon(Icons.edit_calendar),
                  label: Text(AppLocalizations.of(context).editCycle),
                ),
            ],
          ),
          const SizedBox(height: 8),
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
                      onPressed: switch (action) {
                        // Closing starts with what it would record.
                        StokvelAction.closeCycle => () => CloseCycleRoute(
                          id: detail.stokvel.id,
                          cycleId: cycle.id,
                        ).go(context),
                        // Saved in the outbox, then sent (11.3).
                        StokvelAction.pay => () => PayRoute(
                          id: detail.stokvel.id,
                          cycleId: cycle.id,
                        ).go(context),
                        // The other writes arrive later.
                        StokvelAction.uploadProof ||
                        StokvelAction.confirmContributions ||
                        StokvelAction.recordPayout =>
                          () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${stokvelActionLabel(action)} is coming '
                                'soon.',
                              ),
                            ),
                          ),
                      },
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
