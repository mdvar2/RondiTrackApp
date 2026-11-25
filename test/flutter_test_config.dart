import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';

/// Goldens (README "Running the tests"):
///
/// - CI goldens draw text as blocks. They are made on Linux by CI's
///   "update_goldens" run and compared on Linux only: Windows anti-aliases
///   rounded corners differently (0.16% of pixels).
/// - Platform goldens have real text, and are made and compared on Windows
///   only.
///
/// Not const: a {HostPlatform.windows} set has no primitive equality.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      ciGoldensConfig: CiGoldensConfig(enabled: Platform.isLinux),
      platformGoldensConfig: PlatformGoldensConfig(
        platforms: {HostPlatform.windows},
      ),
    ),
    run: testMain,
  );
}
