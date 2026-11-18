import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_stokvel_repository.dart';

import '../../../helpers/result_matchers.dart';

const String _mabena = FakeSeed.mabenaFamilyId;
const String _cycle = FakeSeed.mabenaCycleId;

FakeStokvelRepository _as(FakePersona persona) =>
    FakeStokvelRepository(userId: persona.id, delay: Duration.zero);

void main() {
  test("the Treasurer gets what closing would record: Sipho's R 500,00, as "
      'the API answers on the seed', () async {
    final preview = (await _as(
      FakeSeed.lerato,
    ).fetchClosePreview(_mabena, _cycle)).valueOrThrow;

    expect(preview.cycleId, _cycle);
    expect(preview.arrears.map((a) => (a.memberName, a.amount)), [
      ('Sipho Dlamini', const Cents(50000)),
    ]);
    expect(preview.total, const Cents(50000));
  });

  test("a Member is refused, like the API's 403", () async {
    expect(
      await _as(FakeSeed.sipho).fetchClosePreview(_mabena, _cycle),
      failsWith<ForbiddenFailure>(),
    );
  });

  test("a non-member, and another stokvel's cycle, are not found, like the "
      "API's 404", () async {
    expect(
      await _as(FakeSeed.thabo).fetchClosePreview(_mabena, _cycle),
      failsWith<NotFoundFailure>(),
    );
    expect(
      await _as(FakeSeed.lerato)
          .fetchClosePreview(_mabena, FakeSeed.sowetoCycleId),
      failsWith<NotFoundFailure>(),
    );
  });
}
