import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/payments/presentation/payments_controller.dart';
import 'package:ronditrack_app/l10n/generated/app_localizations.dart';

/// Signs out, asking first if the outbox still holds a payment: signing
/// out empties the phone, and an unsent payment would be lost without a
/// word. With nothing waiting, it signs out at once.
Future<void> signOutAskingFirst(BuildContext context, WidgetRef ref) async {
  final waiting = await ref.read(paymentsProvider.notifier).waiting();
  if (!context.mounted) return;
  if (waiting.isNotEmpty) {
    final l10n = AppLocalizations.of(context);
    final sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        key: const Key('sign-out-pending-dialog'),
        title: Text(l10n.signOutWithPendingTitle),
        content: Text(l10n.signOutWithPendingBody(waiting.length)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            key: const Key('sign-out-anyway'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.signOutAnyway),
          ),
        ],
      ),
    );
    if (sure != true) return;
  }
  await ref.read(authControllerProvider.notifier).signOut();
}
