import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/app/router/routes.dart';
import 'package:ronditrack_app/core/config/app_config_scope.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_form.dart';
import 'package:ronditrack_app/features/auth/presentation/sign_in_notice.dart';
import 'package:ronditrack_app/features/auth/presentation/sign_in_support.dart';
import 'package:ronditrack_app/features/invites/presentation/pending_join.dart';

/// Sign-in: an email, a password, and Sign in.
///
/// It never navigates on success. Signing in changes the auth state; the
/// gate then moves on, to [from] or Home. If [from] is an invite
/// (`/join/:code`), the join is remembered as the form is sent, and that
/// invite's screen joins once it opens.
class SignInScreen extends ConsumerStatefulWidget {
  /// Creates the screen.
  const new({this.from, super.key});

  /// Where the gate will go once signed in.
  final String? from;

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  Failure? _failure;

  @override
  void initState() {
    super.initState();
    // The dev build's persona switcher fills in the email; never the
    // password.
    final draft = ref.read(signInEmailDraftProvider);
    if (draft != null) {
      _email.text = draft;
      // Used once; cleared after this frame (a provider can't change
      // while the tree builds).
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(signInEmailDraftProvider.notifier).clear(),
      );
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_busy || ref.read(signInCooldownProvider) > 0) return;
    ref.read(signInNoticeProvider.notifier).clear();
    ref.read(pendingJoinProvider.notifier).rememberFor(widget.from);
    setState(() {
      _busy = true;
      _failure = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .signIn(email: _email.text, password: _password.text);
    } on Object catch (error) {
      ref.read(pendingJoinProvider.notifier).forget();
      final failure = failureOf(error);
      if (failure case RateLimitedFailure(:final wait?)) {
        ref.read(signInCooldownProvider.notifier).wait(wait);
      }
      if (!mounted) return;
      setState(() {
        _busy = false;
        _failure = failure;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // The seed personas are offered in the dev build only, like the
    // persona switcher: choosing one fills in the email.
    final accounts = AppConfigScope.of(context).hasDevTools
        ? ref.watch(demoAccountsProvider)
        : const <({String name, String email})>[];
    final notice = ref.watch(signInNoticeProvider);
    final failure = _failure;
    final fieldErrors = switch (failure) {
      ValidationFailure(:final fieldErrors) => fieldErrors,
      _ => const <String, List<String>>{},
    };

    return AuthFormFrame(
      title: 'Sign in',
      intro: 'Sign in with the email you registered with.',
      children: [
        if (notice != null) ...[
          Card(
            key: const Key('sign-in-notice'),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(notice),
            ),
          ),
          const SizedBox(height: 16),
        ],
        TextField(
          key: const Key('sign-in-email'),
          controller: _email,
          enabled: !_busy,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          autofillHints: const [AutofillHints.email, AutofillHints.username],
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Email',
            border: const OutlineInputBorder(),
            errorText: fieldErrors['email']?.join(' '),
          ),
        ),
        const SizedBox(height: 16),
        PasswordField(
          controller: _password,
          enabled: !_busy,
          autofillHint: AutofillHints.password,
          onSubmitted: _signIn,
          errorText: fieldErrors['password']?.join(' '),
        ),
        const SizedBox(height: 16),
        // A refused sign-in says only that the two don't match: never
        // which one was wrong. A 429's words are on the button's wait.
        if (failure != null &&
            failure is! RateLimitedFailure &&
            fieldErrors.isEmpty) ...[
          FormMessage(failure.message, reference: failure.reference),
          const SizedBox(height: 16),
        ],
        AuthSubmitButton(
          label: 'Sign in',
          busyLabel: 'Signing in…',
          busy: _busy,
          onPressed: _signIn,
        ),
        const SizedBox(height: 8),
        TextButton(
          key: const Key('sign-in-register'),
          onPressed: _busy
              ? null
              : () => RegisterRoute(from: widget.from).go(context),
          child: const Text('New here? Create an account'),
        ),
        if (accounts.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Test accounts (dev build): fills in the email',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final account in accounts)
                ActionChip(
                  key: Key('test-account-${account.email}'),
                  label: Text(account.name),
                  onPressed: _busy ? null : () => _email.text = account.email,
                ),
            ],
          ),
        ],
      ],
    );
  }
}
