import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/core/config/app_config.dart';
import 'package:ronditrack_app/core/data/api_client.dart';
import 'package:ronditrack_app/core/data/generated/rondi_track_api.dart';
import 'package:ronditrack_app/features/activity/data/fake_activity_repository.dart';
import 'package:ronditrack_app/features/activity/data/flaky_activity_repository.dart';
import 'package:ronditrack_app/features/activity/domain/activity_repository.dart';
import 'package:ronditrack_app/features/auth/data/fake_auth_repository.dart';
import 'package:ronditrack_app/features/auth/domain/auth_repository.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_app/features/home/data/flaky_home_repository.dart';
import 'package:ronditrack_app/features/home/domain/home_repository.dart';
import 'package:ronditrack_app/features/invites/data/fake_invite_repository.dart';
import 'package:ronditrack_app/features/invites/domain/invite_repository.dart';
import 'package:ronditrack_app/features/payouts/data/fake_payout_repository.dart';
import 'package:ronditrack_app/features/payouts/data/flaky_payout_repository.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/flaky_stokvel_repository.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';

part 'providers.g.dart';

// The composition root. These are the only lines that name a repository's
// implementation; Week 11 swaps the fakes for the API here, and nowhere
// else. Widgets never import this file's imports.

/// Who is signed in: their id, or `null` when nobody is. It follows
/// [authControllerProvider], so signing in as someone else rebuilds every
/// repository for them.
@Riverpod(keepAlive: true)
String? signedInUserId(Ref ref) => switch (ref.watch(authControllerProvider)) {
  SignedIn(:final user) => user.id,
  SignedOut() => null,
};

/// The flavour's validated configuration. `main` overrides it with the one
/// it built from `config/<flavour>.json`; nothing has a default address.
@Riverpod(keepAlive: true)
AppConfig appConfig(Ref ref) => throw StateError(
  'appConfigProvider has no value: main overrides it with the flavour config.',
);

/// Where the API's log lines go: the Run console, in debug builds only.
/// Tests override it to read the lines back.
@Riverpod(keepAlive: true)
void Function(String line) apiLog(Ref ref) => (line) {
  if (kDebugMode) debugPrint(line);
};

/// The signed-in person's access token, in memory only.
@Riverpod(keepAlive: true)
AccessTokenHolder accessToken(Ref ref) => AccessTokenHolder();

/// The one Dio client, for the app's whole life: its base URL from the
/// flavour's config, never typed in code. A `401` outside sign-in ends the
/// session (README "Failures").
@Riverpod(keepAlive: true)
Dio apiClient(Ref ref) {
  final dio = createApiClient(
    baseUri: ref.watch(appConfigProvider).apiBaseUri,
    tokens: ref.watch(accessTokenProvider),
    onSessionEnded: () =>
        ref.read(authControllerProvider.notifier).sessionEnded(),
    log: ref.watch(apiLogProvider),
  );
  ref.onDispose(dio.close);
  return dio;
}

/// The client generated from `contract/openapi/v1.json`, over [apiClient].
/// Only `data/` code reads it.
@Riverpod(keepAlive: true)
RondiTrackApi api(Ref ref) => RondiTrackApi(ref.watch(apiClientProvider));

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

/// The fakes' pretend network delay. Router-level tests set
/// [Duration.zero], which also drops Soweto Teachers' extra slowness.
/// Week 11 deletes it.
@Riverpod(keepAlive: true)
Duration fakeDelay(Ref ref) => const Duration(milliseconds: 600);

/// The fakes' changeable copy of the seed: joining an invite adds a
/// membership here, and every fake reads it. One per app session (and per
/// test). Week 11 deletes it.
@Riverpod(keepAlive: true)
List<FakeStokvel> fakeStokvels(Ref ref) => FakeSeed.fresh();

/// The accounts the sign-in screen offers to fill in, so a tester needn't
/// type an email. Week 11 makes this empty.
@Riverpod(keepAlive: true)
List<({String name, String email})> demoAccounts(Ref ref) => [
  for (final persona in FakeSeed.personas.values)
    (name: persona.name, email: persona.email),
];

/// Signs in and out. Implementation: [FakeAuthRepository].
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    FakeAuthRepository(delay: ref.watch(fakeDelayProvider));

/// Reads Home. Implementation: [FakeHomeRepository], wrapped in
/// [FlakyHomeRepository] when [fakeFailEvery] is set.
@Riverpod(keepAlive: true)
HomeRepository homeRepository(Ref ref) {
  final fake = FakeHomeRepository(
    userId: ref.watch(signedInUserIdProvider),
    delay: ref.watch(fakeDelayProvider),
    stokvels: ref.watch(fakeStokvelsProvider),
  );
  final failEvery = ref.watch(fakeFailEveryProvider);
  return failEvery > 0 ? FlakyHomeRepository(fake, failEvery: failEvery) : fake;
}

/// Reads stokvels and cycles. Implementation: [FakeStokvelRepository], with
/// Soweto Teachers slow, as it is on Lerato's data bundle; wrapped in
/// [FlakyStokvelRepository] when [fakeFailEvery] is set.
@Riverpod(keepAlive: true)
StokvelRepository stokvelRepository(Ref ref) {
  final delay = ref.watch(fakeDelayProvider);
  final fake = FakeStokvelRepository(
    userId: ref.watch(signedInUserIdProvider),
    delay: delay,
    slowStokvels: delay == Duration.zero
        ? const {}
        : const {FakeSeed.sowetoTeachersId: Duration(seconds: 3)},
    stokvels: ref.watch(fakeStokvelsProvider),
  );
  final failEvery = ref.watch(fakeFailEveryProvider);
  return failEvery > 0
      ? FlakyStokvelRepository(fake, failEvery: failEvery)
      : fake;
}

/// Reads the activity feed. Implementation: [FakeActivityRepository],
/// wrapped in [FlakyActivityRepository] when [fakeFailEvery] is set.
@Riverpod(keepAlive: true)
ActivityRepository activityRepository(Ref ref) {
  final fake = FakeActivityRepository(
    userId: ref.watch(signedInUserIdProvider),
    delay: ref.watch(fakeDelayProvider),
    stokvels: ref.watch(fakeStokvelsProvider),
  );
  final failEvery = ref.watch(fakeFailEveryProvider);
  return failEvery > 0
      ? FlakyActivityRepository(fake, failEvery: failEvery)
      : fake;
}

/// Reads and accepts invites. Implementation: [FakeInviteRepository].
@Riverpod(keepAlive: true)
InviteRepository inviteRepository(Ref ref) => FakeInviteRepository(
  userId: ref.watch(signedInUserIdProvider),
  stokvels: ref.watch(fakeStokvelsProvider),
  delay: ref.watch(fakeDelayProvider),
);

/// Reads a cycle's payout order. Implementation: [FakePayoutRepository],
/// wrapped in [FlakyPayoutRepository] when [fakeFailEvery] is set.
@Riverpod(keepAlive: true)
PayoutRepository payoutRepository(Ref ref) {
  final fake = FakePayoutRepository(
    userId: ref.watch(signedInUserIdProvider),
    delay: ref.watch(fakeDelayProvider),
    stokvels: ref.watch(fakeStokvelsProvider),
  );
  final failEvery = ref.watch(fakeFailEveryProvider);
  return failEvery > 0
      ? FlakyPayoutRepository(fake, failEvery: failEvery)
      : fake;
}
