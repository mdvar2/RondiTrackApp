import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings.g.dart';

/// The person's settings on this phone: settings only, never data (data is
/// in the database, and goes at sign-out; settings stay).
abstract interface class SettingsStore {
  /// The chosen language code (`en`, `af`), or `null` to follow the phone.
  String? get language;

  /// Keeps [code], or forgets it with `null`.
  Future<void> setLanguage(String? code);
}

/// [SettingsStore] in SharedPreferences: survives a restart and a
/// sign-out.
class PreferencesSettingsStore implements SettingsStore {
  new _(this._prefs);

  /// Opens the store. `main` waits for it before the first frame.
  static Future<PreferencesSettingsStore> open() async =>
      PreferencesSettingsStore._(
        await SharedPreferencesWithCache.create(
          cacheOptions: const SharedPreferencesWithCacheOptions(
            allowList: {_languageKey},
          ),
        ),
      );

  final SharedPreferencesWithCache _prefs;

  static const _languageKey = 'settings.language';

  @override
  String? get language => _prefs.getString(_languageKey);

  @override
  Future<void> setLanguage(String? code) => code == null
      ? _prefs.remove(_languageKey)
      : _prefs.setString(_languageKey, code);
}

/// [SettingsStore] in memory: tests, and the default until `main` gives the
/// real one.
class InMemorySettingsStore implements SettingsStore {
  /// Creates the store with [language].
  new({this.language});

  @override
  String? language;

  @override
  Future<void> setLanguage(String? code) async => language = code;
}

/// Where settings are kept. `main` overrides it with
/// [PreferencesSettingsStore].
@Riverpod(keepAlive: true)
SettingsStore settingsStore(Ref ref) => InMemorySettingsStore();

/// The app's language: the person's choice, or `null` to follow the phone.
///
/// Lifetime: keepAlive, and not rebuilt at sign-out: a setting belongs to
/// the phone, not to who is signed in.
@Riverpod(keepAlive: true)
class LanguageChoice extends _$LanguageChoice {
  @override
  Locale? build() => switch (ref.watch(settingsStoreProvider).language) {
    final String code => Locale(code),
    null => null,
  };

  /// Chooses [locale], or the phone's with `null`, and keeps the choice.
  Future<void> choose(Locale? locale) async {
    await ref.read(settingsStoreProvider).setLanguage(locale?.languageCode);
    state = locale;
  }
}
