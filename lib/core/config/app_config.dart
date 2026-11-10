// core/config/app_config.dart
enum AppEnvironment { dev, staging, prod }

class AppConfig {
  const AppConfig({required this.environment, required this.appName});

  final AppEnvironment environment;
  final String appName;

  static AppConfig fromValues({
    required String environment,
    required String appName,
  }) {
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

    return AppConfig(environment: parsedEnvironment, appName: appName);
  }

  static AppConfig fromEnvironment() {
    const environment = String.fromEnvironment('APP_ENV');
    const appName = String.fromEnvironment('APP_NAME');

    return fromValues(environment: environment, appName: appName);
  }
}
