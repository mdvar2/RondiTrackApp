import 'package:intl/intl.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';

/// [day] in [localeName]'s own words: "1 Nov 2026", "1 Nov. 2026". A
/// calendar day has no time and no zone, so it is formatted as itself.
String formatDay(String localeName, CalendarDate day) =>
    DateFormat.yMMMd(localeName).format(DateTime(day.year, day.month, day.day));
