import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/app/settings.dart';
import 'package:ronditrack_app/features/notifications/domain/push.dart';
import 'package:ronditrack_app/features/notifications/presentation/push_providers.dart';
import 'package:ronditrack_app/l10n/generated/app_localizations.dart';

part 'notification_ask.g.dart';

/// What the phone allows now, for the status on Profile: `null` with push
/// off (no Firebase file in this build).
@riverpod
Future<PushPermission?> notificationStatus(Ref ref) async =>
    await ref.watch(pushClientProvider)?.permission();

/// Asks once per phone, just after a member records a payment, in the
/// app's own words first: do they want to know when the treasurer confirms
/// it? Android's dialog follows only a yes. Never at first launch, never on
/// every launch, and not at all with push off (README "Notifications",
/// question 4). Refused is an answer: everything still works, and Profile
/// says so.
Future<void> askAboutNotifications(BuildContext context, WidgetRef ref) async {
  final client = ref.read(pushClientProvider);
  final settings = ref.read(settingsStoreProvider);
  if (client == null || settings.notificationsAsked) return;

  if (await client.permission() == PushPermission.granted) {
    // Allowed already (Android 12 and older allow by default): nothing to
    // ask, ever.
    await settings.setNotificationsAsked();
    return;
  }
  if (!context.mounted) return;

  final l10n = AppLocalizations.of(context);
  final yes = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.notifyAskTitle),
      content: Text(l10n.notifyAskBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.notifyAskNotNow),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.notifyAskYes),
        ),
      ],
    ),
  );
  // Asked, whatever the answer: Not now is not asked again.
  await settings.setNotificationsAsked();
  if (yes ?? false) await client.requestPermission();
  ref.invalidate(notificationStatusProvider);
}

/// The status on Profile, in words.
class NotificationStatusTile extends ConsumerWidget {
  /// Creates the tile.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final status = ref.watch(notificationStatusProvider);
    final words = switch (status) {
      AsyncData(value: null) => l10n.notifyStatusUnavailable,
      AsyncData(value: PushPermission.granted) => l10n.notifyStatusOn,
      AsyncData(value: PushPermission.denied) => l10n.notifyStatusOff,
      AsyncData(value: PushPermission.notAsked) => l10n.notifyStatusNotAsked,
      _ => '',
    };
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.notifications_outlined),
      title: Text(l10n.notifyStatusTitle),
      subtitle: Text(words),
    );
  }
}
