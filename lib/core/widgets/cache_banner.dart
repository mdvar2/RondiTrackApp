import 'package:flutter/material.dart';
import 'package:ronditrack_app/core/cache/cached.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/l10n/generated/app_localizations.dart';

/// How long ago [fetchedAt] was, at [now], in words: "just now", "5
/// minutes ago", "2 hours ago", "3 days ago".
String ageOf(AppLocalizations l10n, DateTime fetchedAt, DateTime now) {
  final age = now.toUtc().difference(fetchedAt.toUtc());
  if (age.inMinutes < 1) return l10n.ageJustNow;
  if (age.inHours < 1) return l10n.ageMinutes(age.inMinutes);
  if (age.inDays < 1) return l10n.ageHours(age.inHours);
  return l10n.ageDays(age.inDays);
}

/// Over cached data whose last refresh failed: why (offline, or the server
/// couldn't), how old the data is, and Try again. Cached data never looks
/// live. Nothing shows while the data is live or refreshing.
///
/// What it says comes from what happened to the request ([SyncStatus]),
/// never from the connection type.
class CacheBanner extends StatelessWidget {
  /// Creates the banner for [status].
  const new({required this.status, required this.onRetry, this.now, super.key});

  /// How the data stands.
  final SyncStatus? status;

  /// Asks the server again.
  final VoidCallback onRetry;

  /// The time to measure the age at; the clock's by default (tests).
  final DateTime Function()? now;

  @override
  Widget build(BuildContext context) {
    final status = this.status;
    final fetchedAt = status?.fetchedAt;
    final failure = status?.failure;
    if (status == null || fetchedAt == null || failure == null) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    final age = ageOf(l10n, fetchedAt, (now ?? DateTime.now)());
    final message = failure is NoAnswerFailure
        ? l10n.bannerOffline(age)
        : l10n.bannerCouldNotRefresh(age);
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      key: const Key('cache-banner'),
      liveRegion: true,
      container: true,
      child: Material(
        color: scheme.tertiaryContainer,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
          child: Row(
            children: [
              ExcludeSemantics(
                child: Icon(
                  failure is NoAnswerFailure
                      ? Icons.cloud_off
                      : Icons.sync_problem,
                  color: scheme.onTertiaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: scheme.onTertiaryContainer),
                ),
              ),
              TextButton(
                key: const Key('cache-banner-retry'),
                onPressed: status.refreshing ? null : onRetry,
                child: Text(l10n.tryAgain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
