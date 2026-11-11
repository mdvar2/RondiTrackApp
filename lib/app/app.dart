import 'package:flutter/material.dart';
import 'package:ronditrack_app/core/config/app_config.dart';
import 'package:ronditrack_app/features/home/presentation/home_screen.dart';

/// The root widget for the RondiTrack mobile application.
class RondiTrackApp extends StatelessWidget {
  /// Creates the application using the selected environment configuration.
  const new({required this.config, super.key});

  /// The validated application configuration.
  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: config.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
      ),
      home: HomeScreen(title: config.appName),
    );
  }
}
