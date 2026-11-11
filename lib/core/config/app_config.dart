/// The supported RondiTrack deployment environments.
///
/// Each value's [name] is also the native flavour (`--flavor`) it must be
/// built with.
enum AppEnvironment {
  /// Local development environment.
  dev,

  /// Pre-production testing environment.
  staging,

  /// Production environment.
  prod,
}

/// Thrown when the app is started without a usable configuration.
///
/// The app refuses to start rather than guess a value.
class AppConfigException implements Exception {
  /// Creates the exception with a message that names what is wrong.
  const new(this.message);

  /// What is wrong with the configuration.
  final String message;

  @override
  String toString() => 'AppConfigException: $message';
}

/// Validated application configuration for a deployment environment.
///
/// The values come from `config/<flavour>.json`, passed with
/// `--dart-define-from-file`. Nothing in them is secret.
class AppConfig {
  /// Creates a validated configuration from explicit values.
  ///
  /// [nativeFlavor] is the flavour the native app was built with (Flutter's
  /// `appFlavor`). It must equal [environment], so a prod build given
  /// `config/dev.json` refuses to start.
  factory fromValues({
    required String environment,
    required String appName,
    required String apiBaseUrl,
    required String? nativeFlavor,
  }) {
    final parsedEnvironment = switch (environment) {
      'dev' => AppEnvironment.dev,
      'staging' => AppEnvironment.staging,
      'prod' => AppEnvironment.prod,
      _ => throw AppConfigException(
        'Invalid or missing APP_ENV: "$environment". Run with '
        '--dart-define-from-file=config/<flavour>.json.',
      ),
    };

    if (nativeFlavor == null || nativeFlavor.isEmpty) {
      throw AppConfigException(
        'No native flavour. Build with --flavor ${parsedEnvironment.name}.',
      );
    }

    if (nativeFlavor != parsedEnvironment.name) {
      throw AppConfigException(
        'The native flavour "$nativeFlavor" does not match the config file '
        'for "${parsedEnvironment.name}".',
      );
    }

    final expectedName = switch (parsedEnvironment) {
      AppEnvironment.dev => 'RondiTrack Dev',
      AppEnvironment.staging => 'RondiTrack Staging',
      AppEnvironment.prod => 'RondiTrack',
    };

    if (appName != expectedName) {
      throw AppConfigException(
        'Invalid APP_NAME for $environment: '
        'expected "$expectedName", received "$appName"',
      );
    }

    final baseUri = Uri.tryParse(apiBaseUrl);
    final validBase =
        baseUri != null &&
        baseUri.hasAuthority &&
        (baseUri.scheme == 'http' || baseUri.scheme == 'https');
    if (!validBase) {
      throw AppConfigException(
        'Invalid or missing API_BASE_URL for $environment: "$apiBaseUrl"',
      );
    }

    if (parsedEnvironment != AppEnvironment.dev && baseUri.scheme != 'https') {
      throw AppConfigException('API_BASE_URL for $environment must use https.');
    }

    return AppConfig._(
      environment: parsedEnvironment,
      appName: appName,
      apiBaseUri: baseUri,
    );
  }

  /// Reads the configuration supplied through Dart environment definitions,
  /// checked against the native flavour the app was built with.
  factory fromEnvironment({required String? nativeFlavor}) {
    const environment = String.fromEnvironment('APP_ENV');
    const appName = String.fromEnvironment('APP_NAME');
    const apiBaseUrl = String.fromEnvironment('API_BASE_URL');

    return AppConfig.fromValues(
      environment: environment,
      appName: appName,
      apiBaseUrl: apiBaseUrl,
      nativeFlavor: nativeFlavor,
    );
  }

  /// Creates a configuration with already validated values.
  const new _({
    required this.environment,
    required this.appName,
    required this.apiBaseUri,
  });

  /// The selected deployment environment.
  final AppEnvironment environment;

  /// The display name of the application.
  final String appName;

  /// The RondiTrack API this flavour talks to (from Week 11).
  final Uri apiBaseUri;
}
