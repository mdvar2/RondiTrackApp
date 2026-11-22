import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/app.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/app/retry.dart';
import 'package:ronditrack_app/app/settings.dart';
import 'package:ronditrack_app/core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Refuses to start without a config, or with one that doesn't match the
  // native flavour (`appFlavor`, set by `--flavor`).
  final config = AppConfig.fromEnvironment(nativeFlavor: appFlavor);

  // Dev only, with the fakes: --dart-define=FAKE_FAIL_EVERY=1 makes every
  // fake call fail, so the app's retries fail too and the failure state
  // stays; 3 fails the first call and every third after it, and the retry
  // recovers.
  final failEvery = fakeFailEveryFor(
    config.environment,
    const int.fromEnvironment('FAKE_FAIL_EVERY'),
  );

  // The API, unless a dev build asks for the fakes with
  // --dart-define=DATA_SOURCE=fakes.
  final dataSource = dataSourceFor(
    config.environment,
    const String.fromEnvironment('DATA_SOURCE'),
  );

  // Settings (the language) are read before the first frame, so the app
  // never draws in one language and then another.
  final settings = await PreferencesSettingsStore.open();

  runApp(
    ProviderScope(
      // Never retry "not found" (README "State with Riverpod").
      retry: appRetry,
      overrides: [
        appConfigProvider.overrideWithValue(config),
        settingsStoreProvider.overrideWithValue(settings),
        if (dataSource == DataSource.fakes)
          dataSourceProvider.overrideWithValue(DataSource.fakes),
        if (failEvery > 0) fakeFailEveryProvider.overrideWithValue(failEvery),
      ],
      child: RondiTrackApp(config: config),
    ),
  );
}
