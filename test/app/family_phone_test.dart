import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/activity/presentation/activity_controller.dart';
import 'package:ronditrack_app/features/auth/data/fake_auth_repository.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/auth/presentation/sign_in_screen.dart';
import 'package:ronditrack_app/features/home/presentation/home_controller.dart';
import 'package:ronditrack_app/features/invites/data/fake_invite_repository.dart';
import 'package:ronditrack_app/features/invites/domain/invite_preview.dart';
import 'package:ronditrack_app/features/invites/domain/invite_repository.dart';
import 'package:ronditrack_app/features/payouts/presentation/payout_order_provider.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/presentation/close_cycle_provider.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_detail_provider.dart';

import '../helpers/app_harness.dart';

const String _mabena = FakeSeed.mabenaFamilyId;
const String _soweto = FakeSeed.sowetoTeachersId;
const String _mabenaCycle = FakeSeed.mabenaCycleId;
const String _sowetoCycle = FakeSeed.sowetoCycleId;

Finder _tab(String label) => find.descendant(
  of: find.byKey(const Key('nav-bar')),
  matching: find.text(label),
);

/// Whether anything holding Lerato's stokvels, cycles, contributions or
/// arrears still exists in [app].
List<String> _herProviders(ProviderContainer app) => [
  if (app.exists(homeControllerProvider)) 'homeController',
  if (app.exists(activityControllerProvider)) 'activityController',
  for (final id in [_mabena, _soweto])
    if (app.exists(stokvelDetailProvider(id))) 'stokvelDetail($id)',
  for (final (id, cycle) in [
    (_mabena, _mabenaCycle),
    (_soweto, _sowetoCycle),
  ]) ...[
    if (app.exists(cycleDetailProvider(id, cycle))) 'cycleDetail($id)',
    if (app.exists(closePreviewProvider(id, cycle))) 'closePreview($id)',
    if (app.exists(payoutOrderProvider((stokvelId: id, cycleId: cycle))))
      'payoutOrder($id)',
  ],
];

/// The fake invites, counting every join sent.
class _CountingInvites implements InviteRepository {
  new(this.inner, this.joins);

  final InviteRepository inner;
  final List<String> joins;

  @override
  Future<Result<InvitePreview>> fetchInvite(String code) =>
      inner.fetchInvite(code);

  @override
  Future<Result<String>> join(String code) {
    joins.add(code);
    return inner.join(code);
  }
}

void main() {
  testWidgets('the family phone: Lerato signs in, opens her Treasurer '
      'stokvel, signs out; her brother signs in and sees only his '
      'world', (tester) async {
    final app = await pumpApp(tester, size: phone);
    expect(find.byType(SignInScreen), findsOneWidget);

    // Lerato.
    await typeSignIn(tester, FakeSeed.lerato.email);
    expect(find.text('Mabena Family'), findsOneWidget);
    await tester.tap(find.text('Mabena Family'));
    await tester.pumpAndSettle();
    expect(find.text('Your role: Treasurer'), findsOneWidget);
    expect(_herProviders(app), contains('stokvelDetail($_mabena)'));

    // Sign out, from Profile.
    await tester.tap(_tab('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sign-out')));
    await tester.pumpAndSettle();

    expect(find.byType(SignInScreen), findsOneWidget);
    expect(app.read(authControllerProvider), const SignedOut());
    expect(_herProviders(app), isEmpty);
    expect(app.read(signedInUserIdProvider), isNull);
    final auth = app.read(authRepositoryProvider) as FakeAuthRepository;
    expect(auth.storedEmail, isNull, reason: 'nothing stored to restore');

    // Her brother: another of the seed personas.
    await typeSignIn(tester, FakeSeed.thabo.email);

    expect(app.read(authControllerProvider), signedInAs(FakeSeed.thabo));
    // Back where the last person left the phone: Profile, now his.
    expect(locationOf(app), '/profile');
    expect(find.text(FakeSeed.thabo.name), findsOneWidget);
    await tester.tap(_tab('Home'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home-empty')), findsOneWidget);
    for (final hers in [
      'Mabena Family',
      'Soweto Teachers',
      'Your role: Treasurer',
      FakeSeed.lerato.name,
      FakeSeed.lerato.email,
    ]) {
      expect(find.text(hers, skipOffstage: false), findsNothing, reason: hers);
      expect(
        find.textContaining(hers, skipOffstage: false),
        findsNothing,
        reason: hers,
      );
    }
    // None of her providers were kept; his Home is his own.
    for (final name in _herProviders(app)) {
      expect(name, 'homeController', reason: 'only his Home exists');
    }
    expect(app.exists(stokvelDetailProvider(_mabena)), isFalse);
    expect(await app.read(homeControllerProvider.future), isEmpty);
  });

  group('the join link survives sign-in', () {
    late List<String> joins;

    List<Override> counting() {
      joins = [];
      return [
        inviteRepositoryProvider.overrideWith(
          (ref) => _CountingInvites(
            FakeInviteRepository(
              userId: ref.watch(signedInUserIdProvider),
              stokvels: ref.watch(fakeStokvelsProvider),
              delay: Duration.zero,
            ),
            joins,
          ),
        ),
      ];
    }

    testWidgets('opened signed out from a cold start: through the splash and '
        'sign-in, it joins once and lands in the stokvel; back, a rotation '
        'and a rebuild never join again', (tester) async {
      final app = await pumpApp(
        tester,
        size: phone,
        coldStart: '/join/SOWETO26',
        overrides: counting(),
      );
      expect(locationOf(app), '/sign-in?from=%2Fjoin%2FSOWETO26');

      await typeSignIn(tester, FakeSeed.thabo.email);

      expect(locationOf(app), '/stokvels/$_soweto');
      expect(find.text('Your role: Member'), findsOneWidget);
      expect(joins, ['SOWETO26']);

      // A rotation: the window turns on its side.
      tester.view.physicalSize = const Size(640, 360);
      await tester.pumpAndSettle();
      // Back, to the list.
      await pressBack(tester);
      expect(locationOf(app), '/stokvels');
      // The invite opened again, now a member: offered the stokvel.
      await openLink(tester, app, '/join/SOWETO26');
      expect(find.byKey(const Key('invite-open')), findsOneWidget);

      expect(joins, ['SOWETO26']);
    });

    testWidgets('after registering instead, the same', (tester) async {
      final app = await pumpApp(
        tester,
        size: phone,
        coldStart: '/join/MABENA26',
        overrides: counting(),
      );
      await tester.tap(find.byKey(const Key('sign-in-register')));
      await tester.pumpAndSettle();
      expect(locationOf(app), '/register?from=%2Fjoin%2FMABENA26');

      await tester.enterText(find.byKey(const Key('register-name')), 'Zanele');
      await tester.enterText(
        find.byKey(const Key('register-email')),
        'zanele@ronditrack.example',
      );
      await tester.enterText(
        find.byKey(const Key('auth-password')),
        typedPassword,
      );
      await tester.tap(find.byKey(const Key('auth-submit')));
      await tester.pumpAndSettle();

      expect(locationOf(app), '/stokvels/$_mabena');
      expect(joins, ['MABENA26']);
    });

    testWidgets('someone already a member goes straight to the stokvel', (
      tester,
    ) async {
      final app = await pumpApp(
        tester,
        size: phone,
        coldStart: '/join/MABENA26',
        overrides: counting(),
      );

      await typeSignIn(tester, FakeSeed.lerato.email);

      expect(locationOf(app), '/stokvels/$_mabena');
      expect(find.text('Your role: Treasurer'), findsOneWidget);
    });

    testWidgets('a wrong code says so, after sign-in', (tester) async {
      final app = await pumpApp(
        tester,
        size: phone,
        coldStart: '/join/NOPE',
        overrides: counting(),
      );

      await typeSignIn(tester, FakeSeed.thabo.email);

      expect(locationOf(app), '/join/NOPE');
      expect(find.text("We couldn't find that invite."), findsOneWidget);
    });
  });
}
