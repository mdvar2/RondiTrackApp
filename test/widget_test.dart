// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/config/app_config.dart';
import 'package:ronditrack_app/main.dart';

void main() {
  testWidgets('displays the development environment', (tester) async {
    const config = AppConfig(
      environment: AppEnvironment.dev,
      appName: 'RondiTrack Dev',
    );

    await tester.pumpWidget(const RondiTrackApp(config: config));

    expect(find.text('RondiTrack Dev'), findsOneWidget);
    expect(find.text('Environment: dev'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('displays the production environment', (tester) async {
    const config = AppConfig(
      environment: AppEnvironment.prod,
      appName: 'RondiTrack',
    );

    await tester.pumpWidget(const RondiTrackApp(config: config));

    expect(find.text('RondiTrack'), findsOneWidget);
    expect(find.text('Environment: prod'), findsOneWidget);
  });
}
