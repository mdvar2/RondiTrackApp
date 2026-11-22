import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/core/config/app_config_scope.dart';
import 'package:ronditrack_app/core/widgets/message_panel.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/payments/presentation/sign_out_guard.dart';

/// `/splash`: shown while the one refresh on launch decides who is signed
/// in, so a signed-in person never sees the sign-in form flash first.
///
/// If the refresh can't tell (no signal, the server's fault, a `429`), the
/// person is not signed out: they get Try again, and Sign out. It never
/// navigates; the gate moves on when the auth state changes.
class SplashScreen extends ConsumerWidget {
  /// Creates the splash.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final failure = switch (auth) {
      Restoring(:final failure) => failure,
      // The gate is about to move on.
      SignedIn() || SignedOut() => null,
    };
    final appName = AppConfigScope.of(context).appName;

    return Scaffold(
      body: SafeArea(
        child: failure == null
            ? Center(
                key: const Key('splash-restoring'),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      appName,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 24),
                    const CircularProgressIndicator(
                      semanticsLabel: 'Signing you in',
                    ),
                  ],
                ),
              )
            : MessagePanel(
                key: const Key('splash-offline'),
                title: failure.message,
                body:
                    "You're still signed in. We'll open your stokvels once "
                    'we reach the server.',
                reference: failure.reference,
                action: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    FilledButton(
                      key: const Key('splash-retry'),
                      onPressed: () =>
                          ref.read(authControllerProvider.notifier).restore(),
                      child: const Text('Try again'),
                    ),
                    OutlinedButton(
                      key: const Key('splash-sign-out'),
                      onPressed: () => signOutAskingFirst(context, ref),
                      child: const Text('Sign out'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
