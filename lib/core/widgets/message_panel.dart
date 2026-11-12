import 'package:flutter/material.dart';

/// A centred title, optional explanation and an action: the empty, failure
/// and "not found" states. It scrolls, so very large text never overflows.
class MessagePanel extends StatelessWidget {
  /// Creates the panel.
  const new({required this.title, required this.action, this.body, super.key});

  /// What happened, in a line.
  final String title;

  /// What to do about it, if more needs saying.
  final String? body;

  /// A button, or a row of them.
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final body = this.body;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (body != null) ...[
              const SizedBox(height: 8),
              Text(body, textAlign: TextAlign.center),
            ],
            const SizedBox(height: 16),
            action,
          ],
        ),
      ),
    );
  }
}
