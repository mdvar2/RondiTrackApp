import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/app.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/config/app_config.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/home/presentation/home_screen.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

import 'helpers/app_harness.dart';

void main() {
  for (final (environment, appName, apiBaseUrl) in [
    ('dev', 'RondiTrack Dev', 'http://10.0.2.2:5101'),
    ('prod', 'RondiTrack', 'https://api.ronditrack.example'),
  ]) {
    testWidgets('the $environment app opens on Home, titled "$appName"', (
      tester,
    ) async {
      final config = AppConfig.fromValues(
        environment: environment,
        appName: appName,
        apiBaseUrl: apiBaseUrl,
        nativeFlavor: environment,
      );

      // Since 10.2 the app opens behind the gate, so Lerato is signed in.
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fakeDelayProvider.overrideWithValue(Duration.zero),
            authControllerProvider.overrideWith(
              () => StartingAuthController(signedInAs(FakeSeed.lerato)),
            ),
          ],
          child: RondiTrackApp(config: config),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.widgetWithText(AppBar, appName), findsOneWidget);
      expect(find.byType(HomeStokvelCard), findsNWidgets(2));
    });
  }

  testWidgets('signed out, the app opens on sign-in', (tester) async {
    await pumpApp(tester);

    expect(find.widgetWithText(AppBar, 'Sign in'), findsOneWidget);
    expect(find.byType(HomeStokvelCard), findsNothing);
  });
}
