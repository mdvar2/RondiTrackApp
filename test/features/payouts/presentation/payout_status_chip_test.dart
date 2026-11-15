import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/theme/app_theme.dart';
import 'package:ronditrack_app/core/theme/status_colors.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_status.dart';
import 'package:ronditrack_app/features/payouts/presentation/payout_status_chip.dart';

/// The chip's text and fill, pumped with the app's own [theme]: a chip
/// built on a bare MaterialApp would fall back, and prove nothing.
Future<(Color text, Color fill)> _pumpChip(
  WidgetTester tester,
  PayoutStatus status,
  ThemeData theme,
) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      home: Scaffold(body: Center(child: PayoutStatusChip(status))),
    ),
  );
  final text = tester.widget<Text>(find.text(payoutStatusLabel(status)));
  final box = tester.widget<DecoratedBox>(
    find.descendant(
      of: find.byType(PayoutStatusChip),
      matching: find.byType(DecoratedBox),
    ),
  );
  return (text.style!.color!, (box.decoration as BoxDecoration).color!);
}

void main() {
  test('each status has its own token; unknown shares the app-wide one', () {
    expect(payoutStatusToken(PayoutStatus.paid), StatusToken.payoutPaid);
    expect(payoutStatusToken(PayoutStatus.next), StatusToken.payoutNext);
    expect(payoutStatusToken(PayoutStatus.waiting), StatusToken.payoutWaiting);
    expect(payoutStatusToken(PayoutStatus.unknown), StatusToken.unknown);
  });

  test('"paid" reuses the measured "paid out" pair, in both themes', () {
    for (final colors in [StatusColors.light, StatusColors.dark]) {
      expect(
        colors[StatusToken.payoutPaid],
        same(colors[StatusToken.cyclePaidOut]),
      );
    }
  });

  for (final (name, theme, colors) in [
    ('light', AppTheme.light, StatusColors.light),
    ('dark', AppTheme.dark, StatusColors.dark),
  ]) {
    for (final status in PayoutStatus.values) {
      testWidgets('$name: ${status.name} says so in words, on the $name '
          'tokens', (tester) async {
        final (text, fill) = await _pumpChip(tester, status, theme);
        final tone = colors[payoutStatusToken(status)];

        expect(find.text(payoutStatusLabel(status)), findsOneWidget);
        expect(text, tone.foreground);
        expect(fill, tone.background);
      });
    }
  }

  testWidgets('dark mode reads the dark tokens, not the light ones', (
    tester,
  ) async {
    final (text, fill) = await _pumpChip(
      tester,
      PayoutStatus.next,
      AppTheme.dark,
    );

    expect(fill, isNot(StatusColors.light[StatusToken.payoutNext].background));
    expect(text, isNot(StatusColors.light[StatusToken.payoutNext].foreground));
  });
}
