import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/router/router.dart';
import 'package:ronditrack_app/app/settings.dart';
import 'package:ronditrack_app/core/config/app_config.dart';
import 'package:ronditrack_app/core/config/app_config_scope.dart';
import 'package:ronditrack_app/core/theme/app_theme.dart';
import 'package:ronditrack_app/features/notifications/presentation/push_providers.dart';
import 'package:ronditrack_app/l10n/generated/app_localizations.dart';

/// The root widget for the RondiTrack mobile application.
class RondiTrackApp extends ConsumerWidget {
  /// Creates the application using the selected environment configuration.
  const new({required this.config, super.key});

  /// The validated application configuration.
  final AppConfig config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pushes while the app runs: refetch in front, open on a tap.
    ref.watch(pushRoutingProvider);
    return AppConfigScope(
      config: config,
      child: MaterialApp.router(
        title: config.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        // No themeMode: the default, ThemeMode.system, follows the phone's
        // light or dark setting.
        routerConfig: ref.watch(routerProvider),
        // English and Afrikaans (README "Languages"): the person's choice,
        // or the phone's language when they haven't chosen.
        locale: ref.watch(languageChoiceProvider),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
