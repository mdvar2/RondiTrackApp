import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/router/router.dart';
import 'package:ronditrack_app/core/config/app_config.dart';
import 'package:ronditrack_app/core/config/app_config_scope.dart';
import 'package:ronditrack_app/core/theme/app_theme.dart';

/// The root widget for the RondiTrack mobile application.
class RondiTrackApp extends ConsumerWidget {
  /// Creates the application using the selected environment configuration.
  const new({required this.config, super.key});

  /// The validated application configuration.
  final AppConfig config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      ),
    );
  }
}
