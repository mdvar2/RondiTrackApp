// main.dart
import 'package:flutter/material.dart';
import 'package:ronditrack_app/core/config/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment();

  runApp(RondiTrackApp(config: config));
}

class RondiTrackApp extends StatelessWidget {
  const RondiTrackApp({required this.config, super.key});

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
