// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/config/app_config.dart';
import 'package:ronditrack_app/main.dart';

void main() {
  testWidgets('displays the development environment', (tester) async {
    final config = AppConfig.fromValues(
      environment: 'dev',
      appName: 'RondiTrack Dev',
    );

    await tester.pumpWidget(RondiTrackApp(config: config));

    expect(find.text('RondiTrack Dev'), findsOneWidget);
    expect(find.text('Environment: dev'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('displays the production environment', (tester) async {
    final config = AppConfig.fromValues(
      environment: 'prod',
      appName: 'RondiTrack',
    );

    await tester.pumpWidget(RondiTrackApp(config: config));

    expect(find.text('RondiTrack'), findsOneWidget);
    expect(find.text('Environment: prod'), findsOneWidget);
  });
}
