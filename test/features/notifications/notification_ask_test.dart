import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ronditrack_app/app/settings.dart';
import 'package:ronditrack_app/features/notifications/domain/push.dart';
import 'package:ronditrack_app/features/notifications/presentation/push_providers.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fake_push_client.dart';

const _payMabena =
    '/stokvels/${FakeSeed.mabenaFamilyId}/cycles/${FakeSeed.mabenaCycleId}/pay';
const _paySoweto =
    '/stokvels/${FakeSeed.sowetoTeachersId}/cycles/${FakeSeed.sowetoCycleId}/pay';

/// The app's own question, before Android's (README "Notifications",
/// question 4).
void main() {
  Future<void> pay(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(FilledButton, 'Pay'));
    await tester.pumpAndSettle();
  }

  testWidgets('never at launch: signing in and opening Home asks nothing', (
    tester,
  ) async {
    final client = FakePushClient();
    await pumpApp(
      tester,
      size: phone,
      overrides: [pushClientProvider.overrideWithValue(client)],
    );
    await typeSignIn(tester, FakeSeed.sipho.email);

    expect(find.text("Know when it's confirmed?"), findsNothing);
    expect(client.dialogs, 0);
  });

  testWidgets('after the first payment: our words first, and Not now is '
      'never asked again, though Android was never shown', (tester) async {
    final client = FakePushClient();
    final settings = InMemorySettingsStore();
    final app = await pumpApp(
      tester,
      as: FakeSeed.sipho,
      size: phone,
      coldStart: _payMabena,
      overrides: [
        pushClientProvider.overrideWithValue(client),
        settingsStoreProvider.overrideWithValue(settings),
      ],
    );

    await pay(tester);
    expect(find.text("Know when it's confirmed?"), findsOneWidget);
    expect(client.dialogs, 0, reason: "Android's dialog only after a yes");

    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    expect(client.dialogs, 0);
    expect(settings.notificationsAsked, isTrue);

    // A payment in his other stokvel: not asked again.
    await openLink(tester, app, _paySoweto);
    await pay(tester);
    expect(find.text("Know when it's confirmed?"), findsNothing);
    expect(client.dialogs, 0);
  });

  testWidgets("a yes: then Android's dialog, once; a refusal still lets "
      'everything work, and Profile says so', (tester) async {
    final client = FakePushClient(answer: PushPermission.denied);
    final settings = InMemorySettingsStore();
    final app = await pumpApp(
      tester,
      as: FakeSeed.sipho,
      size: phone,
      coldStart: _payMabena,
      overrides: [
        pushClientProvider.overrideWithValue(client),
        settingsStoreProvider.overrideWithValue(settings),
      ],
    );

    await pay(tester);
    await tester.tap(find.text('Yes, tell me'));
    await tester.pumpAndSettle();

    expect(client.dialogs, 1);
    expect(find.text('Paid. The cycle is up to date.'), findsOneWidget);

    await openLink(tester, app, '/profile');
    await tester.scrollUntilVisible(find.text('Notifications'), 200);
    expect(
      find.text(
        "Off. To get them, allow notifications for RondiTrack in Android's "
        'settings.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('push off (no Firebase file): never asked, and Profile says '
      "it isn't in this build", (tester) async {
    final settings = InMemorySettingsStore();
    final app = await pumpApp(
      tester,
      as: FakeSeed.sipho,
      size: phone,
      coldStart: _payMabena,
      overrides: [settingsStoreProvider.overrideWithValue(settings)],
    );

    await pay(tester);
    expect(find.text("Know when it's confirmed?"), findsNothing);
    expect(settings.notificationsAsked, isFalse);

    await openLink(tester, app, '/profile');
    await tester.scrollUntilVisible(
      find.text('Not available in this build.'),
      200,
    );
    expect(find.text('Not available in this build.'), findsOneWidget);
  });

  testWidgets('the version, read from the installed build, where a tester '
      'can quote it', (tester) async {
    PackageInfo.setMockInitialValues(
      appName: 'RondiTrack Staging',
      packageName: 'za.co.gwinya.ronditrack_app.staging',
      version: '1.4.0',
      buildNumber: '37',
      buildSignature: '',
    );
    await pumpApp(
      tester,
      as: FakeSeed.sipho,
      size: phone,
      config: stagingConfig,
      coldStart: '/profile',
    );
    await tester.scrollUntilVisible(
      find.text('Version 1.4.0 (37) · staging'),
      200,
    );

    expect(find.text('Version 1.4.0 (37) · staging'), findsOneWidget);
  });
}
