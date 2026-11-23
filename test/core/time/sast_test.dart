import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/money/rand_decimal.dart';
import 'package:ronditrack_app/core/money/rand_format.dart';
import 'package:ronditrack_app/core/money/rand_parser.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/core/time/date_format.dart';
import 'package:ronditrack_app/core/time/sast.dart';

// CI runs these under TZ=UTC and again under TZ=Africa/Johannesburg; they
// pass both times, because nothing here asks the phone for its zone.

void main() {
  final halfPastMidnight = DateTime.utc(2026, 10, 31, 22, 30);

  group("a calendar that isn't UTC", () {
    test('a contribution at 00:30 SAST on 1 November is on 1 November, '
        'though in UTC it is still 31 October', () {
      expect(halfPastMidnight.day, 31, reason: 'UTC');
      expect(Sast.dayOf(halfPastMidnight), CalendarDate(2026, 11, 1));
      expect(formatInstantAsSastDate(halfPastMidnight), '1 Nov 2026');
    });

    test("the phone's own zone changes nothing: the same instant, seen as "
        'local time, falls on the same South African day', () {
      expect(Sast.dayOf(halfPastMidnight.toLocal()), CalendarDate(2026, 11, 1));
    });

    test('"1 November" is half-open South African bounds: from 00:00 SAST '
        'on the 1st, up to but not including 00:00 SAST on the 2nd', () {
      final day = CalendarDate(2026, 11, 1);
      final bounds = Sast.bounds(day, day);

      expect(bounds.from, DateTime.utc(2026, 10, 31, 22));
      expect(bounds.before, DateTime.utc(2026, 11, 1, 22));
      expect(bounds.from.isUtc && bounds.before.isUtc, isTrue);
      // The 00:30 contribution is inside; 00:00 SAST on the 2nd is not.
      expect(!halfPastMidnight.isBefore(bounds.from), isTrue);
      expect(halfPastMidnight.isBefore(bounds.before), isTrue);
      expect(DateTime.utc(2026, 11, 1, 22).isBefore(bounds.before), isFalse);
      expect(
        DateTime.utc(2026, 10, 31, 21, 59).isBefore(bounds.from),
        isTrue,
        reason: '23:59 SAST on 31 October is the day before',
      );
    });

    test('a range of days runs to the end of the last one', () {
      final bounds = Sast.bounds(
        CalendarDate(2026, 11, 1),
        CalendarDate(2026, 11, 3),
      );
      expect(bounds.before, DateTime.utc(2026, 11, 3, 22));
    });

    test('the API receives the bounds as instants in UTC (Z)', () {
      final day = CalendarDate(2026, 11, 1);
      expect(Sast.startOf(day).toIso8601String(), '2026-10-31T22:00:00.000Z');
    });
  });

  group('rands to cents, and back', () {
    test("the pay form's prefilled amount parses back to the same cents", () {
      for (final cents in [50000, 125050, 75, 100000000]) {
        final typed = formatRand(Cents(cents)).replaceFirst('R ', '');
        expect(parseRand(typed), RandParsed(Cents(cents)), reason: typed);
      }
    });

    test('the API receives rands as exact decimal text, never a double', () {
      expect(randDecimalText(const Cents(50025)), '500.25');
      expect(randDecimalText(const Cents(50000)), '500.00');
      expect(randDecimalText(const Cents(7)), '0.07');
      expect(randDecimalText(const Cents(100000000)), '1000000.00');
      expect(() => randDecimalText(const Cents(-1)), throwsArgumentError);
    });
  });
}
