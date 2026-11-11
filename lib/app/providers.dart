import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/core/config/app_config.dart';
import 'package:ronditrack_app/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_app/features/home/data/flaky_home_repository.dart';
import 'package:ronditrack_app/features/home/domain/home_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/flaky_stokvel_repository.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';

part 'providers.g.dart';

// The composition root. These are the only lines that name a repository's
// implementation; Week 11 swaps the fakes for the API here, and nowhere
// else. Widgets never import this file's imports.

/// Who is signed in. Until Week 11 adds sign-in, a seed persona (Lerato,
/// unless `--dart-define=FAKE_PERSONA=` picks another in `main`).
@Riverpod(keepAlive: true)
String signedInUserId(Ref ref) => FakeSeed.lerato.id;

/// How often the fakes fail: `0` never (the default), `3` the first call and
/// every third after it. Only the dev flavour sets it, from
/// `--dart-define=FAKE_FAIL_EVERY=` in `main`. Week 11 deletes it.
@Riverpod(keepAlive: true)
int fakeFailEvery(Ref ref) => 0;

/// The `FAKE_FAIL_EVERY` value `main` may use: the [requested] one in the
/// dev flavour, and `0` (never fail) in staging and prod, or when the value
/// isn't positive.
int fakeFailEveryFor(AppEnvironment environment, int requested) =>
    environment == AppEnvironment.dev && requested > 0 ? requested : 0;

/// Reads Home. Implementation: [FakeHomeRepository], wrapped in
/// [FlakyHomeRepository] when [fakeFailEvery] is set.
@Riverpod(keepAlive: true)
HomeRepository homeRepository(Ref ref) {
  final fake = FakeHomeRepository(userId: ref.watch(signedInUserIdProvider));
  final failEvery = ref.watch(fakeFailEveryProvider);
  return failEvery > 0 ? FlakyHomeRepository(fake, failEvery: failEvery) : fake;
}

/// Reads one stokvel. Implementation: [FakeStokvelRepository], with Soweto
/// Teachers slow, as it is on Lerato's data bundle; wrapped in
/// [FlakyStokvelRepository] when [fakeFailEvery] is set.
@Riverpod(keepAlive: true)
StokvelRepository stokvelRepository(Ref ref) {
  final fake = FakeStokvelRepository(
    userId: ref.watch(signedInUserIdProvider),
    slowStokvels: const {FakeSeed.sowetoTeachersId: Duration(seconds: 3)},
  );
  final failEvery = ref.watch(fakeFailEveryProvider);
  return failEvery > 0
      ? FlakyStokvelRepository(fake, failEvery: failEvery)
      : fake;
}
