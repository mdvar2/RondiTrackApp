import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/router/routes.dart';
import 'package:ronditrack_app/core/money/rand_format.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/core/widgets/message_panel.dart';
import 'package:ronditrack_app/features/home/presentation/home_controller.dart';
import 'package:ronditrack_app/features/invites/domain/invite_preview.dart';
import 'package:ronditrack_app/features/invites/presentation/invite_preview_provider.dart';

/// `/join/:code`: an invite's preview, then Join.
///
/// Reached signed out, the gate keeps this address across sign-in, so the
/// person lands here afterwards.
class JoinScreen extends ConsumerWidget {
  /// Shows the invite with [code].
  const new({required this.code, super.key});

  /// The invite code, from the address.
  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = inviteViewState(ref.watch(invitePreviewProvider(code)));

    return Scaffold(
      appBar: AppBar(title: const Text('Invite')),
      body: switch (view) {
        ViewLoading() || ViewEmpty() => const Center(
          key: Key('invite-loading'),
          child: CircularProgressIndicator(semanticsLabel: 'Loading'),
        ),
        ViewFailure(:final message) => MessagePanel(
          key: const Key('invite-failure'),
          title: message,
          action: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              FilledButton(
                onPressed: () => ref.invalidate(invitePreviewProvider(code)),
                child: const Text('Try again'),
              ),
              OutlinedButton(
                onPressed: () => const HomeRoute().go(context),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
        ViewData(value: final invite) => _InviteBody(
          key: Key('invite-data-$code'),
          invite: invite,
        ),
      },
    );
  }
}

class _InviteBody extends ConsumerWidget {
  const new({required this.invite, super.key});

  final InvitePreview invite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final joiner = inviteJoinerProvider(invite.code);
    final joining = ref.watch(joiner);
    final myStokvels = ref.watch(homeControllerProvider).value ?? const [];
    final alreadyIn = myStokvels.any(
      (entry) => entry.stokvelId == invite.stokvelId,
    );

    Future<void> join() async {
      final stokvelId = await ref.read(joiner.notifier).join();
      if (stokvelId != null && context.mounted) {
        StokvelRoute(id: stokvelId).go(context);
      }
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text("You're invited to join", style: theme.textTheme.titleMedium),
        Text(invite.stokvelName, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 16),
        Text('${invite.memberCount} members'),
        Text('Contribution: ${formatRand(invite.contributionAmount)}'),
        if (invite.schedule.isNotEmpty) Text('When: ${invite.schedule}'),
        if (invite.rules.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text('Rules: ${invite.rules}'),
        ],
        const SizedBox(height: 24),
        if (alreadyIn) ...[
          Text("You're already in ${invite.stokvelName}."),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: FilledButton(
              key: const Key('invite-open'),
              onPressed: () => StokvelRoute(id: invite.stokvelId).go(context),
              child: Text('Open ${invite.stokvelName}'),
            ),
          ),
        ] else ...[
          if (joining.hasError)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text("We couldn't join you. Try again."),
            ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: FilledButton(
              key: const Key('invite-join'),
              onPressed: joining.isLoading ? null : join,
              child: Text(
                joining.isLoading ? 'Joining…' : 'Join ${invite.stokvelName}',
              ),
            ),
          ),
        ],
      ],
    );
  }
}
