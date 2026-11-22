import 'package:ronditrack_app/core/money/cents.dart';

/// [amount] as the decimal number of rands the API's write bodies take
/// (`contributionAmount`, `targetAmount`: a JSON number in rands, not
/// cents), written as exact text: 50025 cents is `500.25`. It goes into the
/// JSON as written, so no `double` ever carries an amount.
String randDecimalText(Cents amount) {
  if (amount.value < 0) {
    throw ArgumentError.value(amount.value, 'amount', 'cannot be negative');
  }
  final cents = (amount.value % 100).toString().padLeft(2, '0');
  return '${amount.value ~/ 100}.$cents';
}
