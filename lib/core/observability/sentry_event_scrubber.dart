import 'package:sentry_flutter/sentry_flutter.dart';

/// The signed-in member's name, supplied because it cannot be identified
/// safely with a pattern.
abstract final class SentryMemberIdentity {
  /// The current name, or `null` while signed out.
  static String? name;
}

/// Removes personal data from every structured string and request field
/// before a Sentry event can leave the phone.
SentryEvent scrubSentryEvent(SentryEvent event, {String? memberName}) {
  final member = memberName ?? event.user?.name;
  final payload =
      _scrubValue(event.toJson(), memberName: member)! as Map<String, dynamic>
        ..remove('user');

  final request = payload['request'];
  if (request is Map<String, dynamic>) {
    request.removeWhere(
      (key, _) => const {
        'cookies',
        'data',
        'env',
        'fragment',
        'headers',
        'query_string',
      }.contains(key),
    );
  }

  // The native Android SDK adds identifiers of the phone itself: a
  // persistent install id, the exact boot time and a hash of the device
  // id. Each links one phone's events together; none helps support, so
  // they never leave. The model, OS and app version stay: they reproduce
  // a failure without saying whose phone it was.
  final contexts = payload['contexts'];
  if (contexts is Map<String, dynamic>) {
    if (contexts['device'] case final Map<String, dynamic> device) {
      device
        ..remove('id')
        ..remove('boot_time');
    }
    if (contexts['app'] case final Map<String, dynamic> app) {
      app.remove('device_app_hash');
    }
  }

  return SentryEvent.fromJson(payload);
}

Object? _scrubValue(Object? value, {required String? memberName}) {
  if (value is String) return _scrubText(value, memberName: memberName);
  if (value is List) {
    return [
      for (final item in value) _scrubValue(item, memberName: memberName),
    ];
  }
  if (value is Map) {
    return <String, dynamic>{
      for (final MapEntry(:key, :value) in value.entries)
        if (key is String && !_privateField.hasMatch(key))
          key: key.toLowerCase() == 'url' && value is String
              ? _scrubUrl(value, memberName: memberName)
              : _scrubValue(value, memberName: memberName),
    };
  }
  return value;
}

String _scrubText(String value, {required String? memberName}) {
  var safe = value.replaceAll(_query, '');
  if (memberName case final name? when name.trim().isNotEmpty) {
    safe = safe.replaceAll(
      RegExp(RegExp.escape(name.trim()), caseSensitive: false),
      '[member]',
    );
  }
  return safe
      .replaceAll(_email, '[email]')
      .replaceAll(_currencyAmount, '[amount]')
      .replaceAll(_bearerToken, 'Bearer [token]')
      .replaceAll(_jwt, '[token]')
      .replaceAll(_proofFilename, '[file]');
}

String _scrubUrl(String value, {required String? memberName}) {
  final uri = Uri.tryParse(value);
  if (uri == null) return _scrubText(value, memberName: memberName);
  final path = uri.pathSegments
      .map(
        (segment) => _opaqueId.hasMatch(segment)
            ? ':id'
            : _scrubText(segment, memberName: memberName),
      )
      .join('/');
  return Uri(
    scheme: uri.scheme.isEmpty ? null : uri.scheme,
    host: uri.host.isEmpty ? null : uri.host,
    port: uri.hasPort ? uri.port : null,
    path: '${uri.path.startsWith('/') ? '/' : ''}$path',
  ).toString();
}

final _privateField = RegExp(
  '(?:member|user|email|phone|amount|token|password|proof|file|cookie|'
  'authorization|query|fragment|ip_address)',
  caseSensitive: false,
);
final _query = RegExp(r'[?&][^\s#]*');
final _email = RegExp(
  r'\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b',
  caseSensitive: false,
);
final _currencyAmount = RegExp(
  r'(?<![\w])R[\s\u00a0\u202f]*\d+(?:[\s\u00a0\u202f]\d{3})*(?:[,.]\d{2})?(?!\d)',
  caseSensitive: false,
);
final _bearerToken = RegExp(
  r'\bBearer\s+[A-Z0-9._~+/-]+=*',
  caseSensitive: false,
);
final _jwt = RegExp(
  r'\beyJ[A-Z0-9_-]+\.[A-Z0-9_-]+\.[A-Z0-9_-]+\b',
  caseSensitive: false,
);
final _proofFilename = RegExp(
  r'\b[\w.-]+(?:_[\w.-]+)*\.(?:pdf|jpe?g|png)\b',
  caseSensitive: false,
);
final _opaqueId = RegExp(
  r'^(?:[0-9a-f]{8}-[0-9a-f-]{27,}|[0-9]{2,})$',
  caseSensitive: false,
);
