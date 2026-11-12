import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/features/auth/domain/auth_repository.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';

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

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _email = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authControllerProvider.notifier).signIn(_email.text);
    } on SignInFailedException {
      _fail('No account uses that email.');
    } on Object {
      _fail("We couldn't sign you in. Check your connection and try again.");
    }
  }

  void _fail(String message) {
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accounts = ref.watch(demoAccountsProvider);
    final error = _error;

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
                  const SizedBox(height: 24),
                  TextField(
                    key: const Key('sign-in-email'),
                    controller: _email,
                    enabled: !_busy,
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
                    onPressed: _busy ? null : _signIn,
                    child: Text(_busy ? 'Signing in…' : 'Sign in'),
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
                            onPressed: _busy
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
