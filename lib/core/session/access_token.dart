import 'dart:convert';

import 'package:flutter/foundation.dart';

/// The access token and when it stops working. It lives in memory only:
/// never written to storage, never logged ([toString] leaves it out).
@immutable
class AccessToken {
  /// Creates the token.
  const new(this.value, {required this.expiresAt});

  /// The token from a sign-in or refresh answer. The body's `expiresAtUtc`
  /// says when it expires; the token's own `exp` claim is read too (not
  /// checked: only the API can check a token), and the earlier wins.
  factory fromResponse({
    required String accessToken,
    required DateTime expiresAtUtc,
  }) {
    final exp = unverifiedClaims(accessToken)['exp'];
    final claimed = exp is int
        ? DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true)
        : null;
    final body = expiresAtUtc.toUtc();
    return AccessToken(
      accessToken,
      expiresAt: claimed != null && claimed.isBefore(body) ? claimed : body,
    );
  }

  /// The token, from `AccessTokenResponse.accessToken`: the
  /// `Authorization: Bearer` value.
  final String value;

  /// When it expires, in UTC: the earlier of the response's `expiresAtUtc`
  /// and the token's own `exp` claim.
  final DateTime expiresAt;

  /// Whether it expires within [margin] of [now]: time to refresh before
  /// sending it.
  bool expiresWithin(Duration margin, DateTime now) =>
      !expiresAt.isAfter(now.toUtc().add(margin));

  @override
  bool operator ==(Object other) =>
      other is AccessToken &&
      other.value == value &&
      other.expiresAt == expiresAt;

  @override
  int get hashCode => Object.hash(value, expiresAt);

  @override
  String toString() => 'AccessToken(expiresAt: $expiresAt)';
}

/// The claims in a JWT's payload, read **without checking the signature**.
///
/// The app can't check it (the key is the API's), and doesn't need to: it
/// only reads what the token says about itself, and the API decides
/// whether to believe it. Empty when [token] isn't a JWT.
///
/// The API's token carries `sub` (the user's id), `jti`, `iat`, `nbf`,
/// `exp`, `iss` and `aud`, and no role: roles belong to each stokvel's
/// membership (README "Contract notes › Auth").
Map<String, Object?> unverifiedClaims(String token) {
  final parts = token.split('.');
  if (parts.length != 3) return const {};
  try {
    final bytes = base64Url.decode(base64Url.normalize(parts[1]));
    final payload = utf8.decode(bytes);
    final claims = jsonDecode(payload);
    return claims is Map<String, Object?> ? claims : const {};
  } on FormatException {
    return const {};
  }
}
