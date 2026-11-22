import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_support.g.dart';

/// The email the dev build's persona switcher chose, waiting for the
/// sign-in form to fill it in. Only the email: the password is typed.
///
/// Lifetime: keepAlive. It is written as the signed-in screens go away and
/// read by the sign-in screen that replaces them.
@Riverpod(keepAlive: true)
class SignInEmailDraft extends _$SignInEmailDraft {
  @override
  String? build() => null;

  /// Fills the next sign-in form with [email].
  void fill(String email) => state = email.trim();

  /// Forgets it: the form has it.
  void clear() => state = null;
}

/// How many seconds sign-in and register must wait, after the API's `429`
/// said how long (`Retry-After`); 0 when they may be tried. Both forms
/// read it, because the API counts them together, per address.
///
/// Lifetime: keepAlive, so leaving the form doesn't forget the wait. It
/// counts down once a second.
@Riverpod(keepAlive: true)
class SignInCooldown extends _$SignInCooldown {
  Timer? _timer;

  @override
  int build() {
    ref.onDispose(() => _timer?.cancel());
    return 0;
  }

  /// Waits [wait], the API's `Retry-After`, rounded up to whole seconds.
  void wait(Duration wait) {
    _timer?.cancel();
    state = (wait.inMilliseconds / 1000).ceil();
    if (state <= 0) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state - 1;
      if (state <= 0) timer.cancel();
    });
  }
}
