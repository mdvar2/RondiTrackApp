import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/money/rand_format.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/core/time/date_format.dart';
import 'package:ronditrack_app/features/home/presentation/home_controller.dart';
import 'package:ronditrack_app/features/stokvels/domain/status_labels.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_actions.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_detail_provider.dart';

/// One stokvel: its current cycle, contributions and what I can do here.
///
/// The app bar's picker switches stokvels. Each id is its own family
/// member, so the moment the picker changes, the screen shows the new
/// stokvel loading, never the old one's contributions.
class StokvelDetailScreen extends ConsumerStatefulWidget {
  /// Opens the screen on [initialStokvelId].
  const new({required this.initialStokvelId, super.key});

  /// The stokvel to show first.
  final String initialStokvelId;

  @override
  ConsumerState<StokvelDetailScreen> createState() =>
      _StokvelDetailScreenState();
}

class _StokvelDetailScreenState extends ConsumerState<StokvelDetailScreen> {
  late String _stokvelId = widget.initialStokvelId;

  @override
  Widget build(BuildContext context) {
    final stokvelId = _stokvelId;
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
        title: pickerEntry == null
            ? const Text('Stokvel')
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
                    if (id != null) setState(() => _stokvelId = id);
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
        ViewEmpty() => _Message(
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
        ViewFailure(:final message) => _Message(
          key: const Key('stokvel-failure'),
          title: message,
          action: Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: [
              FilledButton(onPressed: retry, child: const Text('Try again')),
              OutlinedButton(
                onPressed: () => Navigator.of(context).maybePop(),
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cycle ${cycle.period}: ${cycleStatusLabel(cycle.status)}',
                    style: theme.textTheme.titleMedium,
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
                ],
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
            ListTile(
              key: Key('contribution-${contribution.id}'),
              contentPadding: EdgeInsets.zero,
              title: Text(contribution.memberName),
              subtitle: Text(stokvelRoleLabel(contribution.memberRole)),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(formatRand(contribution.amount)),
                  Text(contributionStatusLabel(contribution.status)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const new({required this.title, required this.action, this.body, super.key});

  final String title;
  final String? body;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final body = this.body;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (body != null) ...[
              const SizedBox(height: 8),
              Text(body, textAlign: TextAlign.center),
            ],
            const SizedBox(height: 16),
            action,
          ],
        ),
      ),
    );
  }
}
