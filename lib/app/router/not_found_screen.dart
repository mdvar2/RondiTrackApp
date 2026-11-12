import 'package:flutter/material.dart';
import 'package:ronditrack_app/app/router/routes.dart';

/// Shown if the router ever fails to match an address. The gate sends
/// unknown addresses Home first, so this is a backstop, never a blank
/// screen.
class NotFoundScreen extends StatelessWidget {
  /// Creates the screen.
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "We couldn't find that page.",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => const HomeRoute().go(context),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
