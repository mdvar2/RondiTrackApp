import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/theme/app_theme.dart';
import 'package:ronditrack_app/core/theme/status_colors.dart';

/// WCAG 2.2's contrast ratio: (L1 + 0.05) / (L2 + 0.05), where L is the
/// relative luminance ([Color.computeLuminance] implements WCAG's
/// definition) and L1 is the lighter colour.
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final (light, dark) = la > lb ? (la, lb) : (lb, la);
  return (light + 0.05) / (dark + 0.05);
}

String _hex(Color color) {
  final rgb = color.toARGB32() & 0xFFFFFF;
  return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

/// One measured pair: what it is, its colours, and the ratio it needs.
typedef _Pair = ({
  String token,
  Color foreground,
  Color background,
  double min,
});

List<_Pair> _pairs(ThemeData theme, StatusColors status) {
  final scheme = theme.colorScheme;
  return [
    for (final token in StatusToken.values)
      (
        token: token.name,
        foreground: status[token].foreground,
        background: status[token].background,
        min: 4.5,
      ),
    // The Material roles the screens put text and outlines on.
    (
      token: 'text (onSurface on surface)',
      foreground: scheme.onSurface,
      background: scheme.surface,
      min: 4.5,
    ),
    (
      token: 'secondary text (onSurfaceVariant on card)',
      foreground: scheme.onSurfaceVariant,
      background: scheme.surfaceContainerLow,
      min: 4.5,
    ),
    (
      token: 'link text (primary on card)',
      foreground: scheme.primary,
      background: scheme.surfaceContainerLow,
      min: 4.5,
    ),
    (
      token: 'selected list row (onSecondaryContainer)',
      foreground: scheme.onSecondaryContainer,
      background: scheme.secondaryContainer,
      min: 4.5,
    ),
    (
      token: 'control outline (outline on surface)',
      foreground: scheme.outline,
      background: scheme.surface,
      min: 3,
    ),
  ];
}

void main() {
  final themes = {
    'light': (AppTheme.light, StatusColors.light),
    'dark': (AppTheme.dark, StatusColors.dark),
  };

  for (final MapEntry(key: name, value: (theme, status)) in themes.entries) {
    group('$name theme', () {
      test('the theme carries its own status tones', () {
        expect(theme.extension<StatusColors>(), same(status));
      });

      for (final pair in _pairs(theme, status)) {
        test('${pair.token} meets ${pair.min}:1', () {
          expect(
            contrast(pair.foreground, pair.background),
            greaterThanOrEqualTo(pair.min),
          );
        });
      }
    });
  }

  test('the dark tones are not the light tones flipped', () {
    for (final token in StatusToken.values) {
      final light = StatusColors.light[token];
      final dark = StatusColors.dark[token];
      expect(dark.background, isNot(light.foreground), reason: token.name);
    }
  });

  // Prints README "Theme"'s table: `flutter test --plain-name "token table"`.
  test('token table', () {
    final lightPairs = _pairs(AppTheme.light, StatusColors.light);
    final darkPairs = _pairs(AppTheme.dark, StatusColors.dark);
    final rows = StringBuffer(
      '| Token | Needs | Light: text / fill | Light ratio '
      '| Dark: text / fill | Dark ratio |\n'
      '|---|---|---|---|---|---|\n',
    );
    for (var i = 0; i < lightPairs.length; i++) {
      final l = lightPairs[i];
      final d = darkPairs[i];
      rows.writeln(
        '| `${l.token}` | ${l.min}:1 '
        '| `${_hex(l.foreground)}` / `${_hex(l.background)}` '
        '| ${contrast(l.foreground, l.background).toStringAsFixed(2)}:1 '
        '| `${_hex(d.foreground)}` / `${_hex(d.background)}` '
        '| ${contrast(d.foreground, d.background).toStringAsFixed(2)}:1 |',
      );
    }
    // ignore: avoid_print, the table is the output.
    print(rows);
  });
}
