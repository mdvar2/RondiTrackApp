import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ronditrack_app/core/config/app_config_scope.dart';
import 'package:ronditrack_app/l10n/generated/app_localizations.dart';

/// The installed build's version name and build number, read from the
/// build itself (README "Releases"): the name comes from the git tag and
/// the number from the CI run, never typed by hand.
final FutureProvider<PackageInfo> installedBuildProvider =
    FutureProvider<PackageInfo>((ref) => PackageInfo.fromPlatform());

/// "Version 1.4.0 (37) · staging", where a tester can quote it.
class VersionLabel extends ConsumerWidget {
  /// Creates the label.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(installedBuildProvider).value;
    if (info == null) return const SizedBox.shrink();
    final flavour = AppConfigScope.of(context).environment.name;
    return SelectableText(
      AppLocalizations.of(context)
          .versionLabel(info.version, info.buildNumber, flavour),
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}
