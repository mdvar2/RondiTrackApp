import 'dart:convert';
import 'dart:io';

/// `config/<flavour>.json`, as `--dart-define-from-file` reads it.
Map<String, String> flavourConfigFile(String flavour) =>
    (jsonDecode(File('config/$flavour.json').readAsStringSync()) as Map)
        .cast<String, String>();

/// The refresh cookie's name, from the dev flavour's config: tests read it
/// from there too, so it is typed in one place only.
final String refreshCookieName = flavourConfigFile(
  'dev',
)['REFRESH_COOKIE_NAME']!;
