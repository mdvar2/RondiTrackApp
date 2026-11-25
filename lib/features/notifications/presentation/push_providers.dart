import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/app/router/router.dart';
import 'package:ronditrack_app/features/home/presentation/home_controller.dart';
import 'package:ronditrack_app/features/notifications/domain/push.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_detail_provider.dart';

part 'push_providers.g.dart';

/// The Firebase plugin, or `null` with push off (no
/// `config/firebase.<flavour>.json`). `main` overrides it.
@Riverpod(keepAlive: true)
PushClient? pushClient(Ref ref) => null;

/// Where a tap from a closed app asked to go, read before the first frame:
/// the router starts there, with no flash of Home. `main` overrides it.
@Riverpod(keepAlive: true)
String? pushStartLocation(Ref ref) => null;

/// Keeps the API's record of this phone in step with who is signed in.
/// The auth controller calls it; it never reads the auth state (one way:
/// Riverpod refuses providers that depend on each other).
@Riverpod(keepAlive: true)
PushRegistration pushRegistration(Ref ref) {
  final registration = PushRegistration(
    client: ref.watch(pushClientProvider),
    devices: ref.watch(deviceRegistryProvider),
  );
  ref.onDispose(registration.dispose);
  return registration;
}

/// What the app does with a push while it runs (README "Notifications",
/// question 3). Watched by the app.
///
/// * In front: the plugin file shows it on the app's channel; here, that
///   cycle (and Home) is fetched again. A push is a nudge to fetch, never
///   the news.
/// * A tap from the background: that cycle opens, through the router and
///   its gate, as a deep link would.
@Riverpod(keepAlive: true)
void pushRouting(Ref ref) {
  final client = ref.watch(pushClientProvider);
  if (client == null) return;
  final foreground = client.onForeground.listen((data) {
    final location = pushToLocation(data);
    if (location == null) return;
    ref
      ..invalidate(homeControllerProvider)
      ..invalidate(stokvelDetailProvider(data['stokvelId']!))
      ..invalidate(cycleDetailProvider(data['stokvelId']!, data['cycleId']!));
  });
  final taps = client.onTapped.listen((data) {
    final location = pushToLocation(data);
    if (location != null) ref.read(routerProvider).go(location);
  });
  ref.onDispose(() {
    unawaited(foreground.cancel());
    unawaited(taps.cancel());
  });
}
