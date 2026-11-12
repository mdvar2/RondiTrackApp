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

  group('Assignment 10.2', () {
    test('no Navigator.push or hand-built page route anywhere in lib', () {
      final offences = _matches(
        _dartFiles('lib'),
        RegExp(
          r'Navigator\s*\.\s*(of\([^)]*\)\s*\.\s*)?push|MaterialPageRoute',
        ),
      );
      expect(offences, isEmpty);
    });

    test('no string path in a widget: screens navigate with typed routes', () {
      final offences = _matches(
        _widgetFiles(),
        RegExp(
          r'''(context\s*\.\s*(go|push|pushReplacement|replace)\s*\()'''
          r'''|GoRouter\s*\.\s*of\s*\('''
          r'''|\.(go|push)\(\s*['"]/''',
        ),
      );
      expect(offences, isEmpty);
    });

    test('no colour typed into a widget: only the theme names colours', () {
      final offences = _matches(
        _widgetFiles(),
        RegExp(r'Color\(\s*0x|Colors\.|Color\.from(ARGB|RGBO)'),
      );
      expect(offences, isEmpty);
    });
  });
}

List<File> _dartFiles(String root) =>
    Directory(root)
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .where((file) => !RegExp(r'\.(g|freezed)\.dart$').hasMatch(file.path))
        .toList();

/// Every file that builds widgets: the features' presentation folders and
/// the app's router and shell.
List<File> _widgetFiles() {
  final files = [
    ..._dartFiles('lib/features').where(
      (file) => file.path.replaceAll(r'\', '/').contains('/presentation/'),
    ),
    ..._dartFiles('lib/app'),
  ];
  expect(files, isNotEmpty);
  return files;
}

List<String> _matches(List<File> files, RegExp pattern) => [
  for (final file in files)
    for (final (index, line) in file.readAsLinesSync().indexed)
      if (pattern.hasMatch(line) && !line.trimLeft().startsWith('//'))
        '${file.path}:${index + 1}: ${line.trim()}',
];
