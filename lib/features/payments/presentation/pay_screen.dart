import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/core/money/rand_format.dart';
import 'package:ronditrack_app/core/money/rand_parser.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/core/widgets/message_panel.dart';
import 'package:ronditrack_app/features/payments/domain/payment_outbox.dart';
import 'package:ronditrack_app/features/payments/presentation/payment_words.dart';
import 'package:ronditrack_app/features/payments/presentation/payments_controller.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_detail_provider.dart';
import 'package:ronditrack_app/l10n/generated/app_localizations.dart';

/// `/stokvels/:id/cycles/:cycleId/pay`: the member's own contribution to
/// the cycle.
///
/// Pay records the payment in the outbox at once (with its key), so it is
/// kept with no signal, then sends it. While it is in the outbox, Pay is
/// disabled: one tap, one payment. The amount is rands, parsed to whole
/// cents ([parseRand]); never a double.
class PayScreen extends ConsumerStatefulWidget {
  /// Creates the form for cycle [cycleId] of stokvel [stokvelId].
  const new({required this.stokvelId, required this.cycleId, super.key});

  /// The stokvel.
  final String stokvelId;

  /// The cycle.
  final String cycleId;

  @override
  ConsumerState<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends ConsumerState<PayScreen> {
  final _amount = TextEditingController();
  bool _prefilled = false;
  bool _busy = false;
  String? _amountError;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _pay(AppLocalizations l10n) async {
    if (_busy) return;
    final parsed = parseRand(_amount.text);
    final error = switch (parsed) {
      RandRefused(:final reason) => randErrorMessage(l10n, reason),
      RandParsed(:final cents) when cents.value <= 0 => l10n.amountZero,
      RandParsed() => null,
    };
    if (error != null || parsed is! RandParsed) {
      setState(() => _amountError = error);
      // Announced by TalkBack: the field's error alone may not be read.
      unawaited(
        SemanticsService.sendAnnouncement(
          View.of(context),
          error!,
          Directionality.of(context),
        ),
      );
      return;
    }
    setState(() {
      _busy = true;
      _amountError = null;
    });
    final localeName = l10n.localeName;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final outcome = await ref
        .read(paymentsProvider.notifier)
        .pay(
          stokvelId: widget.stokvelId,
          cycleId: widget.cycleId,
          amount: parsed.cents,
        );
    if (!mounted) return;
    ref.read(paymentNoticesProvider.notifier).clear();
    messenger.showSnackBar(
      SnackBar(content: Text(paymentOutcomeMessage(l10n, localeName, outcome))),
    );
    switch (outcome) {
      // Refused for a reason the form can fix: stay, input kept.
      case PaymentRefused(reason: PaymentRefusal.other):
        setState(() => _busy = false);
      default:
        if (navigator.canPop()) navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final view = cycleDetailViewState(
      ref.watch(cycleDetailProvider(widget.stokvelId, widget.cycleId)),
    );
    final pending = (ref.watch(pendingPaymentsProvider).value ?? const [])
        .where((p) => p.cycleId == widget.cycleId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(switch (view) {
          ViewData(value: final detail) => l10n.payTitle(detail.stokvel.name),
          _ => l10n.payButton,
        }),
      ),
      body: switch (view) {
        ViewLoading() ||
        ViewEmpty() => const Center(child: CircularProgressIndicator()),
        ViewFailure(:final message, :final reference) => MessagePanel(
          title: message,
          reference: reference,
          action: FilledButton(
            onPressed: () => ref.invalidate(
              cycleDetailProvider(widget.stokvelId, widget.cycleId),
            ),
            child: Text(l10n.tryAgain),
          ),
        ),
        ViewData(value: final detail) => _form(context, l10n, detail, pending),
      },
    );
  }

  Widget _form(
    BuildContext context,
    AppLocalizations l10n,
    CycleDetail detail,
    List<PendingPayment> pending,
  ) {
    if (!_prefilled) {
      _prefilled = true;
      // The stokvel's contribution, as the member would type it.
      _amount.text = formatRand(detail.stokvel.contributionAmount)
          .replaceFirst('R ', '');
    }
    final waiting = pending.isNotEmpty;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l10n.payCycle(detail.cycle.period),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        TextField(
          key: const Key('pay-amount'),
          controller: _amount,
          enabled: !_busy && !waiting,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _pay(l10n),
          decoration: InputDecoration(
            labelText: l10n.payAmountLabel,
            hintText: l10n.payAmountHint,
            prefixText: 'R ',
            border: const OutlineInputBorder(),
            errorText: _amountError,
            errorMaxLines: 3,
          ),
        ),
        const SizedBox(height: 16),
        if (waiting) ...[
          PendingPaymentNote(payments: pending),
          const SizedBox(height: 16),
        ],
        FilledButton(
          key: const Key('pay-submit'),
          onPressed: _busy || waiting ? null : () => _pay(l10n),
          child: Text(
            waiting
                ? l10n.payPendingButton
                : _busy
                ? l10n.payBusy
                : l10n.payButton,
          ),
        ),
      ],
    );
  }
}

/// [payments] waiting in the outbox, shown beside the server's figures and
/// marked pending: never added to a total, never shown as paid.
class PendingPaymentNote extends ConsumerWidget {
  /// Creates the note.
  const new({required this.payments, super.key});

  /// The payments waiting for this cycle.
  final List<PendingPayment> payments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Card(
      key: const Key('pending-payment'),
      color: scheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final payment in payments)
              Row(
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      Icons.schedule,
                      color: scheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.pendingPayment(formatRand(payment.amount)),
                      style: TextStyle(color: scheme.onSecondaryContainer),
                    ),
                  ),
                ],
              ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                key: const Key('pending-send-now'),
                onPressed: () =>
                    ref.read(paymentsProvider.notifier).sendWaiting(),
                child: Text(l10n.sendNow),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The payments waiting for cycle [cycleId], shown with
/// [PendingPaymentNote]; nothing when there are none.
class PendingPaymentsFor extends ConsumerWidget {
  /// Creates the note for [cycleId].
  const new({required this.cycleId, super.key});

  /// The cycle.
  final String cycleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = (ref.watch(pendingPaymentsProvider).value ?? const [])
        .where((p) => p.cycleId == cycleId)
        .toList();
    if (pending.isEmpty) return const SizedBox.shrink();
    return PendingPaymentNote(payments: pending);
  }
}
