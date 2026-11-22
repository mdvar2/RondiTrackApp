import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/providers.dart';

/// Dev build only: make the next request need a refresh, to watch the
/// session interceptor in the Run console.
class SessionTools extends ConsumerWidget {
  /// Creates the tools. Build them only when `AppConfig.hasDevTools`.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void done(String message) =>
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));

    return Padding(
      key: const Key('session-tools'),
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Session tools (dev build)',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                key: const Key('session-spoil'),
                onPressed: () {
                  ref.read(sessionProvider).spoilAccessToken();
                  done('Access token spoiled: the next request gets a 401.');
                },
                child: const Text('Spoil access token'),
              ),
              OutlinedButton(
                key: const Key('session-expire'),
                onPressed: () {
                  ref.read(sessionProvider).expireAccessTokenNow();
                  done('Access token expired: the next request refreshes.');
                },
                child: const Text('Expire it now'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
