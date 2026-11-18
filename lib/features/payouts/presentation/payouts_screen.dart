import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/app/router/routes.dart';
import 'package:ronditrack_app/core/money/rand_format.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/core/time/date_format.dart';
import 'package:ronditrack_app/core/widgets/message_panel.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_order.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_status.dart';
import 'package:ronditrack_app/features/payouts/presentation/payout_order_provider.dart';
import 'package:ronditrack_app/features/payouts/presentation/payout_status_chip.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_actions.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_detail_provider.dart';

/// A cycle's payout order (`/stokvels/:id/cycles/:cycleId/payouts`).
///
/// The order is shown exactly as the API sends it: not sorted, not counted,
/// not added up, and the next member is whoever the API marked `Next`.
/// "Record payout" appears only where the 10.1 actions match allows it, from
/// the person's membership of *this* stokvel and its current cycle.
class PayoutsScreen extends ConsumerWidget {
  /// Shows the payout order of cycle [cycleId] of stokvel [stokvelId].
  const new({required this.stokvelId, required this.cycleId, super.key});

  /// The stokvel, from the address.
  final String stokvelId;

  /// The cycle, from the address.
  final String cycleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (stokvelId: stokvelId, cycleId: cycleId);
    final view = payoutsViewState(key, ref.watch(payoutOrderProvider(key)));
    final canRecord = _canRecordPayout(ref);
    void retry() => ref.invalidate(payoutOrderProvider(key));

    return Scaffold(
      appBar: AppBar(title: const Text('Payout order')),
      body: switch (view) {
        ViewLoading() => const Center(
          key: Key('payouts-loading'),
          child: CircularProgressIndicator(semanticsLabel: 'Loading'),
        ),
        ViewEmpty() => MessagePanel(
          key: const Key('payouts-empty'),
          title: 'No payout order yet',
          body:
              'This cycle has no payout order. When it has one, it shows '
              'here, in the order the stokvel pays out.',
          action: OutlinedButton(
            onPressed: retry,
            child: const Text('Refresh'),
          ),
        ),
        ViewFailure(:final message, :final reference) => MessagePanel(
          key: const Key('payouts-failure'),
          title: message,
          reference: reference,
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
        ViewData(value: final order) => _PayoutsBody(
          key: Key('payouts-data-${order.cycleId}'),
          order: order,
          canRecord: canRecord,
          onRefresh: () => ref.refresh(payoutOrderProvider(key).future),
        ),
      },
    );
  }

  /// Whether the 10.1 actions match offers "Record payout" here: my role in
  /// *this* stokvel, its current cycle's status and my contribution, never
  /// the signed-in user or a token. False until the stokvel has loaded, and
  /// for any cycle that isn't the stokvel's current one.
  bool _canRecordPayout(WidgetRef ref) {
    final detail = ref.watch(stokvelDetailProvider(stokvelId)).value;
    if (detail == null || detail.stokvel.id != stokvelId) return false;
    if (detail.currentCycle?.id != cycleId) return false;
    final actions = actionsFor(detail, ref.watch(signedInUserIdProvider));
    return actions.contains(StokvelAction.recordPayout);
  }
}

class _PayoutsBody extends StatelessWidget {
  const new({
    required this.order,
    required this.canRecord,
    required this.onRefresh,
    super.key,
  });

  final PayoutOrder order;
  final bool canRecord;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        key: PageStorageKey('payouts-list-${order.cycleId}'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Members are paid in this order.',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          if (canRecord) ...[
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: FilledButton.icon(
                key: const Key('action-recordPayout'),
                icon: const Icon(Icons.payments_outlined),
                // Recording arrives in Week 11 (README "Contract notes").
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${stokvelActionLabel(StokvelAction.recordPayout)} '
                      'is coming soon.',
                    ),
                  ),
                ),
                label: Text(stokvelActionLabel(StokvelAction.recordPayout)),
              ),
            ),
            const SizedBox(height: 12),
          ],
          for (final entry in order.entries) _PayoutRow(entry: entry),
        ],
      ),
    );
  }
}

/// One member in the rotation. The next member's row has a heavier,
/// primary-coloured outline and an arrow, as well as its "Next to be paid"
/// chip, so it stands out without relying on colour.
class _PayoutRow extends StatelessWidget {
  new({required this.entry})
    : super(
        key: Key(
          entry.status == PayoutStatus.next
              ? 'payout-next'
              : 'payout-${entry.userId}',
        ),
      );

  final PayoutEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNext = entry.status == PayoutStatus.next;
    final paidAt = entry.paidAt;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        side: isNext
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              label: 'Position ${entry.position}',
              excludeSemantics: true,
              child: Text(
                '${entry.position}',
                style: theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (isNext)
                        Icon(
                          Icons.arrow_forward,
                          color: theme.colorScheme.primary,
                          semanticLabel: 'Next',
                        ),
                      Text(
                        entry.memberName,
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(formatRand(entry.amount)),
                      PayoutStatusChip(entry.status),
                    ],
                  ),
                  if (paidAt != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Paid on ${formatInstantAsLocalDate(paidAt)}',
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
