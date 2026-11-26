import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/auth/data/last_user_store.dart';
import 'package:ronditrack_app/features/auth/domain/auth_repository.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/domain/auth_user.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/home/presentation/home_screen.dart';
import 'package:ronditrack_app/features/notifications/data/device_registries.dart';
import 'package:ronditrack_app/features/notifications/domain/push.dart';
import 'package:ronditrack_app/features/notifications/presentation/push_providers.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_app/features/stokvels/domain/cycle_close_preview.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';
import 'package:ronditrack_app/features/stokvels/presentation/cycle_screen.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fake_push_client.dart';
import '../../helpers/test_database.dart';

const _cycle =
    '/stokvels/${FakeSeed.mabenaFamilyId}/cycles/${FakeSeed.mabenaCycleId}';

final _tap = <String, String>{
  'type': contributionUpdateType,
  'stokvelId': FakeSeed.mabenaFamilyId,
  'cycleId': FakeSeed.mabenaCycleId,
};

/// A registry that notes whether the member was still signed in when the
/// API was asked to forget the phone.
class _OrderRegistry extends FakeDeviceRegistry {
  AuthState Function()? auth;
  AuthState? atForget;

  @override
  Future<Result<void>> forget(String installationId) {
    atForget = auth?.call();
    return super.forget(installationId);
  }
}

/// Sipho's fake stokvels, counting each cycle fetch.
class _CountingCycles implements StokvelRepository {
  final _inner = FakeStokvelRepository(
    userId: FakeSeed.sipho.id,
    delay: Duration.zero,
    stokvels: FakeSeed.fresh(),
  );
  int cycleFetches = 0;

  @override
  Future<Result<StokvelDetail>> fetchStokvel(String stokvelId) =>
      _inner.fetchStokvel(stokvelId);

  @override
  Future<Result<CycleDetail>> fetchCycle(String stokvelId, String cycleId) {
    cycleFetches++;
    return _inner.fetchCycle(stokvelId, cycleId);
  }

  @override
  Future<Result<CycleClosePreview>> fetchClosePreview(
    String stokvelId,
    String cycleId,
  ) => _inner.fetchClosePreview(stokvelId, cycleId);
}

final _sipho = AuthUser(
  id: FakeSeed.sipho.id,
  name: FakeSeed.sipho.name,
  email: FakeSeed.sipho.email,
);

/// An auth repository whose launch-time restore answers [answer].
class _Restores implements AuthRepository {
  new(this.answer);

  final Result<AuthUser?> answer;

  @override
  Future<Result<AuthUser?>> restore() async => answer;

  @override
  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  }) async => Ok(_sipho);

  @override
  Future<Result<AuthUser>> register({
    required String name,
    required String email,
    required String password,
  }) async => Ok(_sipho);

  @override
  Future<void> signOut() async {}
}

void main() {
  group('the whole app, with push on (a fake plugin)', () {
    testWidgets('sign-in registers this phone for the person signing in', (
      tester,
    ) async {
      final devices = FakeDeviceRegistry();
      await pumpApp(
        tester,
        size: phone,
        overrides: [
          pushClientProvider.overrideWithValue(FakePushClient()),
          deviceRegistryProvider.overrideWithValue(devices),
        ],
      );
      expect(devices.calls, isEmpty, reason: 'nobody is signed in yet');

      await typeSignIn(tester, FakeSeed.sipho.email);

      expect(devices.calls, ['register fid-1']);
    });

    for (final (name, restored) in [
      ('a restored session', Ok<AuthUser?>(_sipho)),
      ('an offline launch, as the member last signed in', null),
    ]) {
      testWidgets('$name registers too', (tester) async {
        final devices = FakeDeviceRegistry();
        final db = memoryDatabase();
        addTearDown(db.close);
        await tester.runAsync(() => DriftLastUser(db).remember(_sipho));

        final app = await pumpApp(
          tester,
          size: phone,
          database: db,
          overrides: [
            pushClientProvider.overrideWithValue(FakePushClient()),
            deviceRegistryProvider.overrideWithValue(devices),
            authRepositoryProvider.overrideWithValue(
              _Restores(restored ?? const Err(NoAnswerFailure())),
            ),
          ],
        );

        expect(app.read(authControllerProvider), SignedIn(_sipho));
        expect(devices.calls, ['register fid-1']);
      });
    }

    testWidgets('sign-out tells the API first, while still signed in, then '
        'ends the session', (tester) async {
      final devices = _OrderRegistry();
      final app = await pumpApp(
        tester,
        size: phone,
        overrides: [
          pushClientProvider.overrideWithValue(FakePushClient()),
          deviceRegistryProvider.overrideWithValue(devices),
        ],
      );
      devices.auth = () => app.read(authControllerProvider);
      await typeSignIn(tester, FakeSeed.sipho.email);

      await app.read(authControllerProvider.notifier).signOut();
      await tester.pumpAndSettle();

      expect(devices.calls, ['register fid-1', 'forget fid-1']);
      expect(devices.atForget, isA<SignedIn>());
      expect(app.read(authControllerProvider), isA<SignedOut>());
    });

    testWidgets('push off (no Firebase file): the app runs as before and '
        'registers nothing', (tester) async {
      final devices = FakeDeviceRegistry();
      await pumpApp(
        tester,
        size: phone,
        overrides: [deviceRegistryProvider.overrideWithValue(devices)],
      );

      await typeSignIn(tester, FakeSeed.sipho.email);

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(devices.calls, isEmpty);
    });

    testWidgets('in front: that cycle is fetched again', (tester) async {
      final client = FakePushClient();
      final stokvels = _CountingCycles();
      await pumpApp(
        tester,
        as: FakeSeed.sipho,
        size: phone,
        coldStart: _cycle,
        overrides: [
          pushClientProvider.overrideWithValue(client),
          stokvelRepositoryProvider.overrideWithValue(stokvels),
        ],
      );
      expect(find.byType(CycleScreen), findsOneWidget);
      final before = stokvels.cycleFetches;

      client.arrive(_tap);
      await tester.pumpAndSettle();

      expect(stokvels.cycleFetches, before + 1);
    });

    testWidgets('a tap from the background opens that cycle', (tester) async {
      final client = FakePushClient();
      final app = await pumpApp(
        tester,
        as: FakeSeed.sipho,
        size: phone,
        overrides: [pushClientProvider.overrideWithValue(client)],
      );
      expect(find.byType(HomeScreen), findsOneWidget);

      client.tap(_tap);
      await tester.pumpAndSettle();

      expect(find.byType(CycleScreen), findsOneWidget);
      expect(locationOf(app), _cycle);
    });

    testWidgets('a tap whose data is not a known push goes nowhere', (
      tester,
    ) async {
      final client = FakePushClient();
      final app = await pumpApp(
        tester,
        as: FakeSeed.sipho,
        size: phone,
        overrides: [pushClientProvider.overrideWithValue(client)],
      );

      client.tap({..._tap, 'stokvelId': '../../me'});
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(locationOf(app), '/');
    });
  });

  group('a tap from a closed app', () {
    testWidgets('signed in: the cycle, from the first frame, with no flash '
        'of Home', (tester) async {
      final app = await pumpApp(
        tester,
        as: FakeSeed.sipho,
        size: phone,
        settle: false,
        overrides: [pushStartLocationProvider.overrideWithValue(_cycle)],
      );
      await tester.pump();
      expect(find.byType(HomeScreen), findsNothing);

      await tester.pumpAndSettle();
      expect(find.byType(CycleScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
      expect(locationOf(app), _cycle);
    });

    testWidgets('signed out: sign in, then that cycle', (tester) async {
      final app = await pumpApp(
        tester,
        size: phone,
        overrides: [pushStartLocationProvider.overrideWithValue(_cycle)],
      );
      expect(
        find.text('Sign in with the email you registered with.'),
        findsOneWidget,
      );

      await typeSignIn(tester, FakeSeed.sipho.email);

      expect(find.byType(CycleScreen), findsOneWidget);
      expect(locationOf(app), _cycle);
    });

    testWidgets("signed in as someone who isn't a member: not found, not "
        "someone else's cycle", (tester) async {
      await pumpApp(
        tester,
        as: FakeSeed.thabo,
        size: phone,
        overrides: [pushStartLocationProvider.overrideWithValue(_cycle)],
      );

      expect(find.textContaining("couldn't find"), findsWidgets);
      expect(find.text(FakeSeed.sipho.name), findsNothing);
      expect(find.text(FakeSeed.lerato.name), findsNothing);
    });
  });
}
