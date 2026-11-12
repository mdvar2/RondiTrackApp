import 'package:flutter/material.dart';
import 'package:ronditrack_app/core/theme/status_colors.dart';

/// A status in words, on its token's colour. The words always say what the
/// status means; the colour only helps.
class StatusChip extends StatelessWidget {
  /// Creates a chip saying [label], coloured as [token].
  const new({required this.label, required this.token, super.key});

  /// What the status means, in words.
  final String label;

  /// Which status colour to use.
  final StatusToken token;

  @override
  Widget build(BuildContext context) {
    final tone = StatusColors.of(context)[token];
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge
              ?.copyWith(color: tone.foreground),
        ),
      ),
    );
  }
}
