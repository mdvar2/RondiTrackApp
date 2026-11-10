// test/core/config/app_config_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('accepts the development configuration', () {
      final config = AppConfig.fromValues(
        environment: 'dev',
        appName: 'RondiTrack Dev',
      );

      expect(config.environment, AppEnvironment.dev);
      expect(config.appName, 'RondiTrack Dev');
    });

    test('accepts the staging configuration', () {
      final config = AppConfig.fromValues(
        environment: 'staging',
        appName: 'RondiTrack Staging',
      );

      expect(config.environment, AppEnvironment.staging);
    });

    test('accepts the production configuration', () {
      final config = AppConfig.fromValues(
        environment: 'prod',
        appName: 'RondiTrack',
      );

      expect(config.environment, AppEnvironment.prod);
    });

    test('rejects missing environment', () {
      expect(
        () => AppConfig.fromValues(environment: '', appName: 'RondiTrack'),
        throwsStateError,
      );
    });

    test('rejects unknown environment', () {
      expect(
        () =>
            AppConfig.fromValues(environment: 'testing', appName: 'RondiTrack'),
        throwsStateError,
      );
    });

    test('rejects mismatched app name', () {
      expect(
        () => AppConfig.fromValues(
          environment: 'prod',
          appName: 'RondiTrack Dev',
        ),
        throwsStateError,
      );
    });

    test('rejects missing app name', () {
      expect(
        () => AppConfig.fromValues(environment: 'dev', appName: ''),
        throwsStateError,
      );
    });
  });
}
