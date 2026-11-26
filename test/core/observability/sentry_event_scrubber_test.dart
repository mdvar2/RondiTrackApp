import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/observability/sentry_event_scrubber.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

const _memberName = 'Thandi Nkosi';
const _email = 'thandi.nkosi@example.test';
const _amount = 'R\u00a01\u00a0250,50';
const _token = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjMifQ.signature';
const _proof = 'Thandi_proof_Nov.jpg';
const _correlationId = 'c0ffee00c0ffee00c0ffee00c0ffee00';

void main() {
  test('scrubs personal fields throughout a realistic event and keeps the '
      'API correlation id', () {
    final event = SentryEvent(
      message: SentryMessage(
        'Payment for $_memberName: $_amount ($_email), token $_token, $_proof',
      ),
      exceptions: [
        SentryException(
          type: 'Exception',
          value:
              'Could not save $_memberName, $_email, $_amount, '
              '$_token, $_proof',
        ),
      ],
      breadcrumbs: [
        Breadcrumb(
          message: 'GET /contributions?q=Nkosi',
          data: {
            'url':
                'https://api.example.test/contributions?q=Nkosi&token=$_token',
            'memberName': _memberName,
            'amount': _amount,
            'proof': _proof,
          },
        ),
      ],
      tags: {
        'member': _memberName,
        'email': _email,
        'amount': _amount,
        'token': _token,
        'proof': _proof,
        'correlationId': _correlationId,
      },
      user: SentryUser(
        id: '9f21773e-18af-5531-2414-8fb4140b5bc4',
        name: _memberName,
        email: _email,
      ),
      request: SentryRequest(
        url:
            'https://api.example.test/contributions/'
            '9f21773e-18af-5531-2414-8fb4140b5bc4?q=Nkosi',
        queryString: 'q=Nkosi',
        data: {'name': _memberName, 'amount': _amount, 'proof': _proof},
        headers: {'Authorization': 'Bearer $_token'},
      ),
    );

    final outgoing = jsonEncode(
      scrubSentryEvent(event, memberName: _memberName).toJson(),
    );

    for (final personal in [
      _memberName,
      _email,
      _amount,
      _token,
      _proof,
      '9f21773e-18af-5531-2414-8fb4140b5bc4',
      'q=Nkosi',
      'Authorization',
    ]) {
      expect(outgoing, isNot(contains(personal)), reason: personal);
    }
    expect(outgoing, contains(_correlationId));
  });

  // What the native Android SDK added to a real event (shape captured from the
  // MAO-LX9 on 2026-11-26): a persistent install id, the boot time and,
  // on some versions, a hash of the device id. Each links one phone's
  // events together, and none helps support.
  test('drops the device identifiers the native SDK adds, and keeps what '
      'support needs', () {
    const installId = '00000000feedbeef0000000000000001';
    const bootTime = '2026-11-25T21:04:13.000Z';
    final event = SentryEvent(
      tags: {'correlationId': _correlationId},
      contexts: Contexts.fromJson({
        'device': {
          'id': installId,
          'boot_time': bootTime,
          'model': 'MAO-LX9',
          'manufacturer': 'HUAWEI',
          'timezone': 'Africa/Johannesburg',
        },
        'app': {
          'device_app_hash': 'a1b2c3d4e5f6',
          'app_identifier': 'za.co.gwinya.ronditrack_app.dev',
          'app_version': '1.0.0',
        },
        'os': {'name': 'Android', 'version': '12'},
      }),
    );

    final outgoing = scrubSentryEvent(event).toJson();
    final text = jsonEncode(outgoing);
    final contexts = outgoing['contexts'] as Map<String, dynamic>;
    final device = contexts['device'] as Map<String, dynamic>;
    final app = contexts['app'] as Map<String, dynamic>;

    for (final identifier in [installId, bootTime, 'a1b2c3d4e5f6']) {
      expect(text, isNot(contains(identifier)), reason: identifier);
    }
    expect(device.containsKey('id'), isFalse, reason: 'device.id');
    expect(device.containsKey('boot_time'), isFalse, reason: 'boot_time');
    expect(app.containsKey('device_app_hash'), isFalse, reason: 'app hash');
    // Kept: what a developer needs to reproduce a failure.
    expect(device['model'], 'MAO-LX9');
    expect(app['app_version'], '1.0.0');
    expect((contexts['os'] as Map)['version'], '12');
    expect((outgoing['tags'] as Map)['correlationId'], _correlationId);
  });
}
