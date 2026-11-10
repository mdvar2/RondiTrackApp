// core/config/app_config.dart
/// The supported RondiTrack deployment environments.
enum AppEnvironment {
  /// Local development environment.
  dev,

  /// Pre-production testing environment.
  staging,

  /// Production environment.
  prod,
}

/// Validated application configuration for a deployment environment.
class AppConfig {
  /// Creates a validated configuration from explicit values.
  factory fromValues({required String environment, required String appName}) {
    final parsedEnvironment = switch (environment) {
      'dev' => AppEnvironment.dev,
      'staging' => AppEnvironment.staging,
      'prod' => AppEnvironment.prod,
      _ => throw StateError('Invalid or missing APP_ENV: "$environment"'),
    };

    final expectedName = switch (parsedEnvironment) {
      AppEnvironment.dev => 'RondiTrack Dev',
      AppEnvironment.staging => 'RondiTrack Staging',
      AppEnvironment.prod => 'RondiTrack',
    };

    if (appName != expectedName) {
      throw StateError(
        'Invalid APP_NAME for $environment: '
        'expected "$expectedName", received "$appName"',
      );
    }

    return AppConfig._(environment: parsedEnvironment, appName: appName);
  }

  /// Reads the configuration supplied through Dart environment definitions.
  factory fromEnvironment() {
    const environment = String.fromEnvironment('APP_ENV');
    const appName = String.fromEnvironment('APP_NAME');

    return AppConfig.fromValues(environment: environment, appName: appName);
  }

  /// Creates a configuration with an already parsed environment.
  const new _({required this.environment, required this.appName});

  /// The selected deployment environment.
  final AppEnvironment environment;

  /// The display name of the application.
  final String appName;
}
