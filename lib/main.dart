// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/core/config/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment();

  runApp(ProviderScope(child: RondiTrackApp(config: config)));
}

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
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text(config.appName)),
        body: Center(child: Text('Environment: ${config.environment.name}')),
      ),
    );
  }
}
