import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/config/app_config_scope.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/auth/presentation/sign_in_notice.dart';

/// The fake sign-in: an email, and Sign in.
///
/// It never navigates. Signing in changes the auth state; the gate then
/// moves on, to the remembered address or Home.
class SignInScreen extends ConsumerStatefulWidget {
  /// Creates the screen.
  const new({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

/// Where a sign-in attempt is. One value instead of two flags (`busy` and
/// `error`), so "busy with an error showing" can't be written: the rule a
/// reviewer used to check by eye is now the compiler's.
sealed class _Progress {
  const new();
}

/// Waiting for the person.
final class _Ready extends _Progress {
  const new();
}

/// Signing in; the form is locked.
final class _Busy extends _Progress {
  const new();
}

/// The last attempt failed, saying why.
final class _Failed extends _Progress {
  const new(this.message);

  final String message;
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _email = TextEditingController();
  _Progress _progress = const _Ready();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    ref.read(signInNoticeProvider.notifier).clear();
    setState(() => _progress = const _Busy());
    try {
      await ref.read(authControllerProvider.notifier).signIn(_email.text);
    } on Failure catch (failure) {
      // The failure's own words: a refused email, the wait after too many
      // attempts, no answer.
      _fail(failure.message);
    } on Object catch (error) {
      _fail(failureOf(error).message);
    }
  }

  void _fail(String message) {
    if (!mounted) return;
    setState(() => _progress = _Failed(message));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // The seed personas are offered in the dev build only, like the
    // persona switcher; staging and prod testers type an email.
    final accounts = AppConfigScope.of(context).hasDevTools
        ? ref.watch(demoAccountsProvider)
        : const <({String name, String email})>[];
    final busy = switch (_progress) {
      _Busy() => true,
      _Ready() || _Failed() => false,
    };
    final error = switch (_progress) {
      _Failed(:final message) => message,
      _Ready() || _Busy() => null,
    };
    final notice = ref.watch(signInNoticeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('RondiTrack', style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  const Text('Sign in with the email you registered with.'),
                  if (notice != null) ...[
                    const SizedBox(height: 16),
                    Card(
                      key: const Key('sign-in-notice'),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(notice),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  TextField(
                    key: const Key('sign-in-email'),
                    controller: _email,
                    enabled: !busy,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _signIn(),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                      errorText: error,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    key: const Key('sign-in-submit'),
                    onPressed: busy ? null : _signIn,
                    child: Text(busy ? 'Signing in…' : 'Sign in'),
                  ),
                  if (accounts.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    Text('Test accounts', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final account in accounts)
                          ActionChip(
                            label: Text(account.name),
                            onPressed: busy
                                ? null
                                : () => _email.text = account.email,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
