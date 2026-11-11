import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/money/rand_parser.dart';

void main() {
  group('parseRand accepts', () {
    final accepted = <String, int>{
      '150': 15000,
      '150,50': 15050,
      '150,5': 15050,
      'R150': 15000,
      'R 150': 15000,
      'R 150': 15000,
      'R 1 500': 150000,
      'R 1 500': 150000,
      '1 500,50': 150050,
      '1 500,50': 150050,
      '1 500 ': 150000,
      '  150  ': 15000,
      'R 1 000 000,00': 100000000,
      '0,10': 10,
      '0': 0,
      '1500': 150000,
      // The full-stop decision: a full stop is a decimal separator too.
      '150.50': 15050,
      'R 1 500.50': 150050,
    };

    for (final MapEntry(key: input, value: cents) in accepted.entries) {
      test('"${input.replaceAll(' ', '·')}" as $cents cents', () {
        expect(parseRand(input), RandParsed(Cents(cents)));
      });
    }
  });

  group('parseRand refuses', () {
    final refused = <String, RandParseError>{
      '1,500.50': RandParseError.tooManyDecimals,
      '150,505': RandParseError.tooManyDecimals,
      '1.500': RandParseError.tooManyDecimals,
      '150.': RandParseError.missingDecimals,
      '150,': RandParseError.missingDecimals,
      '': RandParseError.empty,
      '   ': RandParseError.empty,
      'R': RandParseError.empty,
      'abc': RandParseError.invalidCharacters,
      '150abc': RandParseError.invalidCharacters,
      'R1 5O0': RandParseError.invalidCharacters,
      '-150': RandParseError.invalidCharacters,
      '150,50,10': RandParseError.invalidCharacters,
      '1.500,50': RandParseError.invalidCharacters,
      'ZAR 150': RandParseError.invalidCharacters,
      r'$150': RandParseError.invalidCharacters,
      '1 50': RandParseError.misplacedGroupSpace,
      '15 000 0': RandParseError.misplacedGroupSpace,
      '1  500': RandParseError.invalidCharacters,
      '12345678901': RandParseError.tooLarge,
    };

    for (final MapEntry(key: input, value: reason) in refused.entries) {
      test('"${input.replaceAll(' ', '·')}" because ${reason.name}', () {
        expect(parseRand(input), RandRefused(reason));
      });
    }
  });
}
