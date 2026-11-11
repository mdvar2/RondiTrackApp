import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/features/home/domain/home_entry.dart';

part 'home_controller.g.dart';

/// Home: one entry per stokvel the signed-in person belongs to.
///
/// Lifetime: autoDispose. See README "Provider lifetimes".
@riverpod
class HomeController extends _$HomeController {
  @override
  Future<List<HomeEntry>> build() =>
      ref.watch(homeRepositoryProvider).fetchHome();

  /// Reloads Home. The old entries stay in [state] (and on screen) until the
  /// new ones arrive. Completes when the reload finishes, even if it fails,
  /// so a pull-to-refresh spinner always stops.
  Future<void> refresh() async {
    ref.invalidateSelf();
    try {
      await future;
    } on Object {
      // The failure is in `state`; the screen shows it.
    }
  }
}

/// Home's view state: no stokvels is [ViewEmpty], never an empty list of
/// [ViewData].
ViewState<List<HomeEntry>> homeViewState(AsyncValue<List<HomeEntry>> value) =>
    viewStateFrom(value, isEmpty: (entries) => entries.isEmpty);
