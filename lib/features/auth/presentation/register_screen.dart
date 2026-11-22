import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/router/routes.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_form.dart';
import 'package:ronditrack_app/features/auth/presentation/sign_in_support.dart';
import 'package:ronditrack_app/features/invites/presentation/pending_join.dart';

/// Register: a name, an email and a password. The API creates the account
/// without signing in, so the app signs in with the same details next, and
/// the gate moves on to [from] or Home, as after sign-in.
///
/// The API's field errors (`errors.name`, `errors.email`,
/// `errors.password`) appear under their fields; an address already in use
/// (its `409`) under the email. What was typed stays.
class RegisterScreen extends ConsumerStatefulWidget {
  /// Creates the screen.
  const new({this.from, super.key});

  /// Where the gate will go once registered and signed in.
  final String? from;

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  Failure? _failure;

  /// The API's rule (README "Contract notes › Auth"): checked here too, so
  /// the person hears it before sending, but the API's answer is the one
  /// that counts.
  static const _minimumPassword = 12;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_busy || ref.read(signInCooldownProvider) > 0) return;
    ref.read(pendingJoinProvider.notifier).rememberFor(widget.from);
    setState(() {
      _busy = true;
      _failure = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .register(
            name: _name.text,
            email: _email.text,
            password: _password.text,
          );
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
    final failure = _failure;
    final fieldErrors = switch (failure) {
      ValidationFailure(:final fieldErrors) => fieldErrors,
      _ => const <String, List<String>>{},
    };
    // The API's 409: an account already uses this address.
    final emailTaken = switch (failure) {
      RuleFailure(:final message) => message,
      _ => null,
    };
    final emailError = fieldErrors['email']?.join(' ') ?? emailTaken;
    final showFormMessage =
        failure != null &&
        failure is! RateLimitedFailure &&
        fieldErrors.isEmpty &&
        emailTaken == null;

    return AuthFormFrame(
      title: 'Create an account',
      intro: 'Create your RondiTrack account. You can join stokvels next.',
      children: [
        TextField(
          key: const Key('register-name'),
          controller: _name,
          enabled: !_busy,
          textCapitalization: TextCapitalization.words,
          autofillHints: const [AutofillHints.name],
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Your name',
            border: const OutlineInputBorder(),
            errorMaxLines: 4,
            errorText: fieldErrors['name']?.join(' '),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          key: const Key('register-email'),
          controller: _email,
          enabled: !_busy,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          autofillHints: const [AutofillHints.email, AutofillHints.username],
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Email',
            border: const OutlineInputBorder(),
            errorMaxLines: 4,
            errorText: emailError,
          ),
        ),
        const SizedBox(height: 16),
        PasswordField(
          controller: _password,
          enabled: !_busy,
          autofillHint: AutofillHints.newPassword,
          onSubmitted: _register,
          errorText: fieldErrors['password']?.join(' '),
          helperText: 'At least $_minimumPassword characters.',
        ),
        const SizedBox(height: 16),
        if (showFormMessage) ...[
          FormMessage(failure.message, reference: failure.reference),
          const SizedBox(height: 16),
        ],
        AuthSubmitButton(
          label: 'Create account',
          busyLabel: 'Creating your account…',
          busy: _busy,
          onPressed: _register,
        ),
        const SizedBox(height: 8),
        TextButton(
          key: const Key('register-sign-in'),
          onPressed: _busy
              ? null
              : () => SignInRoute(from: widget.from).go(context),
          child: const Text('Already registered? Sign in'),
        ),
      ],
    );
  }
}
