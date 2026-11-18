import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/auth/presentation/sign_in_notice.dart';

/// Signs out, then signs in as [email], through the same auth state a
/// person uses: the gate sends the open screen to sign-in (remembering its
/// address), the shell and every provider holding the last person's data
/// are disposed, and signing in brings the new person back to that address.
///
/// [auth] and [notice] are read before the switch starts: the widget that
/// asked is disposed with the shell half way through. If the sign-in is
/// refused (the API allows five sign-ins a minute from one address), the
/// person is left on sign-in with the failure's words, the wait included.
Future<void> switchPersona(
  AuthController auth,
  SignInNotice notice,
  String email,
) async {
  await auth.signOut();
  try {
    await auth.signIn(email);
  } on Failure catch (failure) {
    notice.show(failure);
  }
}

/// The dev build's persona switcher: a small button on the tab shell that
/// opens the list of seed personas.
class PersonaSwitcherButton extends ConsumerWidget {
  /// Creates the button. Build it only when `AppConfig.hasDevTools`.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.small(
      key: const Key('persona-switcher'),
      tooltip: 'Switch persona (dev build)',
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (_) => const _PersonaSheet(),
      ),
      child: const Icon(Icons.switch_account),
    );
  }
}

class _PersonaSheet extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(demoAccountsProvider);
    final current = switch (ref.watch(authControllerProvider)) {
      SignedIn(:final user) => user.email,
      SignedOut() => null,
    };

    return SafeArea(
      child: ListView(
        key: const Key('persona-sheet'),
        shrinkWrap: true,
        children: [
          ListTile(
            title: Text(
              'Switch persona',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: const Text(
              'Dev build only. Signs out and in again, as a person would.',
            ),
          ),
          for (final account in accounts)
            ListTile(
              key: Key('persona-${account.email}'),
              leading: const Icon(Icons.person_outline),
              title: Text(account.name),
              subtitle: Text(account.email),
              trailing: account.email == current
                  ? const Icon(Icons.check, semanticLabel: 'Signed in')
                  : null,
              enabled: account.email != current,
              onTap: () {
                final auth = ref.read(authControllerProvider.notifier);
                final notice = ref.read(signInNoticeProvider.notifier);
                Navigator.of(context).pop();
                switchPersona(auth, notice, account.email).ignore();
              },
            ),
        ],
      ),
    );
  }
}
