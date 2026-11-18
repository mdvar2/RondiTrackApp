import 'package:retrofit/retrofit.dart';
import 'package:ronditrack_app/core/concurrency/concurrency_token.dart';
import 'package:ronditrack_app/core/data/to_failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';

/// Runs one repository call: its value, or the `Failure` that stopped it,
/// whatever was thrown (README "Failures").
Future<Result<T>> guard<T>(Future<T> Function() call) async {
  try {
    return Ok(await call());
  } on Object catch (error) {
    return Err(toFailure(error));
  }
}

/// The API's page end marker as one meaning: `null`, "no more pages".
///
/// This API ends a page list with `nextPageToken: ""` (README "Contract
/// notes", question 1). `null` and a missing token mean the same here, so
/// a change of spelling can never turn the last page into an endless one.
String? nextPageOf(String? token) =>
    token == null || token.isEmpty ? null : token;

/// One page: its items, and the token for the next, `null` at the end.
typedef Page<T> = ({List<T> items, String? next});

/// Every item, following each page's token until [nextPageOf] says there
/// are no more. A token is only ever sent back with the query that made
/// it (another filter is the API's `400`). [maxPages] guards against an
/// API that never ends.
Future<List<T>> allPages<T>(
  Future<Page<T>> Function(String? token) page, {
  int maxPages = 50,
}) async {
  final items = <T>[];
  String? token;
  for (var count = 0; count < maxPages; count++) {
    final next = await page(token);
    items.addAll(next.items);
    token = next.next;
    if (token == null) return items;
  }
  throw StateError('The API sent more than $maxPages pages.');
}

/// A date-only value (`format: date`, such as `2026-10-31`), a
/// Johannesburg calendar day. The generated model parses it with
/// `DateTime.parse`, which keeps the year, month and day as written, so
/// those are taken as they are, never shifted by a time zone.
CalendarDate calendarDateOf(DateTime date) =>
    CalendarDate(date.year, date.month, date.day);

/// An instant (`format: date-time`), kept in UTC.
DateTime instantOf(DateTime instant) => instant.toUtc();

/// The response's `ETag`, exactly as sent (quotes included), or `null`.
ConcurrencyToken? etagOf(HttpResponse<Object?> response) {
  final etag = response.response.headers.value('etag');
  return etag == null ? null : ConcurrencyToken(etag);
}
