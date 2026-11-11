import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/fakes/fail_every.dart';

void main() {
  test('every 3: the first call fails, then every third after it', () {
    final failures = FailEvery(3);

    expect(
      [for (var call = 0; call < 7; call++) failures.next()],
      [true, false, false, true, false, false, true],
    );
  });

  test('every 1: every call fails', () {
    final failures = FailEvery(1);

    expect(
      [failures.next(), failures.next(), failures.next()],
      [true, true, true],
    );
  });
}
