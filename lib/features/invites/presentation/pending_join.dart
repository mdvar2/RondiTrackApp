import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pending_join.g.dart';

/// The invite a signed-out person was joining when sign-in (or register)
/// took over: set as they submit the form, from the sign-in page's `from`
/// (`/join/:code`), and taken, once, by that invite's screen when the gate
/// lands them there. Taking it starts the join; nothing else does, so going
/// back, rotating the phone or a rebuild never joins again.
///
/// Lifetime: keepAlive. It has to outlive the sign-in screen that sets it.
@Riverpod(keepAlive: true)
class PendingJoin extends _$PendingJoin {
  @override
  String? build() => null;

  /// Remembers the code, when [returnTo] is that invite's address; forgets
  /// any other.
  void rememberFor(String? returnTo) {
    final match = _joinAddress.firstMatch(returnTo ?? '');
    state = match?.group(1);
  }

  /// Forgets it: the sign-in it waited for failed.
  void forget() => state = null;

  /// Whether a join for [code] was waiting, forgetting it: `true` once.
  bool take(String code) {
    if (state != code) return false;
    state = null;
    return true;
  }

  static final _joinAddress = RegExp(r'^/join/([\w-]+)$');
}
