import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/core/errors/failure.dart';

part 'sign_in_notice.g.dart';

/// Why the person is looking at sign-in when they didn't ask to be: their
/// session ended (the API's `401`), or a persona switch was refused (too
/// many sign-ins: the wait, from `Retry-After`). `null` when there is
/// nothing to say.
///
/// Lifetime: keepAlive. It is written as the signed-in screens go away and
/// read by the sign-in screen that replaces them.
@Riverpod(keepAlive: true)
class SignInNotice extends _$SignInNotice {
  @override
  String? build() => null;

  /// Shows [failure]'s words on the sign-in screen.
  void show(Failure failure) => state = failure.message;

  /// Clears it: the person has read it and is signing in.
  void clear() => state = null;
}
