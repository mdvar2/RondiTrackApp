import 'package:ronditrack_app/core/money/cents.dart';

/// The no-break space (U+00A0) used between `R`, the digit groups and the
/// amount, so an amount never splits across two lines.
const nbsp = ' ';

/// Formats [amount] the en-ZA way, using integer arithmetic only.
///
/// `Cents(10)` is `R 0,10`, `Cents(150000)` is `R 1 500,00`, and
/// `Cents(-15050)` is `-R 150,50`. Every space is a no-break space.
String formatRand(Cents amount) {
  final value = amount.value;
  final negative = value < 0;

  // Work on the magnitude as rands and cents. `~/` and `%` keep this in
  // integers; the sign is added back at the end.
  final magnitude = negative ? -value : value;
  final rands = magnitude ~/ 100;
  final cents = magnitude % 100;

  final digits = rands.toString();
  final groups = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final fromEnd = digits.length - i;
    if (i > 0 && fromEnd % 3 == 0) {
      groups.write(nbsp);
    }
    groups.write(digits[i]);
  }

  final sign = negative ? '-' : '';
  final centDigits = cents.toString().padLeft(2, '0');
  return '${sign}R$nbsp$groups,$centDigits';
}
