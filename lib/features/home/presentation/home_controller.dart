import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/app/sync_statuses.dart';
import 'package:ronditrack_app/core/cache/cached.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/features/home/domain/home_entry.dart';

part 'home_controller.g.dart';

/// Home: one entry per stokvel the signed-in person belongs to.
///
/// Lifetime: autoDispose. See README "Provider lifetimes".
@riverpod
class HomeController extends _$HomeController {
  /// What the phone has, at once, then the server's answer once it is in
  /// the cache (README "Offline").
  late CacheSync<List<HomeEntry>> _sync;

  @override
  Stream<List<HomeEntry>> build() {
    _sync = CacheSync(
      ref.watch(homeCacheProvider),
      onStatus: (status) =>
          ref.read(syncStatusesProvider.notifier).put(homeSyncKey, status),
    );
    return _sync.start();
  }

  /// Reloads Home. The old entries stay in [state] (and on screen) until the
  /// new ones arrive. Completes when the reload finishes, even if it fails,
  /// so a pull-to-refresh spinner always stops.
  ///
  /// With something cached, it asks the server again and the cached cards
  /// stay on screen; with nothing (a failure on screen), it starts over.
  Future<void> refresh() async {
    if (state.hasValue) return await _sync.refresh();
    ref.invalidateSelf();
    try {
      await future;
    } on Object {
      // The failure is in `state`; the screen shows it.
    }
  }
}

/// Home's key in [syncStatusesProvider].
const homeSyncKey = 'home';

/// Home's view state: no stokvels is [ViewEmpty], never an empty list of
/// [ViewData].
ViewState<List<HomeEntry>> homeViewState(AsyncValue<List<HomeEntry>> value) =>
    viewStateFrom(value, isEmpty: (entries) => entries.isEmpty);
