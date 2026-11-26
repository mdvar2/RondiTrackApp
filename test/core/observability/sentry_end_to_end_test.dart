import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/observability/sentry_event_scrubber.dart';
import 'package:ronditrack_app/core/observability/sentry_failure_reporter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// A transport that keeps each envelope instead of sending it: what is in
/// [events] is exactly what would have left the phone.
class _KeepingTransport implements Transport {
  final List<Map<String, dynamic>> events = [];

  @override
  Future<SentryId?> send(SentryEnvelope envelope) async {
    for (final item in envelope.items) {
      if (item.header.type != 'event') continue;
      final bytes = await item.dataFactory();
      events.add(jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>);
    }
    return SentryId.newId();
  }
}

const _name = 'Thandi Nkosi';
const _email = 'thandi.nkosi@example.test';
const _installId = '9487fe089fb745a28862b5c646c4f53a';

/// The real Sentry SDK, with the app's own options, scrubber and reporter,
/// and no account: README "Privacy".
void main() {
  late _KeepingTransport transport;

  setUp(() async {
    transport = _KeepingTransport();
    await Sentry.init((options) {
      options
        // Never reached: the transport below keeps everything.
        ..dsn = 'https://public@sentry.invalid/1'
        ..transport = transport
        ..environment = 'dev'
        ..sendDefaultPii = false
        ..beforeSend = (event, _) => scrubSentryEvent(event, memberName: _name);
    });
    // What else could be on the scope when a failure is reported.
    await Sentry.configureScope(
      (scope) =>
          scope.setUser(SentryUser(id: 'u-1', name: _name, email: _email)),
    );
    // As the native Android SDK's contexts are merged in: the phone's
    // install id and boot time.
    await Sentry.configureScope(
      (scope) => scope.setContexts(
        SentryDevice.type,
        // From JSON, as the native merge builds it: `id` is not a field
        // of the Dart class, and is kept as an unknown key.
        SentryDevice.fromJson({
          'id': _installId,
          'model': 'MAO-LX9',
          'boot_time': '2026-11-25T21:04:13.000Z',
        }),
      ),
    );
    await Sentry.addBreadcrumb(
      Breadcrumb(
        message: 'GET /api/v1/stokvels/s-1/contributions?q=Nkosi',
        data: {'url': 'https://api.example.test/contributions?q=Nkosi'},
      ),
    );
  });

  tearDown(Sentry.close);

  test('a server failure leaves as one event with its correlation id tag, '
      'its environment, and nothing personal', () async {
    await const SentryFailureReporter().report(
      const ServerFailure(correlationId: '0HN8B6TQ1QK3G:00000001'),
    );

    expect(transport.events, hasLength(1));
    final event = transport.events.single;
    expect((event['tags'] as Map)['correlationId'], '0HN8B6TQ1QK3G:00000001');
    expect(event['environment'], 'dev');
    expect(event.containsKey('user'), isFalse);

    final outgoing = jsonEncode(event);
    final device = (event['contexts'] as Map)['device'] as Map;
    expect(device['model'], 'MAO-LX9', reason: 'what support needs stays');
    expect(device.containsKey('boot_time'), isFalse);
    for (final personal in [_name, 'Nkosi', _email, 'q=', _installId]) {
      expect(outgoing, isNot(contains(personal)), reason: personal);
    }
  });

  test('a failure the app expects (no signal, a rule) sends nothing', () async {
    const reporter = SentryFailureReporter();
    await reporter.report(const NoAnswerFailure());
    await reporter.report(const RuleFailure(detail: 'Already paid.'));

    expect(transport.events, isEmpty);
  });
}
