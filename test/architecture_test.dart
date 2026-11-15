import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// The architecture, as CI checks. Each rule is one test, run over every
// hand-written Dart file it covers. A rule may have exceptions, but each
// one is written down here with its reason and the week it ends; an
// exception that no longer matches anything fails too, so the list can't
// go stale. README "Architecture rules" lists the same.

/// One allowed break of one rule.
typedef _Allowed = ({String rule, String file, String reason, String ends});

const _colour = 'no colour typed outside the theme';
const _screenImports = 'no screen imports data/, a fake, Dio or Drift';
const _compositionRoot = 'no screen imports the composition root';
const _implementations = 'only app/providers.dart names a repository';
const _navigatorPush = 'no Navigator.push or hand-built page route';
const _stringPaths = 'no string path in a widget';

const List<_Allowed> _allowed = [
  (
    rule: _compositionRoot,
    file: 'lib/features/stokvels/presentation/stokvel_detail_screen.dart',
    reason:
        'Reads signedInUserIdProvider (whose contribution is mine, for the '
        'actions match). It lives in the composition root until the session '
        'has a home of its own.',
    ends: 'Week 11',
  ),
  (
    rule: _compositionRoot,
    file: 'lib/features/payouts/presentation/payouts_screen.dart',
    reason:
        'Reads signedInUserIdProvider for the actions match, as the stokvel '
        'screen does.',
    ends: 'Week 11',
  ),
  (
    rule: _compositionRoot,
    file: 'lib/features/auth/presentation/sign_in_screen.dart',
    reason:
        "Reads demoAccountsProvider, the dev build's test accounts, which "
        "name the fakes' personas.",
    ends: 'Week 11',
  ),
];

/// A file the rules look at: a `.dart` file, `/` separated, not generated.
List<String> _dartFiles(String root) => [
  for (final file in Directory(root).listSync(recursive: true))
    if (file is File &&
        file.path.endsWith('.dart') &&
        !RegExp(r'\.(g|freezed)\.dart$').hasMatch(file.path))
      file.path.replaceAll(r'\', '/'),
];

bool _isPresentation(String path) => path.contains('/presentation/');

/// A screen or widget: a presentation file that builds widgets.
bool _isScreen(String path) =>
    _isPresentation(path) &&
    RegExp(
      r'''^import\s+['"]package:flutter/(material|widgets)\.dart['"]''',
      multiLine: true,
    ).hasMatch(File(path).readAsStringSync());

/// Every file that builds widgets: the features' screens and the app's
/// router, shell and dev tools.
List<String> _widgetFiles() => [
  ..._dartFiles('lib/features').where(_isPresentation),
  ..._dartFiles('lib/app'),
];

/// The lines of [files] that match [pattern], as `file:line: text`, leaving
/// out comments and anything [_allowed] for [rule].
List<String> _offences(String rule, List<String> files, RegExp pattern) => [
  for (final file in files)
    if (!_allowed.any((a) => a.rule == rule && a.file == file))
      for (final (index, line) in File(file).readAsLinesSync().indexed)
        if (pattern.hasMatch(line) && !line.trimLeft().startsWith('//'))
          '$file:${index + 1}: ${line.trim()}',
];

final _importOf = RegExp(r'''^import\s+['"]([^'"]+)['"]''');

/// What each rule matches, so the exceptions can be checked against it.
final Map<String, (List<String> Function(), RegExp)> _rules = {
  _colour: (
    () => [..._dartFiles('lib/features'), ..._dartFiles('lib/app')],
    RegExp(r'Color\(\s*0x|Colors\.|Color\.from(ARGB|RGBO)'),
  ),
  _screenImports: (
    () => _dartFiles('lib/features').where(_isPresentation).toList(),
    RegExp(
      r'''^import\s+['"][^'"]*(/data/|fake_|package:dio/|package:drift/)''',
    ),
  ),
  _compositionRoot: (
    () => _dartFiles('lib/features').where(_isScreen).toList(),
    RegExp(r'''^import\s+['"]package:ronditrack_app/app/providers\.dart['"]'''),
  ),
  _implementations: (
    () => [
      for (final file in _dartFiles('lib'))
        if (!file.contains('/data/') && file != 'lib/app/providers.dart') file,
    ],
    RegExp(r'\b(Fake|Flaky)\w*Repository\('),
  ),
  _navigatorPush: (
    () => _dartFiles('lib'),
    RegExp(r'Navigator\s*\.\s*(of\([^)]*\)\s*\.\s*)?push|MaterialPageRoute'),
  ),
  _stringPaths: (
    _widgetFiles,
    RegExp(
      r'''(context\s*\.\s*(go|push|pushReplacement|replace)\s*\()'''
      r'''|GoRouter\s*\.\s*of\s*\('''
      r'''|\.(go|push)\(\s*['"]/''',
    ),
  ),
};

void main() {
  for (final MapEntry(key: rule, value: (files, pattern)) in _rules.entries) {
    test(rule, () {
      final covered = files();
      expect(covered, isNotEmpty, reason: 'the rule must look at something');
      expect(_offences(rule, covered, pattern), isEmpty);
    });
  }

  group('the rules really look', () {
    test('a screen is found by what it imports', () {
      expect(
        _isScreen('lib/features/payouts/presentation/payouts_screen.dart'),
        isTrue,
      );
      expect(
        _isScreen(
          'lib/features/payouts/presentation/payout_order_provider.dart',
        ),
        isFalse,
      );
    });

    test('the import rules match the imports they forbid', () {
      final (_, screenImports) = _rules[_screenImports]!;
      for (final line in [
        "import 'package:ronditrack_app/features/x/data/fake_x.dart';",
        "import 'package:dio/dio.dart';",
        "import 'package:drift/drift.dart';",
      ]) {
        expect(screenImports.hasMatch(line), isTrue, reason: line);
        expect(_importOf.hasMatch(line), isTrue);
      }
      final (_, colour) = _rules[_colour]!;
      expect(colour.hasMatch('color: Colors.red,'), isTrue);
      expect(colour.hasMatch('color: Color(0xFF00FF00),'), isTrue);
      expect(colour.hasMatch('Color.fromARGB(255, 0, 0, 0)'), isTrue);
    });
  });

  group('every exception', () {
    for (final allowed in _allowed) {
      test('${allowed.file} ("${allowed.rule}")', () {
        expect(_rules, contains(allowed.rule));
        expect(allowed.reason.trim(), isNotEmpty, reason: 'needs a reason');
        expect(
          allowed.ends,
          matches(RegExp(r'^Week \d+$')),
          reason: 'needs the week it ends',
        );
        // Still needed: the file exists and still breaks the rule.
        final (files, pattern) = _rules[allowed.rule]!;
        expect(files(), contains(allowed.file), reason: 'not covered');
        expect(
          File(allowed.file).readAsLinesSync().any(pattern.hasMatch),
          isTrue,
          reason: 'no longer breaks the rule: delete the exception',
        );
      });
    }
  });
}
