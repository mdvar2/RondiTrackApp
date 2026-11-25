import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/config/app_config.dart';
import 'package:ronditrack_app/core/config/firebase_config.dart';

const _keys = [
  'FIREBASE_API_KEY',
  'FIREBASE_APP_ID',
  'FIREBASE_MESSAGING_SENDER_ID',
  'FIREBASE_PROJECT_ID',
];

void main() {
  FirebaseConfig? read({
    String apiKey = 'AIza-test',
    String appId = '1:123:android:abc',
    String sender = '123',
    String project = 'ronditrack-dev',
  }) => FirebaseConfig.fromValues(
    apiKey: apiKey,
    appId: appId,
    messagingSenderId: sender,
    projectId: project,
  );

  test('no file, no values: push is off, and the app starts as before', () {
    expect(read(apiKey: '', appId: '', sender: '', project: ''), isNull);
  });

  test('all four: push is on, with each value', () {
    final config = read()!;
    expect(config.apiKey, 'AIza-test');
    expect(config.appId, '1:123:android:abc');
    expect(config.messagingSenderId, '123');
    expect(config.projectId, 'ronditrack-dev');
  });

  test('some but not all: refuses to start, naming what is missing', () {
    expect(
      () => read(appId: '', project: '  '),
      throwsA(
        isA<AppConfigException>().having(
          (e) => e.message,
          'message',
          allOf(
            contains('FIREBASE_APP_ID'),
            contains('FIREBASE_PROJECT_ID'),
            isNot(contains('FIREBASE_API_KEY')),
          ),
        ),
      ),
    );
  });

  test('the committed example file has the four keys, and no values', () {
    final example = (jsonDecode(
      File('config/firebase.example.json').readAsStringSync(),
    ) as Map).cast<String, String>();

    expect(example.keys, unorderedEquals(_keys));
    expect(example.values, everyElement(isEmpty));
    expect(
      FirebaseConfig.fromValues(
        apiKey: example['FIREBASE_API_KEY']!,
        appId: example['FIREBASE_APP_ID']!,
        messagingSenderId: example['FIREBASE_MESSAGING_SENDER_ID']!,
        projectId: example['FIREBASE_PROJECT_ID']!,
      ),
      isNull,
    );
  });

  test("no flavour's real file is in the repository", () {
    for (final flavour in ['dev', 'staging', 'prod']) {
      final tracked = Process.runSync('git', [
        'ls-files',
        '--error-unmatch',
        'config/firebase.$flavour.json',
      ]);
      expect(tracked.exitCode, isNot(0), reason: flavour);
    }
  });
}
