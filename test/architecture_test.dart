import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Imports a presentation file may never make: a repository's
/// implementation (anything under a `data/` folder), a fake, Dio or Drift.
final _forbidden = RegExp(
  r'''^import\s+['"]([^'"]*(/data/|fake_|package:dio/|package:drift/)[^'"]*)['"]''',
  multiLine: true,
);

void main() {
  test('no presentation file imports data/, a fake, Dio or Drift', () {
    final files = Directory('lib/features')
        .listSync(recursive: true)
        .whereType<File>()
        .where(
          (file) =>
              file.path.replaceAll(r'\', '/').contains('/presentation/') &&
              file.path.endsWith('.dart'),
        )
        .toList();

    expect(files, isNotEmpty);

    final offences = <String>[
      for (final file in files)
        for (final match in _forbidden.allMatches(file.readAsStringSync()))
          '${file.path}: ${match.group(1)}',
    ];
    expect(offences, isEmpty);
  });

  test('only app/providers.dart names a repository implementation', () {
    final namers = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .where((file) => !file.path.replaceAll(r'\', '/').contains('/data/'))
        .where(
          (file) =>
              RegExp(r'Fake(Home|Stokvel)Repository\(')
                  .hasMatch(file.readAsStringSync()),
        )
        .map((file) => file.path.replaceAll(r'\', '/'))
        .toList();

    expect(namers, ['lib/app/providers.dart']);
  });
}
