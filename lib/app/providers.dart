import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_app/features/home/domain/home_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';

part 'providers.g.dart';

// The composition root. These are the only lines that name a repository's
// implementation; Week 11 swaps the fakes for the API here, and nowhere
// else. Widgets never import this file's imports.

/// Who is signed in. Until Week 11 adds sign-in, a seed persona (Lerato,
/// unless `--dart-define=FAKE_PERSONA=` picks another in `main`).
@Riverpod(keepAlive: true)
String signedInUserId(Ref ref) => FakeSeed.lerato.id;

/// Reads Home. Implementation: [FakeHomeRepository].
@Riverpod(keepAlive: true)
HomeRepository homeRepository(Ref ref) =>
    FakeHomeRepository(userId: ref.watch(signedInUserIdProvider));

/// Reads one stokvel. Implementation: [FakeStokvelRepository], with Soweto
/// Teachers slow, as it is on Lerato's data bundle.
@Riverpod(keepAlive: true)
StokvelRepository stokvelRepository(Ref ref) => FakeStokvelRepository(
  userId: ref.watch(signedInUserIdProvider),
  slowStokvels: const {FakeSeed.sowetoTeachersId: Duration(seconds: 3)},
);
