import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/cache/cached.dart';

part 'sync_statuses.g.dart';

/// How each screen's data stands (when fetched, whether the last refresh
/// failed), by key: `home`, `stokvel:<id>`, `cycle:<id>:<cycleId>`. The
/// banners read it. Rebuilt for whoever signs in.
@Riverpod(keepAlive: true)
class SyncStatuses extends _$SyncStatuses {
  @override
  Map<String, SyncStatus> build() {
    ref.watch(signedInUserIdProvider);
    return const {};
  }

  /// Records [status] for [key].
  void put(String key, SyncStatus status) => state = {...state, key: status};
}
