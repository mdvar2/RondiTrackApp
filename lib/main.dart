import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/app.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/config/app_config.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Refuses to start without a config, or with one that doesn't match the
  // native flavour (`appFlavor`, set by `--flavor`).
  final config = AppConfig.fromEnvironment(nativeFlavor: appFlavor);

  // Until Week 11's sign-in, choose a seed persona with
  // --dart-define=FAKE_PERSONA=lerato|sipho|thabo (Lerato by default).
  const personaKey = String.fromEnvironment('FAKE_PERSONA');
  final persona = FakeSeed.personas[personaKey];

  // Dev only: --dart-define=FAKE_FAIL_EVERY=3 makes the fakes fail the first
  // call and every third after it, to show failure and retry on a phone.
  final failEvery = fakeFailEveryFor(
    config.environment,
    const int.fromEnvironment('FAKE_FAIL_EVERY'),
  );

  runApp(
    ProviderScope(
      overrides: [
        if (persona != null)
          signedInUserIdProvider.overrideWithValue(persona.id),
        if (failEvery > 0) fakeFailEveryProvider.overrideWithValue(failEvery),
      ],
      child: RondiTrackApp(config: config),
    ),
  );
}
