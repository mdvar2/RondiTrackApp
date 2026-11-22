import 'package:ronditrack_app/features/auth/domain/auth_user.dart';

/// Who was last signed in on this phone, kept with their cached data so the
/// app can open as them with no signal. It goes when the data goes.
abstract interface class LastUser {
  /// The person, or `null` when nobody has signed in since the phone was
  /// last emptied.
  Future<AuthUser?> read();

  /// Remembers [user].
  Future<void> remember(AuthUser user);
}
