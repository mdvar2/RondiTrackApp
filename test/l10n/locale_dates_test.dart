import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/l10n/locale_dates.dart';

void main() {
  setUpAll(initializeDateFormatting);

  // Day, month, year in both languages: never the US order that `yMMMd`
  // gives plain `en` ("Nov 1, 2026"), which the phone showed.
  test('a day is day, month, year, with the locale month name', () {
    final first = CalendarDate(2026, 11, 1);
    expect(formatDay('en', first), '1 Nov 2026');
    expect(formatDay('af', first), matches(RegExp(r'^1 Nov\.? 2026$')));
    expect(formatDay('af', CalendarDate(2026, 3, 5)), startsWith('5 Mrt'));
  });
}
