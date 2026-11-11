import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/core/money/rand_format.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/core/time/date_format.dart';
import 'package:ronditrack_app/features/home/domain/home_entry.dart';
import 'package:ronditrack_app/features/home/presentation/home_controller.dart';
import 'package:ronditrack_app/features/stokvels/domain/status_labels.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_detail_screen.dart';

/// Home: one card per stokvel the signed-in person belongs to.
class HomeScreen extends ConsumerWidget {
  /// Creates Home with the app's [title].
  const new({required this.title, super.key});

  /// The flavour's app name.
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = homeViewState(ref.watch(homeControllerProvider));
    Future<void> refresh() =>
        ref.read(homeControllerProvider.notifier).refresh();

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: switch (view) {
        ViewLoading() => const Center(
          key: Key('home-loading'),
          child: CircularProgressIndicator(semanticsLabel: 'Loading'),
        ),
        ViewEmpty() => _HomeEmpty(onRefresh: refresh),
        ViewFailure(:final message) => _HomeFailure(
          message: message,
          onRetry: () => ref.invalidate(homeControllerProvider),
        ),
        ViewData(value: final entries, :final refreshing) => _HomeList(
          entries: entries,
          refreshing: refreshing,
          onRefresh: refresh,
        ),
      },
    );
  }
}

class _HomeList extends StatelessWidget {
  const new({
    required this.entries,
    required this.refreshing,
    required this.onRefresh,
  });

  final List<HomeEntry> entries;
  final bool refreshing;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (refreshing)
          const LinearProgressIndicator(
            key: Key('home-refreshing'),
            semanticsLabel: 'Refreshing',
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: entries.length,
              itemBuilder: (context, index) =>
                  HomeStokvelCard(entry: entries[index]),
            ),
          ),
        ),
      ],
    );
  }
}

/// One stokvel on Home: its name, my role there, paid, owed, arrears and
/// the next payout, all as the API sent them.
class HomeStokvelCard extends StatelessWidget {
  /// Creates the card.
  const new({required this.entry, super.key});

  /// The stokvel's Home entry.
  final HomeEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cycle = entry.currentCycle;
    final dueDate = cycle?.dueDate;
    final nextPayout = entry.nextPayoutDate;

    return Card(
      key: Key('home-card-${entry.stokvelId}'),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) =>
                StokvelDetailScreen(initialStokvelId: entry.stokvelId),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.stokvelName,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Chip(label: Text(stokvelRoleLabel(entry.membership.role))),
                ],
              ),
              Text(
                cycle == null
                    ? 'No cycle this month'
                    : [
                        '${cycle.period}: ${cycleStatusLabel(cycle.status)}',
                        if (dueDate != null)
                          'due ${formatCalendarDate(dueDate)}',
                      ].join(', '),
              ),
              const SizedBox(height: 8),
              _Figure(label: 'Paid', value: formatRand(entry.amountPaid)),
              _Figure(label: 'Owed', value: formatRand(entry.amountOwed)),
              _Figure(label: 'Arrears', value: formatRand(entry.arrears)),
              _Figure(
                label: 'Next payout',
                value: nextPayout == null
                    ? 'No payout scheduled'
                    : formatInstantAsLocalDate(nextPayout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const new({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value),
        ],
      ),
    );
  }
}

class _HomeEmpty extends StatelessWidget {
  const new({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('home-empty'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "You're not in a stokvel yet",
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Ask your stokvel's treasurer or chairperson for an invite "
              'link, and open it on this phone to join. Your stokvels will '
              'appear here.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRefresh, child: const Text('Refresh')),
          ],
        ),
      ),
    );
  }
}

class _HomeFailure extends StatelessWidget {
  const new({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('home-failure'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
