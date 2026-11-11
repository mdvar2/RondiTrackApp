import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lifecycle_log.g.dart';

/// Writes one line about a provider's lifetime.
///
/// Lines carry a provider's name and an id, never a person's name or an
/// amount.
typedef LifecycleLog = void Function(String line);

/// Where lifecycle lines go: the Run console, in debug builds only. Tests
/// override it to read the lines back.
@Riverpod(keepAlive: true)
LifecycleLog lifecycleLog(Ref ref) => (line) {
  if (kDebugMode) debugPrint('[lifecycle] $line');
};
