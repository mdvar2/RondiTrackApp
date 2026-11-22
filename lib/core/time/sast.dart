import 'package:ronditrack_app/core/time/calendar_date.dart';

/// South African Standard Time: UTC+2 all year. South Africa has had no
/// daylight saving since 1944, so the offset is a constant, and no time
/// zone database is needed.
///
/// Every calendar day the app shows or filters by is a South African day,
/// whatever zone the phone is set to: a member travelling with a phone set
/// to London still sees South African days (README "Money and dates").
abstract final class Sast {
  /// SAST's offset from UTC.
  static const offset = Duration(hours: 2);

  /// The South African calendar day [instant] falls on. 00:30 SAST on
  /// 1 November is 22:30 UTC on 31 October, and falls on 1 November.
  static CalendarDate dayOf(DateTime instant) {
    final sast = instant.toUtc().add(offset);
    return CalendarDate(sast.year, sast.month, sast.day);
  }

  /// The instant [day] starts in South Africa: 00:00 SAST, in UTC.
  static DateTime startOf(CalendarDate day) =>
      DateTime.utc(day.year, day.month, day.day).subtract(offset);

  /// The days [first] to [last] (inclusive, as a person picks them) as the
  /// API's half-open bounds: from 00:00 SAST on [first], up to but not
  /// including 00:00 SAST on the day after [last].
  static ({DateTime from, DateTime before}) bounds(
    CalendarDate first,
    CalendarDate last,
  ) => (
    from: startOf(first),
    before: startOf(last).add(const Duration(days: 1)),
  );

  /// Today in South Africa, at [now].
  static CalendarDate today(DateTime now) => dayOf(now);
}
