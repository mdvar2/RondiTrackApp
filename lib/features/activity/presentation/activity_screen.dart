import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/router/routes.dart';
import 'package:ronditrack_app/core/money/rand_format.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/core/time/date_format.dart';
import 'package:ronditrack_app/core/widgets/message_panel.dart';
import 'package:ronditrack_app/features/activity/domain/activity_item.dart';
import 'package:ronditrack_app/features/activity/presentation/activity_controller.dart';
import 'package:ronditrack_app/features/stokvels/presentation/status_chips.dart';

/// The Activity tab: what has happened across my stokvels, newest first,
/// in the same four states as Home.
class ActivityScreen extends ConsumerWidget {
  /// Creates the screen.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = activityViewState(ref.watch(activityControllerProvider));
    Future<void> refresh() =>
        ref.read(activityControllerProvider.notifier).refresh();

    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: switch (view) {
        ViewLoading() => const Center(
          key: Key('activity-loading'),
          child: CircularProgressIndicator(semanticsLabel: 'Loading'),
        ),
        ViewEmpty() => MessagePanel(
          key: const Key('activity-empty'),
          title: 'Nothing has happened yet',
          body:
              'Contributions in your stokvels show here as they are '
              'recorded.',
          action: OutlinedButton(
            onPressed: refresh,
            child: const Text('Refresh'),
          ),
        ),
        ViewFailure(:final message) => MessagePanel(
          key: const Key('activity-failure'),
          title: message,
          action: FilledButton(
            onPressed: () => ref.invalidate(activityControllerProvider),
            child: const Text('Try again'),
          ),
        ),
        ViewData(value: final items, :final refreshing) => Column(
          children: [
            if (refreshing)
              const LinearProgressIndicator(
                key: Key('activity-refreshing'),
                semanticsLabel: 'Refreshing',
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refresh,
                child: ListView(
                  key: const PageStorageKey('activity-list'),
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [for (final item in items) _ActivityTile(item)],
                ),
              ),
            ),
          ],
        ),
      },
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const new(this.item);

  final ActivityItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      key: Key('activity-item-${item.id}'),
      onTap: () =>
          CycleRoute(id: item.stokvelId, cycleId: item.cycleId).go(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.stokvelName, style: theme.textTheme.labelLarge),
            Text(
              '${item.memberName}: ${formatRand(item.amount)}',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ContributionStatusChip(item.status),
                Text(formatInstantAsLocalDate(item.occurredAt)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
