import 'package:intl/intl.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/core/time/date_format.dart';

/// [day] in [localeName]'s own words: "1 Nov 2026", "1 Nov. 2026". A
/// calendar day has no time and no zone, so it is formatted as itself.
///
/// Day, month, year, as South Africa writes it and as the rest of the app
/// does ([formatCalendarDate]); the month's name is the locale's. Not
/// `yMMMd`: for plain `en` that is the US order, "Nov 1, 2026" (seen on the
/// phone).
String formatDay(String localeName, CalendarDate day) => DateFormat(
  'd MMM y',
  localeName,
).format(DateTime(day.year, day.month, day.day));
