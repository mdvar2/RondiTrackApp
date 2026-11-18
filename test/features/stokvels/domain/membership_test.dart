import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_app/features/stokvels/domain/membership.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';

import '../../../helpers/result_matchers.dart';

void main() {
  const lerato = FakeSeed.lerato;

  test('memberships with the same values are equal', () {
    expect(
      const Membership(stokvelId: 'a', role: StokvelRole.member),
      const Membership(stokvelId: 'a', role: StokvelRole.member),
    );
    expect(
      const Membership(stokvelId: 'a', role: StokvelRole.member),
      isNot(const Membership(stokvelId: 'a', role: StokvelRole.treasurer)),
    );
  });

  group('the role belongs to the membership, not the person', () {
    test('Lerato, one login, is Treasurer of Mabena Family and Member of '
        'Soweto Teachers on Home', () async {
      final home = (await FakeHomeRepository(
        userId: lerato.id,
        delay: Duration.zero,
      ).fetchHome()).valueOrThrow;

      expect(home.map((entry) => entry.membership), [
        const Membership(
          stokvelId: FakeSeed.mabenaFamilyId,
          role: StokvelRole.treasurer,
        ),
        const Membership(
          stokvelId: FakeSeed.sowetoTeachersId,
          role: StokvelRole.member,
        ),
      ]);
    });

    test('and the same on each stokvel detail', () async {
      final repository = FakeStokvelRepository(
        userId: lerato.id,
        delay: Duration.zero,
      );

      final mabena = (await repository.fetchStokvel(FakeSeed.mabenaFamilyId))
          .valueOrThrow;
      final soweto = (await repository.fetchStokvel(FakeSeed.sowetoTeachersId))
          .valueOrThrow;

      expect(mabena.membership.role, StokvelRole.treasurer);
      expect(soweto.membership.role, StokvelRole.member);
    });

    test('Sipho is a Member of both, and Treasurer of neither', () async {
      final home = (await FakeHomeRepository(
        userId: FakeSeed.sipho.id,
        delay: Duration.zero,
      ).fetchHome()).valueOrThrow;

      expect(home.map((entry) => entry.membership.role), [
        StokvelRole.member,
        StokvelRole.member,
      ]);
    });

    test('Thabo is in no stokvel', () async {
      final home = (await FakeHomeRepository(
        userId: FakeSeed.thabo.id,
        delay: Duration.zero,
      ).fetchHome()).valueOrThrow;

      expect(home, isEmpty);
    });
  });

  group("a stokvel that isn't yours is the API's 404", () {
    test(
      'Thabo opening Mabena Family is not found, like a random id',
      () async {
        final repository = FakeStokvelRepository(
          userId: FakeSeed.thabo.id,
          delay: Duration.zero,
        );

        expect(
          await repository.fetchStokvel(FakeSeed.mabenaFamilyId),
          failsWith<StokvelNotFoundException>(),
        );
        expect(
          await repository.fetchStokvel('00000000-0000-0000-0000-000000000000'),
          failsWith<StokvelNotFoundException>(),
        );
      },
    );
  });
}
