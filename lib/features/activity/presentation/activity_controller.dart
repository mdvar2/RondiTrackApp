import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/features/activity/domain/activity_item.dart';

part 'activity_controller.g.dart';

/// The activity feed across my stokvels.
///
/// Lifetime: autoDispose. While the Activity tab is in the shell's stack it
/// stays watched; it goes at sign-out, with the shell.
@riverpod
class ActivityController extends _$ActivityController {
  @override
  Future<List<ActivityItem>> build() =>
      ref.watch(activityRepositoryProvider).fetchActivity();

  /// Reloads the feed, keeping the old items on screen until the new ones
  /// arrive. Completes even if the reload fails.
  Future<void> refresh() async {
    ref.invalidateSelf();
    try {
      await future;
    } on Object {
      // The failure is in `state`; the screen shows it.
    }
  }
}

/// The feed's view state: no items is [ViewEmpty].
ViewState<List<ActivityItem>> activityViewState(
  AsyncValue<List<ActivityItem>> value,
) => viewStateFrom(value, isEmpty: (items) => items.isEmpty);
