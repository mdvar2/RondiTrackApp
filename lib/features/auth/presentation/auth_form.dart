import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/features/auth/presentation/sign_in_support.dart';

/// The frame sign-in and register share: a title, a line of explanation,
/// and the form, centred and no wider than 480 dp, scrolling under large
/// text.
class AuthFormFrame extends StatelessWidget {
  /// Creates the frame.
  const new({
    required this.title,
    required this.intro,
    required this.children,
    super.key,
  });

  /// The app bar's title.
  final String title;

  /// One line under the app's name.
  final String intro;

  /// The form.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'RondiTrack',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(intro),
                    const SizedBox(height: 24),
                    ...children,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A password field with a labelled show/hide button.
class PasswordField extends StatefulWidget {
  /// Creates the field.
  const new({
    required this.controller,
    required this.enabled,
    required this.autofillHint,
    required this.onSubmitted,
    this.errorText,
    this.helperText,
    super.key,
  });

  /// The typed password.
  final TextEditingController controller;

  /// Whether it can be typed in.
  final bool enabled;

  /// [AutofillHints.password] or [AutofillHints.newPassword].
  final String autofillHint;

  /// Called on the keyboard's done key.
  final VoidCallback onSubmitted;

  /// What is wrong with it, under it.
  final String? errorText;

  /// A hint under it, when nothing is wrong.
  final String? helperText;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('auth-password'),
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: _hidden,
      autocorrect: false,
      enableSuggestions: false,
      autofillHints: [widget.autofillHint],
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => widget.onSubmitted(),
      decoration: InputDecoration(
        labelText: 'Password',
        border: const OutlineInputBorder(),
        errorText: widget.errorText,
        helperText: widget.helperText,
        suffixIcon: IconButton(
          tooltip: _hidden ? 'Show password' : 'Hide password',
          icon: Icon(_hidden ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _hidden = !_hidden),
        ),
      ),
    );
  }
}

/// The submit button: disabled while busy, and while the API's `429` wait
/// runs, saying how long is left.
class AuthSubmitButton extends ConsumerWidget {
  /// Creates the button.
  const new({
    required this.label,
    required this.busyLabel,
    required this.busy,
    required this.onPressed,
    super.key,
  });

  /// What it does.
  final String label;

  /// What it says while it is doing it.
  final String busyLabel;

  /// Whether a request is running.
  final bool busy;

  /// What it does.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wait = ref.watch(signInCooldownProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (wait > 0) ...[
          Text(
            RateLimitedFailure(wait: Duration(seconds: wait)).message,
            key: const Key('auth-wait'),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          const SizedBox(height: 8),
        ],
        FilledButton(
          key: const Key('auth-submit'),
          onPressed: busy || wait > 0 ? null : onPressed,
          child: Text(busy ? busyLabel : label),
        ),
      ],
    );
  }
}

/// A message for the whole form: why the last attempt failed, when no one
/// field is to blame.
class FormMessage extends StatelessWidget {
  /// Creates the message.
  const new(this.message, {this.reference, super.key});

  /// What went wrong.
  final String message;

  /// A server failure's reference, to quote.
  final String? reference;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final reference = this.reference;
    return Semantics(
      liveRegion: true,
      child: Card(
        key: const Key('auth-message'),
        color: scheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            reference == null ? message : '$message\nReference: $reference',
            style: TextStyle(color: scheme.onErrorContainer),
          ),
        ),
      ),
    );
  }
}
