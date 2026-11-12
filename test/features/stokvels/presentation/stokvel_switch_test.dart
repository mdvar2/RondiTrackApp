import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_stokvel_repository.dart';

import '../../../helpers/app_harness.dart';

void main() {
  // Assignment 10.1's Part 5 test, now through the router: the picker
  // changes the address, and the screen must still never show the previous
  // stokvel's contributions, not for one frame.
  testWidgets('Part 5: switching to a slow stokvel never shows the previous '
      "stokvel's contributions, not for one frame", (tester) async {
    const lerato = FakeSeed.lerato;
    const a = FakeSeed.mabenaFamilyId;
    const b = FakeSeed.sowetoTeachersId;
    final aContributions = FakeSeed.stokvels
        .firstWhere((entry) => entry.stokvel.id == a)
        .contributions;

    final container = await pumpApp(
      tester,
      as: lerato,
      coldStart: '/stokvels/$a',
      // Medium width (one pane, with the picker), tall enough that every
      // contribution is built.
      size: tabletPortrait,
      overrides: [
        stokvelRepositoryProvider.overrideWithValue(
          FakeStokvelRepository(
            userId: lerato.id,
            delay: Duration.zero,
            // Soweto Teachers, on Lerato's data bundle.
            slowStokvels: const {b: Duration(seconds: 5)},
          ),
        ),
      ],
    );

    // Stokvel A is on screen, with its contributions.
    expect(locationOf(container), '/stokvels/$a');
    expect(find.byKey(const Key('stokvel-data-$a')), findsOneWidget);
    for (final contribution in aContributions) {
      expect(
        find.byKey(Key('contribution-${contribution.id}')),
        findsOneWidget,
      );
    }

    // Switch to B from the app bar's picker.
    await tester.tap(find.byKey(const Key('stokvel-picker')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Soweto Teachers').last);

    // One frame.
    await tester.pump();

    expect(find.byKey(const Key('stokvel-loading-$b')), findsOneWidget);
    expect(find.text('Loading Soweto Teachers…'), findsOneWidget);
    expect(find.byKey(const Key('stokvel-data-$a')), findsNothing);
    for (final contribution in aContributions) {
      expect(find.byKey(Key('contribution-${contribution.id}')), findsNothing);
    }
    expect(find.text('Nomsa Mabena'), findsNothing);

    // The switch changed the address.
    expect(locationOf(container), '/stokvels/$b');

    // And B arrives once its slow load finishes.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('stokvel-data-$b')), findsOneWidget);
    expect(find.text('Kagiso Molefe'), findsOneWidget);
  });
}
