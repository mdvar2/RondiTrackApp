import 'package:flutter/material.dart';

/// The statuses that have a colour of their own. Material's [ColorScheme]
/// has no "arrears" or "paid out", so they live in [StatusColors].
enum StatusToken {
  /// A cycle that is collecting.
  cycleOpen,

  /// A cycle that has closed.
  cycleClosed,

  /// A cycle whose payout is recorded.
  cyclePaidOut,

  /// A contribution recorded but not paid.
  contributionPending,

  /// A contribution the member has paid.
  contributionPaid,

  /// A contribution a treasurer has confirmed.
  contributionConfirmed,

  /// Money owed from an earlier cycle.
  arrears,

  /// A status or role this version of the app doesn't know.
  unknown,
}

/// A status's colours: text ([foreground]) on a chip ([background]).
@immutable
class StatusTone {
  /// Creates a tone.
  const new({required this.background, required this.foreground});

  /// Blends two tones, for theme animations.
  factory lerp(StatusTone a, StatusTone b, double t) => StatusTone(
    background: Color.lerp(a.background, b.background, t)!,
    foreground: Color.lerp(a.foreground, b.foreground, t)!,
  );

  /// The chip's fill.
  final Color background;

  /// The words on it.
  final Color foreground;
}

/// RondiTrack's status colours, a [ThemeExtension] with a light and a dark
/// set. Widgets ask for a [StatusToken] ("arrears"), never for a colour.
///
/// The dark set is chosen for dark surfaces (deep fills, light text), not
/// the light set inverted. Every pair is measured in
/// `test/core/theme/contrast_test.dart` and listed in README "Theme".
@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  /// Creates the extension from one tone per token.
  const new(this.tones);

  /// One tone per [StatusToken].
  final Map<StatusToken, StatusTone> tones;

  /// The tone for [token].
  StatusTone operator [](StatusToken token) => tones[token]!;

  /// The light theme's tones.
  static const light = StatusColors({
    StatusToken.cycleOpen: StatusTone(
      background: Color(0xFFD3E4FF),
      foreground: Color(0xFF001C38),
    ),
    StatusToken.cycleClosed: StatusTone(
      background: Color(0xFFE1E3E1),
      foreground: Color(0xFF2E3130),
    ),
    StatusToken.cyclePaidOut: StatusTone(
      background: Color(0xFFEADDFF),
      foreground: Color(0xFF21005D),
    ),
    StatusToken.contributionPending: StatusTone(
      background: Color(0xFFFFDEA8),
      foreground: Color(0xFF271900),
    ),
    StatusToken.contributionPaid: StatusTone(
      background: Color(0xFFC2E8FF),
      foreground: Color(0xFF001E2C),
    ),
    StatusToken.contributionConfirmed: StatusTone(
      background: Color(0xFFB4F1C0),
      foreground: Color(0xFF00210D),
    ),
    StatusToken.arrears: StatusTone(
      background: Color(0xFFFFDAD6),
      foreground: Color(0xFF410002),
    ),
    StatusToken.unknown: StatusTone(
      background: Color(0xFFE7E0EB),
      foreground: Color(0xFF1D1A22),
    ),
  });

  /// The dark theme's tones.
  static const dark = StatusColors({
    StatusToken.cycleOpen: StatusTone(
      background: Color(0xFF1F4876),
      foreground: Color(0xFFD3E4FF),
    ),
    StatusToken.cycleClosed: StatusTone(
      background: Color(0xFF444746),
      foreground: Color(0xFFE1E3E1),
    ),
    StatusToken.cyclePaidOut: StatusTone(
      background: Color(0xFF4F378B),
      foreground: Color(0xFFEADDFF),
    ),
    StatusToken.contributionPending: StatusTone(
      background: Color(0xFF5B4300),
      foreground: Color(0xFFFFDEA8),
    ),
    StatusToken.contributionPaid: StatusTone(
      background: Color(0xFF004C69),
      foreground: Color(0xFFC2E8FF),
    ),
    StatusToken.contributionConfirmed: StatusTone(
      background: Color(0xFF155234),
      foreground: Color(0xFFB4F1C0),
    ),
    StatusToken.arrears: StatusTone(
      background: Color(0xFF93000A),
      foreground: Color(0xFFFFDAD6),
    ),
    StatusToken.unknown: StatusTone(
      background: Color(0xFF4A4550),
      foreground: Color(0xFFE7E0EB),
    ),
  });

  /// The tones of the theme around [context]. Falls back to [light] or
  /// [dark] by brightness, for a theme built without the extension.
  static StatusColors of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<StatusColors>() ??
        (theme.brightness == Brightness.dark ? dark : light);
  }

  @override
  StatusColors copyWith({Map<StatusToken, StatusTone>? tones}) =>
      StatusColors(tones ?? this.tones);

  @override
  StatusColors lerp(StatusColors? other, double t) {
    if (other == null) return this;
    return StatusColors({
      for (final token in StatusToken.values)
        token: StatusTone.lerp(this[token], other[token], t),
    });
  }
}
