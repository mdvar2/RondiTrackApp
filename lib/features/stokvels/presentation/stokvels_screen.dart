import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/router/routes.dart';
import 'package:ronditrack_app/core/layout/window_size.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/core/widgets/message_panel.dart';
import 'package:ronditrack_app/features/home/domain/home_entry.dart';
import 'package:ronditrack_app/features/home/presentation/home_controller.dart';
import 'package:ronditrack_app/features/stokvels/domain/status_labels.dart';
import 'package:ronditrack_app/features/stokvels/presentation/status_chips.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_detail_screen.dart';

/// The Stokvels tab's screen for `/stokvels` and `/stokvels/:id`.
///
/// Under 840 dp it is one pane: the list at `/stokvels`, the stokvel at
/// `/stokvels/:id`. At 840 dp or wider it is the list and the stokvel side
/// by side. The selected stokvel is always the address's, so turning a
/// tablet upright keeps it, and back from it returns to the list.
class StokvelsScreen extends StatelessWidget {
  /// Creates the screen, showing [selectedId] if there is one.
  const new({this.selectedId, super.key});

  /// The stokvel in the address, `null` at `/stokvels`.
  final String? selectedId;

  /// How wide the list is beside a stokvel, in dp.
  static const listPaneWidth = 360.0;

  @override
  Widget build(BuildContext context) {
    final selected = selectedId;
    if (WindowSize.of(context) != WindowSize.expanded) {
      return selected == null
          ? const StokvelListScreen()
          : StokvelDetailScreen(stokvelId: selected);
    }
    return Row(
      key: const Key('stokvels-list-detail'),
      children: [
        SizedBox(
          width: listPaneWidth,
          child: StokvelListScreen(selectedId: selected),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: selected == null
              ? const _NoneSelected()
              : StokvelDetailScreen(stokvelId: selected, showPicker: false),
        ),
      ],
    );
  }
}

/// My stokvels: name, my role and the cycle's status, from Home's data.
class StokvelListScreen extends ConsumerWidget {
  /// Creates the list, highlighting [selectedId].
  const new({this.selectedId, super.key});

  /// The stokvel shown beside the list, if any.
  final String? selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = homeViewState(ref.watch(homeControllerProvider));
    void retry() => ref.invalidate(homeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My stokvels')),
      body: switch (view) {
        ViewLoading() => const Center(
          key: Key('stokvels-loading'),
          child: CircularProgressIndicator(semanticsLabel: 'Loading'),
        ),
        ViewEmpty() => MessagePanel(
          key: const Key('stokvels-empty'),
          title: "You're not in a stokvel yet",
          body:
              "Ask your stokvel's treasurer or chairperson for an invite "
              'link, and open it on this phone to join.',
          action: OutlinedButton(
            onPressed: retry,
            child: const Text('Refresh'),
          ),
        ),
        ViewFailure(:final message) => MessagePanel(
          key: const Key('stokvels-failure'),
          title: message,
          action: FilledButton(
            onPressed: retry,
            child: const Text('Try again'),
          ),
        ),
        ViewData(value: final entries) => ListView(
          key: const PageStorageKey('stokvels-list'),
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            for (final entry in entries)
              _StokvelTile(
                entry: entry,
                selected: entry.stokvelId == selectedId,
              ),
          ],
        ),
      },
    );
  }
}

class _StokvelTile extends StatelessWidget {
  const new({required this.entry, required this.selected});

  final HomeEntry entry;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cycle = entry.currentCycle;
    return Material(
      color: selected
          ? theme.colorScheme.secondaryContainer
          : theme.colorScheme.surface,
      child: InkWell(
        key: Key('stokvel-tile-${entry.stokvelId}'),
        onTap: () => StokvelRoute(id: entry.stokvelId).go(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.stokvelName, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(stokvelRoleLabel(entry.membership.role)),
                  if (cycle == null)
                    const Text('No cycle this month')
                  else ...[
                    Text('Cycle ${cycle.period}'),
                    CycleStatusChip(cycle.status),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoneSelected extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('stokvels-none-selected'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Choose a stokvel to see its cycle and contributions.',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
