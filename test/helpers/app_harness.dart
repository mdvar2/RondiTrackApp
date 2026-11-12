import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ronditrack_app/app/app.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/app/router/router.dart';
import 'package:ronditrack_app/core/config/app_config.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/domain/auth_user.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

/// The dev flavour's configuration.
final devConfig = AppConfig.fromValues(
  environment: 'dev',
  appName: 'RondiTrack Dev',
  apiBaseUrl: 'http://10.0.2.2:5101',
  nativeFlavor: 'dev',
);

/// The auth state of [persona] signed in.
AuthState signedInAs(FakePersona persona) => SignedIn(
  AuthUser(id: persona.id, name: persona.name, email: persona.email),
);

/// An [AuthController] that starts with [initial] instead of signed out.
class StartingAuthController extends AuthController {
  /// Starts at [initial].
  new(this.initial);

  /// The state the app starts in.
  final AuthState initial;

  @override
  AuthState build() => initial;
}

/// A phone: 360 by 640 dp.
const phone = Size(360, 640);

/// A tablet on its side: 1280 by 800 dp.
const tabletLandscape = Size(1280, 800);

/// A tablet upright: 800 by 1280 dp.
const tabletPortrait = Size(800, 1280);

/// Pumps the real app (router, gate, theme, shell) on fakes that answer at
/// once, and returns its container.
///
/// [as] starts it signed in as that persona (signed out when `null`).
/// [coldStart] opens it at that address the way a deep link starts a
/// stopped app: as the platform's initial route. [size] and [textScale]
/// set the window and the text size.
Future<ProviderContainer> pumpApp(
  WidgetTester tester, {
  FakePersona? as,
  String? coldStart,
  Size? size,
  double? textScale,
  Brightness? brightness,
  List<Override> overrides = const [],
}) async {
  if (size != null) {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }
  if (textScale != null) {
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  }
  if (brightness != null) {
    tester.platformDispatcher.platformBrightnessTestValue = brightness;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
  }
  if (coldStart != null) {
    tester.platformDispatcher.defaultRouteNameTestValue = coldStart;
    addTearDown(tester.platformDispatcher.clearDefaultRouteNameTestValue);
  }

  final container = ProviderContainer(
    overrides: [
      fakeDelayProvider.overrideWithValue(Duration.zero),
      if (as != null)
        authControllerProvider.overrideWith(
          () => StartingAuthController(signedInAs(as)),
        ),
      ...overrides,
    ],
    retry: (retryCount, error) => null,
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: RondiTrackApp(config: devConfig),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

/// The router's current address.
String locationOf(ProviderContainer container) {
  final router = container.read(routerProvider);
  return router.routerDelegate.currentConfiguration.uri.toString();
}

/// Goes to [location], as a link opened while the app runs does.
Future<void> openLink(
  WidgetTester tester,
  ProviderContainer container,
  String location,
) async {
  container.read(routerProvider).go(location);
  await tester.pumpAndSettle();
}

/// Presses Android's back button (or makes the back gesture).
Future<void> pressBack(WidgetTester tester) async {
  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();
}

/// The router, for tests that need its delegate.
GoRouter routerOf(ProviderContainer container) =>
    container.read(routerProvider);
