import 'package:dio/dio.dart';

/// An answer that should have set the refresh cookie and didn't. It holds
/// no header value, so it is safe to log.
class MissingRefreshCookie implements Exception {
  /// Creates the error.
  const new();

  @override
  String toString() => 'MissingRefreshCookie';
}

/// The value of the cookie called [name] among [headers]' `Set-Cookie`
/// lines, read by hand: the app isn't a browser and keeps no cookie jar.
///
/// Throws [MissingRefreshCookie] when no line sets it, or sets it empty
/// (the API's logout clears it that way).
///
/// `HttpOnly`, `Secure` and `SameSite` are instructions to a browser, and
/// protect nothing here: the app sends the value back only to the refresh
/// and logout endpoints itself.
String cookieFrom(Headers headers, String name) {
  for (final line in headers.map['set-cookie'] ?? const <String>[]) {
    final pair = line.split(';').first;
    final equals = pair.indexOf('=');
    if (equals <= 0) continue;
    if (pair.substring(0, equals).trim() != name) continue;
    final value = pair.substring(equals + 1).trim();
    if (value.isNotEmpty) return value;
  }
  throw const MissingRefreshCookie();
}
