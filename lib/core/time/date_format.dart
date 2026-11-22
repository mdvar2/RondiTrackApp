import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/core/time/sast.dart';

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// `30 Nov 2026`, with no-break spaces so it never splits.
String formatCalendarDate(CalendarDate date) =>
    '${date.day} ${_months[date.month - 1]} ${date.year}';

/// An instant shown as its South African calendar day, whatever zone the
/// phone is set to (11.3; it followed the phone's zone before).
String formatInstantAsSastDate(DateTime instant) =>
    formatCalendarDate(Sast.dayOf(instant));
