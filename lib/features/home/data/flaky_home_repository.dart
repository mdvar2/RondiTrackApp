import 'package:ronditrack_app/core/fakes/fail_every.dart';
import 'package:ronditrack_app/features/home/domain/home_entry.dart';
import 'package:ronditrack_app/features/home/domain/home_repository.dart';

/// Wraps a [HomeRepository] so that some calls fail with
/// [FakeNetworkException], after the usual wait. The dev flavour uses it
/// behind `--dart-define=FAKE_FAIL_EVERY=`: `1` shows the failure state on a
/// phone; `3` shows Riverpod's automatic retry recovering by itself.
class FlakyHomeRepository implements HomeRepository {
  /// Creates the wrapper; see [FailEvery] for which calls fail.
  new(this._inner, {required int failEvery}) : _failures = FailEvery(failEvery);

  final HomeRepository _inner;
  final FailEvery _failures;

  @override
  Future<List<HomeEntry>> fetchHome() async {
    final fails = _failures.next();
    final entries = await _inner.fetchHome();
    if (fails) throw const FakeNetworkException();
    return entries;
  }
}
