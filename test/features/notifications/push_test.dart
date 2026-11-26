import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/notifications/data/device_registries.dart';
import 'package:ronditrack_app/features/notifications/domain/push.dart';

import '../../helpers/fake_push_client.dart';

const _stokvel = '5d0c9a4e-2b1f-4c8a-8e7d-3a6b9f2e0101';
const _cycle = '9e8f7a6b-5c4d-4e3f-8a2b-1c0d9e8f0201';

/// A registry that never answers, as an API with no signal.
class _Silent implements DeviceRegistry {
  final List<String> calls = [];

  @override
  Future<Result<void>> register(String id) {
    calls.add('register $id');
    return Completer<Result<void>>().future;
  }

  @override
  Future<Result<void>> forget(String id) {
    calls.add('forget $id');
    return Completer<Result<void>>().future;
  }
}

/// A registry whose every call fails.
class _Failing implements DeviceRegistry {
  @override
  Future<Result<void>> register(String id) async =>
      const Err(NoAnswerFailure());

  @override
  Future<Result<void>> forget(String id) async => const Err(NoAnswerFailure());
}

void main() {
  group('a push becomes an address, checked like a deep link', () {
    test('the one known type, with plain ids: that cycle', () {
      expect(
        pushToLocation({
          'type': 'contribution_update',
          'stokvelId': _stokvel,
          'cycleId': _cycle,
        }),
        '/stokvels/$_stokvel/cycles/$_cycle',
      );
    });

    for (final (name, data) in <(String, Map<String, Object?>)>[
      (
        'an unknown type',
        {'type': 'payout', 'stokvelId': _stokvel, 'cycleId': _cycle},
      ),
      ('no type', {'stokvelId': _stokvel, 'cycleId': _cycle}),
      ('no cycle', {'type': 'contribution_update', 'stokvelId': _stokvel}),
      (
        'an id with a path in it',
        {
          'type': 'contribution_update',
          'stokvelId': '../../me',
          'cycleId': _cycle,
        },
      ),
      (
        'an id with a query',
        {
          'type': 'contribution_update',
          'stokvelId': _stokvel,
          'cycleId': '$_cycle?x=1',
        },
      ),
      (
        'an address instead of an id',
        {
          'type': 'contribution_update',
          'stokvelId': 'https://evil.example',
          'cycleId': _cycle,
        },
      ),
      (
        'an empty id',
        {'type': 'contribution_update', 'stokvelId': '', 'cycleId': _cycle},
      ),
      (
        'a number, not text',
        {'type': 'contribution_update', 'stokvelId': 42, 'cycleId': _cycle},
      ),
      ('nothing at all', <String, Object?>{}),
    ]) {
      test('$name: goes nowhere', () => expect(pushToLocation(data), isNull));
    }
  });

  group('registration', () {
    test('signed in (by sign-in, a restored session or an offline launch '
        'alike): the phone is registered for them', () async {
      final devices = FakeDeviceRegistry();
      final push = PushRegistration(client: FakePushClient(), devices: devices);

      await push.signedIn();

      expect(devices.calls, ['register fid-1']);
      expect(push.installationId, 'fid-1');
    });

    test('a new id from onRegistered is sent again', () async {
      final devices = FakeDeviceRegistry();
      final client = FakePushClient();
      final push = PushRegistration(client: client, devices: devices);
      await push.signedIn();

      client.rotate('fid-2');
      await pumpEventQueue();

      expect(devices.calls, ['register fid-1', 'register fid-2']);
    });

    test('a new id while signed out is kept, not sent', () async {
      final devices = FakeDeviceRegistry();
      final client = FakePushClient();
      final push = PushRegistration(client: client, devices: devices);
      await push.signedIn();
      await push.signingOut();

      client.rotate('fid-2');
      await pumpEventQueue();

      expect(devices.calls, ['register fid-1', 'forget fid-1']);
    });

    test('sign-out tells the API to forget this phone', () async {
      final devices = FakeDeviceRegistry();
      final push = PushRegistration(client: FakePushClient(), devices: devices);
      await push.signedIn();

      await push.signingOut();

      expect(devices.calls.last, 'forget fid-1');
    });

    test(
      'push off (no Firebase file): nothing is registered or forgotten',
      () async {
        final devices = FakeDeviceRegistry();
        final push = PushRegistration(client: null, devices: devices);

        await push.signedIn();
        await push.signingOut();

        expect(devices.calls, isEmpty);
      },
    );

    test(
      'no signal: sign-out waits its timeout at most, then goes on',
      () async {
        final devices = _Silent();
        final push = PushRegistration(
          client: FakePushClient(),
          devices: devices,
          timeout: const Duration(milliseconds: 200),
        );
        await push.signedIn();

        final clock = Stopwatch()..start();
        await push.signingOut();

        expect(clock.elapsed, lessThan(const Duration(seconds: 2)));
        expect(devices.calls, ['register fid-1', 'forget fid-1']);
      },
    );

    test('each skipped step is reported to the debug log, and still never '
        'blocks', () async {
      final skipped = <Object>[];
      final client = FakePushClient()..failRegister = true;
      final push = PushRegistration(
        client: client,
        devices: _Failing(),
        onSkipped: skipped.add,
      );

      await push.signedIn();
      client.rotate('fid-2');
      await pumpEventQueue();

      expect(skipped, hasLength(2));
      expect(skipped.first, isA<StateError>(), reason: 'Firebase down');
      expect(skipped.last, isA<NoAnswerFailure>(), reason: 'the API refused');
    });

    test(
      'a Firebase failure, or an API that refuses, is skipped quietly',
      () async {
        final client = FakePushClient()..failRegister = true;
        final push = PushRegistration(client: client, devices: _Failing());

        await expectLater(push.signedIn(), completes);
        await expectLater(push.signingOut(), completes);
        expect(client.registers, 1);
      },
    );
  });
}
