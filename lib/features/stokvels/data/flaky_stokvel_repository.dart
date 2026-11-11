import 'package:ronditrack_app/core/fakes/fail_every.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';

/// Wraps a [StokvelRepository] so that some calls fail with
/// [FakeNetworkException], after the usual wait. The dev flavour uses it
/// behind `--dart-define=FAKE_FAIL_EVERY=3`, to show the failure and retry
/// states on a phone.
class FlakyStokvelRepository implements StokvelRepository {
  /// Creates the wrapper; see [FailEvery] for which calls fail.
  new(this._inner, {required int failEvery}) : _failures = FailEvery(failEvery);

  final StokvelRepository _inner;
  final FailEvery _failures;

  @override
  Future<StokvelDetail> fetchStokvel(String stokvelId) async {
    final fails = _failures.next();
    final detail = await _inner.fetchStokvel(stokvelId);
    if (fails) throw const FakeNetworkException();
    return detail;
  }
}
