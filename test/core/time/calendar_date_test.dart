import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/core/time/date_format.dart';

void main() {
  group('CalendarDate', () {
    test("parses the API's date-only form", () {
      expect(CalendarDate.parse('2026-10-31'), CalendarDate(2026, 10, 31));
      expect(CalendarDate.parse('2026-10-31').toString(), '2026-10-31');
    });

    test('refuses an instant, a partial date and a missing day', () {
      for (final text in ['2026-10-31T00:00:00Z', '2026-10', '31/10/2026']) {
        expect(() => CalendarDate.parse(text), throwsFormatException);
      }
      expect(() => CalendarDate.parse('2026-02-30'), throwsArgumentError);
    });

    test('orders by day', () {
      expect(
        CalendarDate(2026, 11, 30).compareTo(CalendarDate(2026, 12, 1)),
        isNegative,
      );
    });

    test('formats with no-break spaces', () {
      expect(formatCalendarDate(CalendarDate(2026, 11, 30)), '30 Nov 2026');
    });
  });
}
