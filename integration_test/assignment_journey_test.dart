import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/config/app_config.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

import '../test/helpers/app_harness.dart';

/// Pumps frames until [finder] finds something, or fails after [timeout].
///
/// On a phone, pumpAndSettle doesn't wait for a database file or a call:
/// this waits for the words a person waits for.
Future<void> waitFor(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 20),
}) async {
  final end = DateTime.now().add(timeout);
  while (finder.evaluate().isEmpty) {
    if (DateTime.now().isAfter(end)) {
      fail('Waited $timeout for ${finder.describeMatch(Plurality.one)}');
    }
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// The one journey on a real Android (README "Test plan", question 5):
/// sign in, record a contribution, and see it on the cycle. It crosses the
/// gate, the router, the pay form, the outbox and its database, and the
/// cycle's refetch. Against the app's own fakes, with the dev flavour.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('sign in, record a contribution, and see it on the cycle', (
    tester,
  ) async {
    // The flavour's own config, from the same --dart-define-from-file the
    // app runs with (README "Running the tests").
    final app = await pumpApp(
      tester,
      settle: false,
      config: AppConfig.fromEnvironment(nativeFlavor: appFlavor),
    );

    // Sign in, as Sipho would: by typing.
    await waitFor(
      tester,
      find.text('Sign in with the email you registered with.'),
    );
    await typeSignIn(tester, FakeSeed.sipho.email);

    // Home, then his stokvel.
    await waitFor(tester, find.text('Mabena Family'));
    await tester.tap(find.text('Mabena Family'));
    await waitFor(tester, find.text('Cycle 2026-11'));

    // Pay: the form is filled with the stokvel's contribution.
    final pay = find.widgetWithText(FilledButton, 'Pay');
    await tester.scrollUntilVisible(pay, 200);
    await tester.tap(pay);
    await waitFor(tester, find.text('Amount in rand'));
    await tester.tap(find.widgetWithText(FilledButton, 'Pay'));

    await waitFor(tester, find.text('Paid. The cycle is up to date.'));

    // The cycle, fetched again: his contribution is on it.
    final cycle = find.text('Cycle 2026-11');
    await waitFor(tester, cycle);
    await tester.scrollUntilVisible(cycle, -200);
    await tester.tap(cycle);
    await waitFor(tester, find.text('Contributions'));
    await waitFor(tester, find.text(FakeSeed.sipho.name));

    // What the screen can't show: nothing is left waiting to be sent.
    final waiting = await tester.runAsync(
      () => app.read(paymentOutboxProvider).waiting(),
    );
    expect(waiting, isEmpty);
  });
}
