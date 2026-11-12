import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/app.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/config/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Refuses to start without a config, or with one that doesn't match the
  // native flavour (`appFlavor`, set by `--flavor`).
  final config = AppConfig.fromEnvironment(nativeFlavor: appFlavor);

  // Dev only: --dart-define=FAKE_FAIL_EVERY=1 makes every fake call fail, so
  // Riverpod's automatic retries fail too and the failure state stays; 3 fails
  // the first call and every third after it, and the automatic retry recovers.
  final failEvery = fakeFailEveryFor(
    config.environment,
    const int.fromEnvironment('FAKE_FAIL_EVERY'),
  );

  runApp(
    ProviderScope(
      overrides: [
        if (failEvery > 0) fakeFailEveryProvider.overrideWithValue(failEvery),
      ],
      child: RondiTrackApp(config: config),
    ),
  );
}
