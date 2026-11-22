import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/app/database.dart';
import 'package:ronditrack_app/core/cache/cached.dart';
import 'package:ronditrack_app/core/config/app_config.dart';
import 'package:ronditrack_app/core/data/api_client.dart';
import 'package:ronditrack_app/core/data/auth_calls.dart';
import 'package:ronditrack_app/core/data/generated/rondi_track_api.dart';
import 'package:ronditrack_app/core/session/refresh_token_store.dart';
import 'package:ronditrack_app/core/session/session.dart';
import 'package:ronditrack_app/features/activity/data/api_activity_repository.dart';
import 'package:ronditrack_app/features/activity/data/fake_activity_repository.dart';
import 'package:ronditrack_app/features/activity/data/flaky_activity_repository.dart';
import 'package:ronditrack_app/features/activity/domain/activity_repository.dart';
import 'package:ronditrack_app/features/auth/data/api_auth_repository.dart';
import 'package:ronditrack_app/features/auth/data/fake_auth_repository.dart';
import 'package:ronditrack_app/features/auth/data/last_user_store.dart';
import 'package:ronditrack_app/features/auth/domain/auth_repository.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/domain/last_user.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/home/data/api_home_repository.dart';
import 'package:ronditrack_app/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_app/features/home/data/flaky_home_repository.dart';
import 'package:ronditrack_app/features/home/data/home_cache.dart';
import 'package:ronditrack_app/features/home/domain/home_entry.dart';
import 'package:ronditrack_app/features/home/domain/home_repository.dart';
import 'package:ronditrack_app/features/invites/data/api_invite_repository.dart';
import 'package:ronditrack_app/features/invites/data/fake_invite_repository.dart';
import 'package:ronditrack_app/features/invites/domain/invite_repository.dart';
import 'package:ronditrack_app/features/payouts/data/api_payout_repository.dart';
import 'package:ronditrack_app/features/payouts/data/fake_payout_repository.dart';
import 'package:ronditrack_app/features/payouts/data/flaky_payout_repository.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/api_stokvel_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/flaky_stokvel_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/stokvel_cache.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';

part 'providers.g.dart';

// The composition root. These are the only lines that name a repository's
// implementation: the API's, or the fakes' behind [dataSource]. Widgets
// never import this file's imports.

/// Who is signed in: their id, or `null` when nobody is. It follows
/// [authControllerProvider], so signing in as someone else rebuilds every
/// repository for them.
@Riverpod(keepAlive: true)
String? signedInUserId(Ref ref) => switch (ref.watch(authControllerProvider)) {
  SignedIn(:final user) => user.id,
  // Nobody's data while the restore decides: the splash shows nothing.
  Restoring() || SignedOut() => null,
};

/// Where every repository gets its data.
enum DataSource {
  /// The RondiTrack API at the flavour's `API_BASE_URL`.
  api,

  /// The Week 10 fakes: the whole-app tests, and a dev build run with
  /// `--dart-define=DATA_SOURCE=fakes`.
  fakes,
}

/// The one switch between the API and the fakes. The app runs on the API;
/// the Week 10 whole-app tests override this one provider with
/// [DataSource.fakes] and run as before.
@Riverpod(keepAlive: true)
DataSource dataSource(Ref ref) => DataSource.api;

/// The data source `main` may use: the fakes only in the dev flavour, and
/// only when asked for with `--dart-define=DATA_SOURCE=fakes`.
DataSource dataSourceFor(AppEnvironment environment, String requested) =>
    environment == AppEnvironment.dev && requested == 'fakes'
    ? DataSource.fakes
    : DataSource.api;

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

/// Where the refresh token is kept: `flutter_secure_storage`. Tests
/// override it with an [InMemoryRefreshTokenStore].
@Riverpod(keepAlive: true)
RefreshTokenStore refreshTokenStore(Ref ref) => SecureRefreshTokenStore();

/// What carries the requests: Dio's own (`null`) in the app. Tests put a
/// fake server here, under both clients.
@Riverpod(keepAlive: true)
HttpClientAdapter? httpAdapter(Ref ref) => null;

/// The bare client: no session. The auth calls and the session
/// interceptor's one retry go through it (README "The session").
@Riverpod(keepAlive: true)
Dio bareClient(Ref ref) {
  final dio = createBareClient(
    baseUri: ref.watch(appConfigProvider).apiBaseUri,
    log: ref.watch(apiLogProvider),
    adapter: ref.watch(httpAdapterProvider),
  );
  ref.onDispose(dio.close);
  return dio;
}

/// Sign-in, register, refresh and logout, on the bare client, reading the
/// refresh cookie by the name in the flavour's config.
@Riverpod(keepAlive: true)
AuthCalls authCalls(Ref ref) => AuthCalls(
  ref.watch(bareClientProvider),
  cookieName: ref.watch(appConfigProvider).refreshCookieName,
);

/// The session: the access token in memory, the refresh token in
/// [refreshTokenStore], and the one refresh that may be running. Only the
/// refresh's own `401` ends it.
@Riverpod(keepAlive: true)
Session session(Ref ref) => Session(
  calls: ref.watch(authCallsProvider),
  store: ref.watch(refreshTokenStoreProvider),
  onEnded: () => ref.read(authControllerProvider.notifier).sessionEnded(),
);

/// The client every repository uses, for the app's whole life: its base
/// URL from the flavour's config, never typed in code, and the session
/// interceptor, which retries on [bareClient].
@Riverpod(keepAlive: true)
Dio apiClient(Ref ref) {
  final dio = createApiClient(
    baseUri: ref.watch(appConfigProvider).apiBaseUri,
    session: ref.watch(sessionProvider),
    retryClient: ref.watch(bareClientProvider),
    log: ref.watch(apiLogProvider),
    adapter: ref.watch(httpAdapterProvider),
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
/// `--dart-define=FAKE_FAIL_EVERY=` in `main`, with the fakes.
@Riverpod(keepAlive: true)
int fakeFailEvery(Ref ref) => 0;

/// The `FAKE_FAIL_EVERY` value `main` may use: the [requested] one in the
/// dev flavour, and `0` (never fail) in staging and prod, or when the value
/// isn't positive.
int fakeFailEveryFor(AppEnvironment environment, int requested) =>
    environment == AppEnvironment.dev && requested > 0 ? requested : 0;

/// The fakes' pretend network delay. Router-level tests set
/// [Duration.zero], which also drops Soweto Teachers' extra slowness.
@Riverpod(keepAlive: true)
Duration fakeDelay(Ref ref) => const Duration(milliseconds: 600);

/// The fakes' changeable copy of the seed: joining an invite adds a
/// membership here, and every fake reads it. One per app session (and per
/// test).
@Riverpod(keepAlive: true)
List<FakeStokvel> fakeStokvels(Ref ref) => FakeSeed.fresh();

/// The accounts the dev build's sign-in screen and persona switcher offer:
/// the three seed personas, which exist in the fakes and in the API's
/// Development seed (API PR #16) with the same emails. Choosing one fills
/// in the email; the password is typed.
@Riverpod(keepAlive: true)
List<({String name, String email})> demoAccounts(Ref ref) => [
  for (final persona in FakeSeed.personas.values)
    (name: persona.name, email: persona.email),
];

/// Signs in, registers, restores and signs out. Implementation:
/// [ApiAuthRepository], or [FakeAuthRepository].
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => switch (ref.watch(
  dataSourceProvider,
)) {
  DataSource.api => ApiAuthRepository(
    ref.watch(authCallsProvider),
    ref.watch(sessionProvider),
    ref.watch(apiProvider),
  ),
  DataSource.fakes => FakeAuthRepository(delay: ref.watch(fakeDelayProvider)),
};

/// The phone's database: Home, stokvels and cycles as last seen, who was
/// signed in, and the payment outbox. Tests override it with an in-memory
/// one.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase.onDevice();
  ref.onDispose(db.close);
  return db;
}

/// Who was last signed in on this phone, kept with their cached data.
@Riverpod(keepAlive: true)
LastUser lastUser(Ref ref) => DriftLastUser(ref.watch(appDatabaseProvider));

/// Home as the phone last saw it, refreshed from [homeRepository]. It
/// follows who is signed in, like the repository.
@Riverpod(keepAlive: true)
CachedSource<List<HomeEntry>> homeCache(Ref ref) => HomeCache(
  ref.watch(appDatabaseProvider),
  ref.watch(homeRepositoryProvider),
);

/// One stokvel as the phone last saw it, refreshed from
/// [stokvelRepository].
@riverpod
CachedSource<StokvelDetail> stokvelCache(Ref ref, String stokvelId) =>
    StokvelCache(
      ref.watch(appDatabaseProvider),
      ref.watch(stokvelRepositoryProvider),
      stokvelId,
    );

/// One cycle as the phone last saw it, refreshed from [stokvelRepository].
@riverpod
CachedSource<CycleDetail> cycleCache(
  Ref ref,
  String stokvelId,
  String cycleId,
) => CycleCache(
  ref.watch(appDatabaseProvider),
  ref.watch(stokvelRepositoryProvider),
  stokvelId,
  cycleId,
);

/// Reads Home. Implementation: [ApiHomeRepository]; or
/// [FakeHomeRepository], wrapped in [FlakyHomeRepository] when
/// [fakeFailEvery] is set.
///
/// Every repository watches who is signed in, on the API too, so signing in
/// as someone else rebuilds it, and everything that read it.
@Riverpod(keepAlive: true)
HomeRepository homeRepository(Ref ref) {
  if (ref.watch(dataSourceProvider) == DataSource.api) {
    ref.watch(signedInUserIdProvider);
    return ApiHomeRepository(ref.watch(apiProvider));
  }
  final fake = FakeHomeRepository(
    userId: ref.watch(signedInUserIdProvider),
    delay: ref.watch(fakeDelayProvider),
    stokvels: ref.watch(fakeStokvelsProvider),
  );
  final failEvery = ref.watch(fakeFailEveryProvider);
  return failEvery > 0 ? FlakyHomeRepository(fake, failEvery: failEvery) : fake;
}

/// Reads stokvels and cycles. Implementation: [ApiStokvelRepository]; or
/// [FakeStokvelRepository], with Soweto Teachers slow, as it is on Lerato's
/// data bundle, wrapped in [FlakyStokvelRepository] when [fakeFailEvery] is
/// set.
@Riverpod(keepAlive: true)
StokvelRepository stokvelRepository(Ref ref) {
  if (ref.watch(dataSourceProvider) == DataSource.api) {
    ref.watch(signedInUserIdProvider);
    return ApiStokvelRepository(ref.watch(apiProvider));
  }
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

/// Reads the activity feed. Implementation: [ApiActivityRepository]; or
/// [FakeActivityRepository], wrapped in [FlakyActivityRepository] when
/// [fakeFailEvery] is set.
@Riverpod(keepAlive: true)
ActivityRepository activityRepository(Ref ref) {
  if (ref.watch(dataSourceProvider) == DataSource.api) {
    ref.watch(signedInUserIdProvider);
    return ApiActivityRepository(ref.watch(apiProvider));
  }
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

/// Reads and accepts invites. Implementation: [ApiInviteRepository], or
/// [FakeInviteRepository].
@Riverpod(keepAlive: true)
InviteRepository inviteRepository(Ref ref) {
  final userId = ref.watch(signedInUserIdProvider);
  return switch (ref.watch(dataSourceProvider)) {
    DataSource.api => ApiInviteRepository(ref.watch(apiProvider)),
    DataSource.fakes => FakeInviteRepository(
      userId: userId,
      stokvels: ref.watch(fakeStokvelsProvider),
      delay: ref.watch(fakeDelayProvider),
    ),
  };
}

/// Reads a cycle's payout order. Implementation: [ApiPayoutRepository]; or
/// [FakePayoutRepository], wrapped in [FlakyPayoutRepository] when
/// [fakeFailEvery] is set.
@Riverpod(keepAlive: true)
PayoutRepository payoutRepository(Ref ref) {
  if (ref.watch(dataSourceProvider) == DataSource.api) {
    ref.watch(signedInUserIdProvider);
    return ApiPayoutRepository(ref.watch(apiProvider));
  }
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
