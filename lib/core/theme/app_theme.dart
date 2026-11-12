import 'package:flutter/material.dart';
import 'package:ronditrack_app/core/theme/status_colors.dart';

/// RondiTrack's seed: a deep savings green. Material 3 derives every
/// colour role of both themes from it.
const ronditrackSeed = Color(0xFF0B6E4F);

/// The app's two themes. The app follows the phone's light or dark
/// setting (`ThemeMode.system`).
abstract final class AppTheme {
  /// The light theme.
  static final ThemeData light = _build(Brightness.light);

  /// The dark theme: Material 3's dark tonal palette from the same seed,
  /// with the dark status tones. Not the light theme inverted.
  static final ThemeData dark = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: ronditrackSeed,
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: scheme,
      extensions: [
        if (brightness == Brightness.dark)
          StatusColors.dark
        else
          StatusColors.light,
      ],
    );
  }
}
