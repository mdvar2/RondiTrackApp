import 'package:flutter/foundation.dart';

/// A calendar day with no time and no time zone, such as a cycle's due date.
///
/// The API sends due dates as OpenAPI `format: date` (`2026-10-31`), from a
/// C# `DateOnly` on Johannesburg calendar days. Turning one into a `DateTime`
/// would attach a time zone and could move it to the day before.
@immutable
final class CalendarDate implements Comparable<CalendarDate> {
  /// Creates a date. Throws [ArgumentError] for a day that does not exist.
  factory(int year, int month, int day) {
    final check = DateTime.utc(year, month, day);
    if (check.year != year || check.month != month || check.day != day) {
      throw ArgumentError('Not a calendar date: $year-$month-$day');
    }
    return CalendarDate._(year, month, day);
  }

  /// Parses the API's `yyyy-MM-dd` form, and nothing else.
  factory parse(String text) {
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(text);
    if (match == null) throw FormatException('Not a date-only value', text);
    return CalendarDate(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
    );
  }

  const new _(this.year, this.month, this.day);

  /// The year.
  final int year;

  /// The month, 1 to 12.
  final int month;

  /// The day of the month, 1 to 31.
  final int day;

  @override
  int compareTo(CalendarDate other) {
    if (year != other.year) return year.compareTo(other.year);
    if (month != other.month) return month.compareTo(other.month);
    return day.compareTo(other.day);
  }

  @override
  bool operator ==(Object other) =>
      other is CalendarDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  /// The API's `yyyy-MM-dd` form.
  @override
  String toString() =>
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';
}
