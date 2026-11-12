import 'package:flutter/widgets.dart';
import 'package:ronditrack_app/core/config/app_config.dart';

/// Puts the validated [AppConfig] above the router, so a route can read
/// the flavour's name.
class AppConfigScope extends InheritedWidget {
  /// Provides [config] to [child].
  const new({required this.config, required super.child, super.key});

  /// The configuration.
  final AppConfig config;

  /// The nearest configuration above [context].
  static AppConfig of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppConfigScope>();
    assert(scope != null, 'No AppConfigScope above this widget');
    return scope!.config;
  }

  @override
  bool updateShouldNotify(AppConfigScope oldWidget) =>
      config != oldWidget.config;
}
