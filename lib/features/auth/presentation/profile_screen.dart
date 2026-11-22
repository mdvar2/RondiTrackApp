import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/dev/session_tools.dart';
import 'package:ronditrack_app/core/config/app_config_scope.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';

/// The Profile tab: who is signed in, and Sign out. The dev build adds the
/// session tools.
class ProfileScreen extends ConsumerWidget {
  /// Creates the screen.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final auth = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...switch (auth) {
            SignedIn(:final user) => [
              Text(user.name, style: theme.textTheme.headlineSmall),
              Text(user.email),
            ],
            Restoring() || SignedOut() => [const Text('Signed out')],
          },
          const SizedBox(height: 16),
          const Text(
            'Your role is set in each stokvel: you can be Treasurer in one '
            'and Member in another.',
          ),
          const SizedBox(height: 24),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: FilledButton.icon(
              key: const Key('sign-out'),
              // Works with no network: the phone is wiped and the gate
              // moves to sign-in at once; the API is told afterwards.
              onPressed: () =>
                  ref.read(authControllerProvider.notifier).signOut(),
              icon: const Icon(Icons.logout),
              label: const Text('Sign out'),
            ),
          ),
          // Built only in the dev flavour: in staging and prod these
          // buttons don't exist (the 10.3 test proves it).
          if (AppConfigScope.of(context).hasDevTools) const SessionTools(),
        ],
      ),
    );
  }
}
