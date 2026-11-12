import 'package:ronditrack_app/core/fakes/fail_every.dart';
import 'package:ronditrack_app/features/activity/domain/activity_item.dart';
import 'package:ronditrack_app/features/activity/domain/activity_repository.dart';

/// Wraps an [ActivityRepository] so that some calls fail with
/// [FakeNetworkException], like the other flaky fakes (dev flavour,
/// `FAKE_FAIL_EVERY`).
class FlakyActivityRepository implements ActivityRepository {
  /// Creates the wrapper; see [FailEvery] for which calls fail.
  new(this._inner, {required int failEvery}) : _failures = FailEvery(failEvery);

  final ActivityRepository _inner;
  final FailEvery _failures;

  @override
  Future<List<ActivityItem>> fetchActivity() async {
    final fails = _failures.next();
    final items = await _inner.fetchActivity();
    if (fails) throw const FakeNetworkException();
    return items;
  }
}
