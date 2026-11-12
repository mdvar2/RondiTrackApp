import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/features/activity/data/fake_activity_repository.dart';
import 'package:ronditrack_app/features/activity/data/flaky_activity_repository.dart';
import 'package:ronditrack_app/features/auth/data/fake_auth_repository.dart';
import 'package:ronditrack_app/features/auth/domain/auth_repository.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_app/features/invites/data/fake_invite_repository.dart';
import 'package:ronditrack_app/features/invites/domain/invite_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';

const String _mabena = FakeSeed.mabenaFamilyId;
const String _soweto = FakeSeed.sowetoTeachersId;

void main() {
  group('a cycle by id', () {
    FakeStokvelRepository repo(FakePersona persona) =>
        FakeStokvelRepository(userId: persona.id, delay: Duration.zero);

    test("a member gets the cycle and its stokvel's contributions", () async {
      final detail = await repo(FakeSeed.lerato)
          .fetchCycle(_mabena, FakeSeed.mabenaCycleId);

      expect(detail.cycle.id, FakeSeed.mabenaCycleId);
      expect(detail.stokvel.name, 'Mabena Family');
      expect(detail.contributions, hasLength(2));
    });

    test("not a member, another stokvel's cycle, or no such cycle: all "
        'the same CycleNotFoundException', () async {
      await expectLater(
        repo(FakeSeed.thabo).fetchCycle(_mabena, FakeSeed.mabenaCycleId),
        throwsA(isA<CycleNotFoundException>()),
      );
      await expectLater(
        repo(FakeSeed.lerato).fetchCycle(_mabena, FakeSeed.sowetoCycleId),
        throwsA(isA<CycleNotFoundException>()),
      );
      await expectLater(
        repo(FakeSeed.lerato).fetchCycle(_mabena, 'no-such-cycle'),
        throwsA(isA<CycleNotFoundException>()),
      );
      await expectLater(
        repo(FakeSeed.lerato).fetchCycle('no-such-stokvel', 'x'),
        throwsA(isA<CycleNotFoundException>()),
      );
    });

    test('signed out, every stokvel is not found', () async {
      await expectLater(
        FakeStokvelRepository(
          userId: null,
          delay: Duration.zero,
        ).fetchStokvel(_mabena),
        throwsA(isA<StokvelNotFoundException>()),
      );
    });
  });

  group('activity', () {
    test("Lerato's feed covers both stokvels, newest first", () async {
      final items = await FakeActivityRepository(
        userId: FakeSeed.lerato.id,
        delay: Duration.zero,
      ).fetchActivity();

      expect(items.map((i) => i.stokvelId).toSet(), {_mabena, _soweto});
      for (var i = 1; i < items.length; i++) {
        expect(items[i - 1].occurredAt.isAfter(items[i].occurredAt), isTrue);
      }
    });

    test('Thabo, and nobody signed in, have none', () async {
      for (final userId in [FakeSeed.thabo.id, null]) {
        final items = await FakeActivityRepository(
          userId: userId,
          delay: Duration.zero,
        ).fetchActivity();
        expect(items, isEmpty);
      }
    });
  });

  group('invites', () {
    test('a code previews its stokvel', () async {
      final invite = await FakeInviteRepository(
        userId: FakeSeed.thabo.id,
        stokvels: FakeSeed.fresh(),
        delay: Duration.zero,
      ).fetchInvite('MABENA26');

      expect(invite.stokvelId, _mabena);
      expect(invite.stokvelName, 'Mabena Family');
      expect(invite.memberCount, 3);
    });

    test('an unknown code is InviteNotFoundException', () async {
      await expectLater(
        FakeInviteRepository(
          userId: FakeSeed.thabo.id,
          stokvels: FakeSeed.fresh(),
          delay: Duration.zero,
        ).fetchInvite('NOPE'),
        throwsA(isA<InviteNotFoundException>()),
      );
    });

    test('joining makes Thabo a Member everywhere the fakes look, without '
        'touching the seed', () async {
      final shared = FakeSeed.fresh();
      final id = await FakeInviteRepository(
        userId: FakeSeed.thabo.id,
        stokvels: shared,
        delay: Duration.zero,
      ).join('MABENA26');

      expect(id, _mabena);
      final home = await FakeHomeRepository(
        userId: FakeSeed.thabo.id,
        delay: Duration.zero,
        stokvels: shared,
      ).fetchHome();
      expect(home.single.membership.role, StokvelRole.member);

      final seedRoles = FakeSeed.stokvels
          .firstWhere((s) => s.stokvel.id == _mabena)
          .roles;
      expect(seedRoles.containsKey(FakeSeed.thabo.id), isFalse);
    });

    test("joining a stokvel you're in keeps your role", () async {
      final shared = FakeSeed.fresh();
      await FakeInviteRepository(
        userId: FakeSeed.lerato.id,
        stokvels: shared,
        delay: Duration.zero,
      ).join('MABENA26');

      final mabena = shared.firstWhere((s) => s.stokvel.id == _mabena);
      expect(mabena.roles[FakeSeed.lerato.id], StokvelRole.treasurer);
    });
  });

  group('sign-in', () {
    final auth = FakeAuthRepository(delay: Duration.zero);

    test('by email, ignoring case and spaces', () async {
      final user = await auth.signIn(email: '  Sipho@RondiTrack.example ');
      expect(user.id, FakeSeed.sipho.id);
      expect(user.name, 'Sipho Dlamini');
    });

    test('an unknown email is SignInFailedException', () async {
      await expectLater(
        auth.signIn(email: 'someone@example.com'),
        throwsA(isA<SignInFailedException>()),
      );
    });

    test('the app starts signed out; signing in and out moves the user id '
        'every repository reads', () async {
      final container = ProviderContainer.test(
        overrides: [fakeDelayProvider.overrideWithValue(Duration.zero)],
      );

      expect(container.read(authControllerProvider), const SignedOut());
      expect(container.read(signedInUserIdProvider), isNull);

      await container
          .read(authControllerProvider.notifier)
          .signIn(FakeSeed.lerato.email);
      expect(container.read(signedInUserIdProvider), FakeSeed.lerato.id);
      final home = await container.read(homeRepositoryProvider).fetchHome();
      expect(home, hasLength(2));

      await container.read(authControllerProvider.notifier).signOut();
      expect(container.read(signedInUserIdProvider), isNull);
      expect(await container.read(homeRepositoryProvider).fetchHome(), isEmpty);
    });

    test('a failed sign-in stays signed out', () async {
      final container = ProviderContainer.test(
        overrides: [fakeDelayProvider.overrideWithValue(Duration.zero)],
      );

      await expectLater(
        container.read(authControllerProvider.notifier).signIn('x@y.z'),
        throwsA(isA<SignInFailedException>()),
      );
      expect(container.read(authControllerProvider), const SignedOut());
    });
  });

  test('FAKE_FAIL_EVERY also wraps the activity fake', () {
    final plain = ProviderContainer.test();
    final flaky = ProviderContainer.test(
      overrides: [fakeFailEveryProvider.overrideWithValue(3)],
    );

    expect(
      plain.read(activityRepositoryProvider),
      isA<FakeActivityRepository>(),
    );
    expect(
      flaky.read(activityRepositoryProvider),
      isA<FlakyActivityRepository>(),
    );
  });
}
