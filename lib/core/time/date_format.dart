import 'package:ronditrack_app/core/time/calendar_date.dart';

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

/// An instant shown as the phone's local calendar day.
String formatInstantAsLocalDate(DateTime instant) {
  final local = instant.toLocal();
  return formatCalendarDate(CalendarDate(local.year, local.month, local.day));
}
