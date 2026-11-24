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
}
