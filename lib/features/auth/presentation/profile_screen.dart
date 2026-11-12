import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';

/// The Profile tab: who is signed in, and Sign out.
class ProfileScreen extends ConsumerStatefulWidget {
  /// Creates the screen.
  const new({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _signingOut = false;

  Future<void> _signOut() async {
    setState(() => _signingOut = true);
    // The gate sends the app to sign-in as soon as the state changes, and
    // this screen goes with the rest of the signed-in history.
    await ref.read(authControllerProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context) {
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
            SignedOut() => [const Text('Signed out')],
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
              onPressed: _signingOut ? null : _signOut,
              icon: const Icon(Icons.logout),
              label: const Text('Sign out'),
            ),
          ),
        ],
      ),
    );
  }
}
