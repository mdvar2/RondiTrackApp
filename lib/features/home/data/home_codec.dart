import 'dart:convert';

import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/features/home/domain/home_entry.dart';
import 'package:ronditrack_app/features/stokvels/domain/membership.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';

/// [T]'s enum value by its `name`, or [fallback] for one this version of
/// the app doesn't know (a cache written by a newer one).
T enumByName<T extends Enum>(List<T> values, Object? name, T fallback) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  return fallback;
}

/// An instant as text, in UTC.
String? instantToJson(DateTime? instant) => instant?.toUtc().toIso8601String();

/// An instant from [instantToJson].
DateTime? instantFromJson(Object? text) =>
    text is String ? DateTime.parse(text).toUtc() : null;

/// Home's entries to and from the text kept in `home_cache`. Amounts stay
/// whole cents; dates stay calendar dates.
abstract final class HomeCodec {
  /// Encodes [entries].
  static String encode(List<HomeEntry> entries) => jsonEncode([
    for (final e in entries)
      {
        'stokvelId': e.membership.stokvelId,
        'role': e.membership.role.name,
        'stokvelName': e.stokvelName,
        'cycle': switch (e.currentCycle) {
          null => null,
          final cycle => {
            'period': cycle.period,
            'status': cycle.status.name,
            'dueDate': cycle.dueDate?.toString(),
          },
        },
        'paid': e.amountPaid.value,
        'owed': e.amountOwed.value,
        'arrears': e.arrears.value,
        'nextPayout': instantToJson(e.nextPayoutDate),
      },
  ]);

  /// Decodes what [encode] wrote.
  static List<HomeEntry> decode(String text) => [
    for (final e in (jsonDecode(text) as List).cast<Map<String, Object?>>())
      HomeEntry(
        membership: Membership(
          stokvelId: e['stokvelId']! as String,
          role: enumByName(StokvelRole.values, e['role'], StokvelRole.unknown),
        ),
        stokvelName: e['stokvelName']! as String,
        currentCycle: switch (e['cycle']) {
          final Map<String, Object?> cycle => HomeCycle(
            period: cycle['period']! as String,
            status: enumByName(
              CycleStatus.values,
              cycle['status'],
              CycleStatus.unknown,
            ),
            dueDate: switch (cycle['dueDate']) {
              final String date => CalendarDate.parse(date),
              _ => null,
            },
          ),
          _ => null,
        },
        amountPaid: Cents(e['paid']! as int),
        amountOwed: Cents(e['owed']! as int),
        arrears: Cents(e['arrears']! as int),
        nextPayoutDate: instantFromJson(e['nextPayout']),
      ),
  ];
}
