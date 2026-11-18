import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The reference of an unexpected failure: the API's `correlationId`, which
/// support can find in the API's logs and traces. Selectable, with a copy
/// button, and it stays on screen until the person leaves or tries again.
class FailureReference extends StatelessWidget {
  /// Shows [reference].
  const new({required this.reference, super.key});

  /// The id to quote.
  final String reference;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      key: const Key('failure-reference'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Reference', style: theme.textTheme.labelMedium),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SelectableText(
                reference,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              key: const Key('copy-reference'),
              tooltip: 'Copy reference',
              icon: const Icon(Icons.copy),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: reference));
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reference copied')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
