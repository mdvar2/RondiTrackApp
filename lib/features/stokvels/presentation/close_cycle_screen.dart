import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/router/routes.dart';
import 'package:ronditrack_app/core/money/rand_format.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/core/time/date_format.dart';
import 'package:ronditrack_app/core/widgets/message_panel.dart';
import 'package:ronditrack_app/features/stokvels/domain/cycle_close_preview.dart';
import 'package:ronditrack_app/features/stokvels/presentation/close_cycle_provider.dart';

/// Closing a cycle (`/stokvels/:id/cycles/:cycleId/close`), a treasurer
/// action: what closing would record, as the API works it out.
///
/// Who may see it is the API's decision, not this screen's: a Member who
/// opens the link is told their role doesn't allow it (the API's `403`),
/// and stays signed in; anyone else gets "not found" (`404`).
class CloseCycleScreen extends ConsumerWidget {
  /// Shows the close preview of cycle [cycleId] of stokvel [stokvelId].
  const new({required this.stokvelId, required this.cycleId, super.key});

  /// The stokvel, from the address.
  final String stokvelId;

  /// The cycle, from the address.
  final String cycleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = closePreviewProvider(stokvelId, cycleId);
    final view = closePreviewViewState(ref.watch(provider));

    return Scaffold(
      appBar: AppBar(title: const Text('Close cycle')),
      body: switch (view) {
        ViewLoading() || ViewEmpty() => const Center(
          key: Key('close-loading'),
          child: CircularProgressIndicator(semanticsLabel: 'Loading'),
        ),
        ViewFailure(:final message, :final reference) => MessagePanel(
          key: const Key('close-failure'),
          title: message,
          reference: reference,
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
                onPressed: () =>
                    CycleRoute(id: stokvelId, cycleId: cycleId).go(context),
                child: const Text('Back to the cycle'),
              ),
            ],
          ),
        ),
        ViewData(value: final preview) => _CloseBody(
          key: Key('close-data-${preview.cycleId}'),
          preview: preview,
        ),
      },
    );
  }
}

class _CloseBody extends StatelessWidget {
  const new({required this.preview, super.key});

  final CycleClosePreview preview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Cycle ${preview.period}', style: theme.textTheme.headlineSmall),
        Text('Worked out on ${formatCalendarDate(preview.asOf)}'),
        const SizedBox(height: 16),
        if (preview.arrears.isEmpty)
          const Text('Everyone has paid in full. Closing records no arrears.')
        else ...[
          const Text('Closing records these arrears:'),
          for (final arrear in preview.arrears)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(arrear.memberName),
              trailing: Text(formatRand(arrear.amount)),
            ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Total arrears'),
            trailing: Text(
              formatRand(preview.total),
              style: theme.textTheme.titleMedium,
            ),
          ),
        ],
        const SizedBox(height: 16),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: FilledButton(
            key: const Key('close-confirm'),
            // Closing is a write, with this preview's version; it arrives
            // later in Week 11.
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Closing a cycle is coming soon.')),
            ),
            child: const Text('Close cycle'),
          ),
        ),
      ],
    );
  }
}
