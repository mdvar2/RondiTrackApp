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
    required String refreshCookieName,
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

    // The refresh cookie's name, as the API's `Set-Cookie` spells it. The
    // app finds the cookie by this name and never types it in code, so a
    // config without it can't sign anyone in: refuse to start, as for a
    // missing address. A cookie name is an RFC 6265 token.
    if (!_cookieName.hasMatch(refreshCookieName)) {
      throw AppConfigException(
        'Invalid or missing REFRESH_COOKIE_NAME for $environment: '
        '"$refreshCookieName"',
      );
    }

    return AppConfig._(
      environment: parsedEnvironment,
      appName: appName,
      apiBaseUri: baseUri,
      refreshCookieName: refreshCookieName,
    );
  }

  /// Reads the configuration supplied through Dart environment definitions,
  /// checked against the native flavour the app was built with.
  factory fromEnvironment({required String? nativeFlavor}) {
    const environment = String.fromEnvironment('APP_ENV');
    const appName = String.fromEnvironment('APP_NAME');
    const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
    const refreshCookieName = String.fromEnvironment('REFRESH_COOKIE_NAME');

    return AppConfig.fromValues(
      environment: environment,
      appName: appName,
      apiBaseUrl: apiBaseUrl,
      refreshCookieName: refreshCookieName,
      nativeFlavor: nativeFlavor,
    );
  }

  /// Creates a configuration with already validated values.
  const new _({
    required this.environment,
    required this.appName,
    required this.apiBaseUri,
    required this.refreshCookieName,
  });

  /// The selected deployment environment.
  final AppEnvironment environment;

  /// The display name of the application.
  final String appName;

  /// The RondiTrack API this flavour talks to (from Week 11).
  final Uri apiBaseUri;

  /// The name of the API's refresh-token cookie (`REFRESH_COOKIE_NAME`).
  /// The app reads that cookie from `Set-Cookie` by this name, and sends
  /// it back only to the refresh and logout endpoints.
  final String refreshCookieName;

  /// Whether this build has developer tools (the persona switcher, the
  /// sign-in page's test accounts, the session tools on Profile): the dev
  /// flavour only.
  ///
  /// Check it where a route or button is *built*, so that in staging and
  /// prod the tool is never constructed: not hidden, absent.
  bool get hasDevTools => switch (environment) {
    AppEnvironment.dev => true,
    AppEnvironment.staging || AppEnvironment.prod => false,
  };

  /// An RFC 6265 cookie name: one or more token characters.
  static final _cookieName = RegExp(r"^[!#$%&'*+\-.^_`|~0-9A-Za-z]+$");
}
