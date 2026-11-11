import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/money/rand_format.dart';

void main() {
  // Every space below is written as   on purpose: a real no-break space
  // looks exactly like an ordinary one.
  group('formatRand', () {
    final cases = <int, String>{
      0: 'R 0,00',
      1: 'R 0,01',
      10: 'R 0,10',
      15050: 'R 150,50',
      99999: 'R 999,99',
      100000: 'R 1 000,00',
      150000: 'R 1 500,00',
      12345678: 'R 123 456,78',
      100000000: 'R 1 000 000,00',
      -15050: '-R 150,50',
      -10: '-R 0,10',
      -150000: '-R 1 500,00',
    };

    for (final MapEntry(key: cents, value: expected) in cases.entries) {
      test('$cents cents is ${expected.replaceAll(' ', '·')}', () {
        expect(formatRand(Cents(cents)), expected);
      });
    }

    test('never contains an ordinary space', () {
      for (final cents in cases.keys) {
        expect(formatRand(Cents(cents)), isNot(contains(' ')));
      }
    });
  });

  group('Cents', () {
    test('adds and subtracts as whole cents', () {
      expect(const Cents(15050) + const Cents(50), const Cents(15100));
      expect(const Cents(100) - const Cents(150), const Cents(-50));
      expect(const Cents(-1).isNegative, isTrue);
      expect(Cents.zero.isZero, isTrue);
      expect(const Cents(2) > const Cents(1), isTrue);
      expect(const Cents(1) < const Cents(2), isTrue);
    });
  });
}
