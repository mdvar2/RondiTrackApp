import 'package:flutter/foundation.dart';
import 'package:ronditrack_app/core/money/cents.dart';

/// Why a typed amount was refused.
enum RandParseError {
  /// Nothing was typed.
  empty,

  /// Something other than digits, one separator, digit-group spaces and an
  /// optional leading `R` was typed (letters, a minus sign, two separators).
  invalidCharacters,

  /// A digit-group space was in the wrong place (`1 50`, `15 000 0`).
  misplacedGroupSpace,

  /// A separator was typed with no digits after it (`150.`, `150,`).
  missingDecimals,

  /// More than two digits after the decimal separator (`150,505`, and so
  /// `1,500.50` or `1.500`, where the separator is a thousands mark).
  tooManyDecimals,

  /// More rands than the app accepts in one payment.
  tooLarge,
}

/// The outcome of [parseRand]: cents, or the reason it was refused.
@immutable
sealed class RandParseResult {
  const new();
}

/// A typed amount that parsed.
@immutable
final class RandParsed extends RandParseResult {
  /// Creates a parsed result.
  const new(this.cents);

  /// The amount typed.
  final Cents cents;

  @override
  bool operator ==(Object other) => other is RandParsed && other.cents == cents;

  @override
  int get hashCode => cents.hashCode;

  @override
  String toString() => 'RandParsed(${cents.value})';
}

/// A typed amount that was refused.
@immutable
final class RandRefused extends RandParseResult {
  /// Creates a refused result.
  const new(this.reason);

  /// Why it was refused.
  final RandParseError reason;

  @override
  bool operator ==(Object other) =>
      other is RandRefused && other.reason == reason;

  @override
  int get hashCode => reason.hashCode;

  @override
  String toString() => 'RandRefused($reason)';
}

/// The most rand digits accepted (R 9 999 999 999), well inside `int`.
const _maxRandDigits = 10;

/// Rands, optionally grouped in threes by single spaces (ordinary or
/// no-break), optionally followed by one separator and one or more digits.
final _shape = RegExp(r'^(\d+(?:[  ]\d+)*)(?:([,.])(\d*))?$');
final _grouped = RegExp(r'^\d{1,3}(?:[  ]\d{3})*$');

/// Parses rands typed into the pay form, using integer arithmetic only.
///
/// Accepts `150`, `150,50`, `R150`, `R 1 500`, `1 500,50` (ordinary or
/// no-break spaces) and, for keyboards without a comma, `150.50`.
/// Refuses `1,500.50`, `150,505`, `150.`, an empty string and letters.
/// See README "Money" for the rules.
RandParseResult parseRand(String input) {
  var text = input.trim();
  if (text.isEmpty) return const RandRefused(RandParseError.empty);

  if (text.startsWith('R')) {
    text = text.substring(1).trimLeft();
    if (text.isEmpty) return const RandRefused(RandParseError.empty);
  }

  final match = _shape.firstMatch(text);
  if (match == null) {
    // Two separators (`1,500.50`) or any letter or sign end up here. When the
    // only problem is a comma used as a thousands mark, say so.
    if (RegExp(r'^[\d  ]+,\d{3}').hasMatch(text)) {
      return const RandRefused(RandParseError.tooManyDecimals);
    }
    return const RandRefused(RandParseError.invalidCharacters);
  }

  final randPart = match.group(1)!;
  final separator = match.group(2);
  final decimals = match.group(3) ?? '';

  if (!_grouped.hasMatch(randPart) && randPart.contains(RegExp('[  ]'))) {
    return const RandRefused(RandParseError.misplacedGroupSpace);
  }

  if (separator != null && decimals.isEmpty) {
    return const RandRefused(RandParseError.missingDecimals);
  }
  if (decimals.length > 2) {
    return const RandRefused(RandParseError.tooManyDecimals);
  }

  final randDigits = randPart.replaceAll(RegExp('[  ]'), '');
  final significant = randDigits.replaceFirst(RegExp('^0+(?=.)'), '');
  if (significant.length > _maxRandDigits) {
    return const RandRefused(RandParseError.tooLarge);
  }

  final rands = int.parse(significant);
  final cents = decimals.isEmpty ? 0 : int.parse(decimals.padRight(2, '0'));
  return RandParsed(Cents(rands * 100 + cents));
}
