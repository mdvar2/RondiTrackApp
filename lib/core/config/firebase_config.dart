import 'package:ronditrack_app/core/config/app_config.dart';

/// A flavour's Firebase project, from its own git-ignored
/// `config/firebase.<flavour>.json`, passed as a second
/// `--dart-define-from-file` (README "Notifications").
///
/// Settings, not secrets: they say which project, not how to act as it.
/// They stay out of the repository because each person uses their own
/// Firebase project.
class FirebaseConfig {
  /// The four values `Firebase.initializeApp` needs on Android.
  const new({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
  });

  /// The four values, or `null` with none of them: push is off and the app
  /// runs as before. With some but not all, it refuses to start: a half
  /// configured project would fail later, quietly.
  static FirebaseConfig? fromValues({
    required String apiKey,
    required String appId,
    required String messagingSenderId,
    required String projectId,
  }) {
    final values = {
      'FIREBASE_API_KEY': apiKey.trim(),
      'FIREBASE_APP_ID': appId.trim(),
      'FIREBASE_MESSAGING_SENDER_ID': messagingSenderId.trim(),
      'FIREBASE_PROJECT_ID': projectId.trim(),
    };
    final missing = [
      for (final MapEntry(:key, :value) in values.entries)
        if (value.isEmpty) key,
    ];
    if (missing.length == values.length) return null;
    if (missing.isNotEmpty) {
      throw AppConfigException(
        'Firebase is half configured: ${missing.join(', ')} '
        '${missing.length == 1 ? 'is' : 'are'} missing. Pass all four with '
        '--dart-define-from-file=config/firebase.<flavour>.json, or none.',
      );
    }
    return FirebaseConfig(
      apiKey: values['FIREBASE_API_KEY']!,
      appId: values['FIREBASE_APP_ID']!,
      messagingSenderId: values['FIREBASE_MESSAGING_SENDER_ID']!,
      projectId: values['FIREBASE_PROJECT_ID']!,
    );
  }

  /// Reads the four values from the Dart defines.
  static FirebaseConfig? fromEnvironment() => fromValues(
    apiKey: const String.fromEnvironment('FIREBASE_API_KEY'),
    appId: const String.fromEnvironment('FIREBASE_APP_ID'),
    messagingSenderId: const String.fromEnvironment(
      'FIREBASE_MESSAGING_SENDER_ID',
    ),
    projectId: const String.fromEnvironment('FIREBASE_PROJECT_ID'),
  );

  /// The Android API key.
  final String apiKey;

  /// The Android app id (`1:…:android:…`).
  final String appId;

  /// The project's sender id.
  final String messagingSenderId;

  /// The project id.
  final String projectId;
}
