import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/config/app_config.dart';

AppConfig _config({
  String environment = 'dev',
  String appName = 'RondiTrack Dev',
  String apiBaseUrl = 'http://10.0.2.2:5101',
  String? nativeFlavor = 'dev',
}) => AppConfig.fromValues(
  environment: environment,
  appName: appName,
  apiBaseUrl: apiBaseUrl,
  nativeFlavor: nativeFlavor,
);

final Matcher throwsConfigError = throwsA(isA<AppConfigException>());

void main() {
  group('AppConfig', () {
    test('accepts the development configuration', () {
      final config = _config();

      expect(config.environment, AppEnvironment.dev);
      expect(config.appName, 'RondiTrack Dev');
      expect(config.apiBaseUri, Uri.parse('http://10.0.2.2:5101'));
    });

    test('accepts the staging configuration', () {
      final config = _config(
        environment: 'staging',
        appName: 'RondiTrack Staging',
        apiBaseUrl: 'https://staging.api.ronditrack.example',
        nativeFlavor: 'staging',
      );

      expect(config.environment, AppEnvironment.staging);
    });

    test('accepts the production configuration', () {
      final config = _config(
        environment: 'prod',
        appName: 'RondiTrack',
        apiBaseUrl: 'https://api.ronditrack.example',
        nativeFlavor: 'prod',
      );

      expect(config.environment, AppEnvironment.prod);
    });

    group('refuses to start without a config', () {
      test('when APP_ENV is missing', () {
        expect(() => _config(environment: ''), throwsConfigError);
      });

      test('when nothing at all was defined', () {
        // What `flutter run --flavor dev` with no
        // --dart-define-from-file gives AppConfig.fromEnvironment.
        expect(
          () => _config(environment: '', appName: '', apiBaseUrl: ''),
          throwsConfigError,
        );
      });

      test('from the real environment of this test run', () {
        // `flutter test` passes no --dart-define-from-file, so this is the
        // app starting with no config file at all.
        expect(
          () => AppConfig.fromEnvironment(nativeFlavor: 'dev'),
          throwsConfigError,
        );
      });

      test('when APP_ENV is unknown', () {
        expect(() => _config(environment: 'testing'), throwsConfigError);
      });

      test('when APP_NAME is missing', () {
        expect(() => _config(appName: ''), throwsConfigError);
      });

      test('when API_BASE_URL is missing', () {
        expect(() => _config(apiBaseUrl: ''), throwsConfigError);
      });

      test('when API_BASE_URL is not an absolute http(s) address', () {
        expect(() => _config(apiBaseUrl: 'localhost:5101'), throwsConfigError);
        expect(() => _config(apiBaseUrl: 'ftp://x.example'), throwsConfigError);
      });
    });

    group('refuses a build whose native flavour does not match', () {
      test('a prod build given config/dev.json', () {
        expect(() => _config(nativeFlavor: 'prod'), throwsConfigError);
      });

      test('a dev build given config/prod.json', () {
        expect(
          () => _config(
            environment: 'prod',
            appName: 'RondiTrack',
            apiBaseUrl: 'https://api.ronditrack.example',
          ),
          throwsConfigError,
        );
      });

      test('a build with no native flavour', () {
        expect(() => _config(nativeFlavor: null), throwsConfigError);
      });
    });

    test('rejects mismatched app name', () {
      // The prod launcher name on a dev build.
      expect(() => _config(appName: 'RondiTrack'), throwsConfigError);
    });

    test('rejects plain http outside dev', () {
      expect(
        () => _config(
          environment: 'prod',
          appName: 'RondiTrack',
          apiBaseUrl: 'http://api.ronditrack.example',
          nativeFlavor: 'prod',
        ),
        throwsConfigError,
      );
    });
  });
}
