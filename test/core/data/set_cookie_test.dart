import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/data/set_cookie.dart';
import 'package:ronditrack_app/core/session/access_token.dart';

import '../../helpers/flavour_config.dart';

Headers _setCookie(List<String> lines) =>
    Headers.fromMap({'set-cookie': lines});

String _jwt(Map<String, Object?> claims) {
  String part(Map<String, Object?> json) =>
      base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
  return '${part({'alg': 'HS256'})}.${part(claims)}.signature-nobody-checked';
}

void main() {
  group('the refresh cookie, read by hand by its configured name', () {
    test('is found among several Set-Cookie lines', () {
      const attributes =
          'expires=Sun, 29 Nov 2026 16:34:49 GMT; path=/api/v1/auth; '
          'secure; samesite=strict; httponly';
      final headers = _setCookie([
        'theme=dark; path=/',
        '$refreshCookieName=the-refresh-token; $attributes',
        'x${refreshCookieName}y=not-this-one; path=/',
      ]);

      expect(cookieFrom(headers, refreshCookieName), 'the-refresh-token');
    });

    test('keeps a value with = in it (base64)', () {
      final headers = _setCookie(['$refreshCookieName=YWJj+/ZA==; path=/']);

      expect(cookieFrom(headers, refreshCookieName), 'YWJj+/ZA==');
    });

    test('a response without it is an error', () {
      expect(
        () => cookieFrom(_setCookie(['theme=dark']), refreshCookieName),
        throwsA(isA<MissingRefreshCookie>()),
      );
      expect(
        () => cookieFrom(Headers(), refreshCookieName),
        throwsA(isA<MissingRefreshCookie>()),
      );
    });

    test("logout's emptied cookie is not a token", () {
      final headers = _setCookie([
        '$refreshCookieName=; expires=Thu, 01 Jan 1970 00:00:00 GMT',
      ]);

      expect(
        () => cookieFrom(headers, refreshCookieName),
        throwsA(isA<MissingRefreshCookie>()),
      );
    });

    test('the name is never typed into code: only config/<flavour>.json '
        'has it', () {
      expect(refreshCookieName, isNotEmpty);
      final typedIn = [
        for (final file in Directory('lib').listSync(recursive: true))
          if (file is File &&
              file.path.endsWith('.dart') &&
              file.readAsStringSync().contains(refreshCookieName))
            file.path,
      ];
      expect(typedIn, isEmpty);
    });
  });

  group('claims are read from a token without checking it', () {
    test('a token with a signature nobody checked still gives its claims', () {
      final token = _jwt({'sub': 'user-1', 'exp': 1795365613});

      expect(unverifiedClaims(token), {'sub': 'user-1', 'exp': 1795365613});
    });

    test('something that is not a JWT has no claims', () {
      expect(unverifiedClaims('not-a-token'), isEmpty);
      expect(unverifiedClaims('a.!!!.c'), isEmpty);
    });

    test("the expiry is the earlier of the body's and the token's own", () {
      final exp = DateTime.utc(2026, 11, 22, 16, 39, 49);
      final token = _jwt({'exp': exp.millisecondsSinceEpoch ~/ 1000});

      final later = AccessToken.fromResponse(
        accessToken: token,
        expiresAtUtc: exp.add(const Duration(minutes: 1)),
      );
      final earlier = AccessToken.fromResponse(
        accessToken: token,
        expiresAtUtc: exp.subtract(const Duration(minutes: 1)),
      );

      expect(later.expiresAt, exp);
      expect(earlier.expiresAt, exp.subtract(const Duration(minutes: 1)));
    });

    test('an access token never prints itself', () {
      final token = AccessToken(
        _jwt({'sub': 'user-1'}),
        expiresAt: DateTime.utc(2026),
      );

      expect(token.toString(), isNot(contains(token.value)));
      expect(token.toString(), isNot(contains('eyJ')));
    });
  });
}
