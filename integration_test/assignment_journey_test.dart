import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ronditrack_app/app/router/router.dart';
import 'package:ronditrack_app/app/router/routes.dart';
import 'package:ronditrack_app/core/config/app_config.dart';
import 'package:ronditrack_app/features/home/presentation/home_screen.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/presentation/contributions_screen.dart';
import 'package:ronditrack_app/features/stokvels/presentation/cycle_screen.dart';

import '../test/helpers/app_harness.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('sign in, open contributions, then view the cycle', (
    tester,
  ) async {
    final app = await pumpApp(
      tester,
      config: AppConfig.fromValues(
        environment: 'dev',
        appName: 'RondiTrack Dev',
        apiBaseUrl: 'http://10.0.2.2:5101',
        refreshCookieName: '__Secure-ronditrack_refresh',
        nativeFlavor: 'dev',
      ),
    );

    await typeSignIn(tester, FakeSeed.lerato.email);
    expect(find.byType(HomeStokvelCard), findsNWidgets(2));

    await tester.tap(
      find.byKey(const Key('home-card-${FakeSeed.mabenaFamilyId}')),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('stokvel-data-${FakeSeed.mabenaFamilyId}')),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.byKey(const Key('open-contributions')),
      240,
    );
    expect(find.byKey(const Key('open-contributions')), findsOneWidget);

    await tester.tap(find.byKey(const Key('open-contributions')));
    await tester.pumpAndSettle();
    expect(find.byType(ContributionsScreen), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);

    app
        .read(routerProvider)
        .go(const StokvelRoute(id: FakeSeed.mabenaFamilyId).location);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('open-cycle-${FakeSeed.mabenaCycleId}')),
      240,
    );
    await tester.tap(
      find.byKey(const Key('open-cycle-${FakeSeed.mabenaCycleId}')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CycleScreen), findsOneWidget);
    expect(
      app.read(routerProvider).routerDelegate.currentConfiguration.uri.path,
      const CycleRoute(
        id: FakeSeed.mabenaFamilyId,
        cycleId: FakeSeed.mabenaCycleId,
      ).location,
    );
  });
}
