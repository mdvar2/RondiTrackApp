import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Where the refresh token is kept between launches: the only token that
/// is ever written down.
///
/// The app talks to this interface; tests use [InMemoryRefreshTokenStore],
/// because the real store needs the phone's Keystore (a test that reaches
/// it fails with `MissingPluginException`).
abstract interface class RefreshTokenStore {
  /// The stored refresh token, or `null` when there is none.
  Future<String?> read();

  /// Stores [token], replacing the one before it.
  Future<void> write(String token);

  /// Forgets the token.
  Future<void> delete();
}

/// [RefreshTokenStore] in `flutter_secure_storage`: on Android, a value
/// encrypted with a key that lives in the Android Keystore and never leaves
/// the phone. Android backup is off (README "The session"), so the
/// encrypted file is never restored to a phone without its key.
class SecureRefreshTokenStore implements RefreshTokenStore {
  /// Creates the store over [storage].
  new([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  /// The entry's key. It names the entry, not the API's cookie.
  static const _key = 'session.refresh';

  @override
  Future<String?> read() => _storage.read(key: _key);

  @override
  Future<void> write(String token) => _storage.write(key: _key, value: token);

  @override
  Future<void> delete() => _storage.delete(key: _key);
}

/// [RefreshTokenStore] in memory, for tests. It counts what was done to it.
class InMemoryRefreshTokenStore implements RefreshTokenStore {
  /// Creates the store holding [token], if any.
  new([this.token]);

  /// The token held.
  String? token;

  /// How many times a token was written.
  int writes = 0;

  @override
  Future<String?> read() async => token;

  @override
  Future<void> write(String token) async {
    writes++;
    this.token = token;
  }

  @override
  Future<void> delete() async => token = null;
}
