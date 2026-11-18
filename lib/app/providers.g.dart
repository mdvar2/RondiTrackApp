// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Who is signed in: their id, or `null` when nobody is. It follows
/// [authControllerProvider], so signing in as someone else rebuilds every
/// repository for them.

@ProviderFor(signedInUserId)
final signedInUserIdProvider = SignedInUserIdProvider._();

/// Who is signed in: their id, or `null` when nobody is. It follows
/// [authControllerProvider], so signing in as someone else rebuilds every
/// repository for them.

final class SignedInUserIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Who is signed in: their id, or `null` when nobody is. It follows
  /// [authControllerProvider], so signing in as someone else rebuilds every
  /// repository for them.
  SignedInUserIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signedInUserIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signedInUserIdHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return signedInUserId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$signedInUserIdHash() => r'96c3a33ea3335b74a06427da799eba3dabb47c6b';

/// The one switch between the API and the fakes. The app runs on the API;
/// the Week 10 whole-app tests override this one provider with
/// [DataSource.fakes] and run as before.

@ProviderFor(dataSource)
final dataSourceProvider = DataSourceProvider._();

/// The one switch between the API and the fakes. The app runs on the API;
/// the Week 10 whole-app tests override this one provider with
/// [DataSource.fakes] and run as before.

final class DataSourceProvider
    extends $FunctionalProvider<DataSource, DataSource, DataSource>
    with $Provider<DataSource> {
  /// The one switch between the API and the fakes. The app runs on the API;
  /// the Week 10 whole-app tests override this one provider with
  /// [DataSource.fakes] and run as before.
  DataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dataSourceHash();

  @$internal
  @override
  $ProviderElement<DataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DataSource create(Ref ref) {
    return dataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DataSource>(value),
    );
  }
}

String _$dataSourceHash() => r'24466549ff5788bf9df6035fa72b289fb6a3c569';

/// The seed password for the dev build's persona sign-in, passed at run
/// time with `--dart-define=SEED_PASSWORD=…` and never committed. Empty in
/// staging and prod, which have no personas.

@ProviderFor(seedPassword)
final seedPasswordProvider = SeedPasswordProvider._();

/// The seed password for the dev build's persona sign-in, passed at run
/// time with `--dart-define=SEED_PASSWORD=…` and never committed. Empty in
/// staging and prod, which have no personas.

final class SeedPasswordProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// The seed password for the dev build's persona sign-in, passed at run
  /// time with `--dart-define=SEED_PASSWORD=…` and never committed. Empty in
  /// staging and prod, which have no personas.
  SeedPasswordProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seedPasswordProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seedPasswordHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return seedPassword(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$seedPasswordHash() => r'68efd89162cb575ee56c6ae87a04ddcc2962611a';

/// The flavour's validated configuration. `main` overrides it with the one
/// it built from `config/<flavour>.json`; nothing has a default address.

@ProviderFor(appConfig)
final appConfigProvider = AppConfigProvider._();

/// The flavour's validated configuration. `main` overrides it with the one
/// it built from `config/<flavour>.json`; nothing has a default address.

final class AppConfigProvider
    extends $FunctionalProvider<AppConfig, AppConfig, AppConfig>
    with $Provider<AppConfig> {
  /// The flavour's validated configuration. `main` overrides it with the one
  /// it built from `config/<flavour>.json`; nothing has a default address.
  AppConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appConfigHash();

  @$internal
  @override
  $ProviderElement<AppConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppConfig create(Ref ref) {
    return appConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppConfig>(value),
    );
  }
}

String _$appConfigHash() => r'32a0155f586772c5503259bbd2e0a9bf56ba3f41';

/// Where the API's log lines go: the Run console, in debug builds only.
/// Tests override it to read the lines back.

@ProviderFor(apiLog)
final apiLogProvider = ApiLogProvider._();

/// Where the API's log lines go: the Run console, in debug builds only.
/// Tests override it to read the lines back.

final class ApiLogProvider
    extends
        $FunctionalProvider<
          void Function(String line),
          void Function(String line),
          void Function(String line)
        >
    with $Provider<void Function(String line)> {
  /// Where the API's log lines go: the Run console, in debug builds only.
  /// Tests override it to read the lines back.
  ApiLogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiLogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiLogHash();

  @$internal
  @override
  $ProviderElement<void Function(String line)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  void Function(String line) create(Ref ref) {
    return apiLog(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void Function(String line) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void Function(String line)>(value),
    );
  }
}

String _$apiLogHash() => r'7140338884dd23922c68037ad174ce0e8f31e295';

/// The signed-in person's access token, in memory only.

@ProviderFor(accessToken)
final accessTokenProvider = AccessTokenProvider._();

/// The signed-in person's access token, in memory only.

final class AccessTokenProvider
    extends
        $FunctionalProvider<
          AccessTokenHolder,
          AccessTokenHolder,
          AccessTokenHolder
        >
    with $Provider<AccessTokenHolder> {
  /// The signed-in person's access token, in memory only.
  AccessTokenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accessTokenProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accessTokenHash();

  @$internal
  @override
  $ProviderElement<AccessTokenHolder> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccessTokenHolder create(Ref ref) {
    return accessToken(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccessTokenHolder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccessTokenHolder>(value),
    );
  }
}

String _$accessTokenHash() => r'76bbd078a7137a2dd44a03982926688eb37e3beb';

/// The one Dio client, for the app's whole life: its base URL from the
/// flavour's config, never typed in code. A `401` outside sign-in ends the
/// session (README "Failures").

@ProviderFor(apiClient)
final apiClientProvider = ApiClientProvider._();

/// The one Dio client, for the app's whole life: its base URL from the
/// flavour's config, never typed in code. A `401` outside sign-in ends the
/// session (README "Failures").

final class ApiClientProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// The one Dio client, for the app's whole life: its base URL from the
  /// flavour's config, never typed in code. A `401` outside sign-in ends the
  /// session (README "Failures").
  ApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return apiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$apiClientHash() => r'2f6071b871da9b85260609a905bbede607919372';

/// The client generated from `contract/openapi/v1.json`, over [apiClient].
/// Only `data/` code reads it.

@ProviderFor(api)
final apiProvider = ApiProvider._();

/// The client generated from `contract/openapi/v1.json`, over [apiClient].
/// Only `data/` code reads it.

final class ApiProvider
    extends $FunctionalProvider<RondiTrackApi, RondiTrackApi, RondiTrackApi>
    with $Provider<RondiTrackApi> {
  /// The client generated from `contract/openapi/v1.json`, over [apiClient].
  /// Only `data/` code reads it.
  ApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiHash();

  @$internal
  @override
  $ProviderElement<RondiTrackApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RondiTrackApi create(Ref ref) {
    return api(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RondiTrackApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RondiTrackApi>(value),
    );
  }
}

String _$apiHash() => r'aaa7bff90b788c4242871cac8aa04a456c9676ec';

/// How often the fakes fail: `0` never (the default), `3` the first call and
/// every third after it. Only the dev flavour sets it, from
/// `--dart-define=FAKE_FAIL_EVERY=` in `main`, with the fakes.

@ProviderFor(fakeFailEvery)
final fakeFailEveryProvider = FakeFailEveryProvider._();

/// How often the fakes fail: `0` never (the default), `3` the first call and
/// every third after it. Only the dev flavour sets it, from
/// `--dart-define=FAKE_FAIL_EVERY=` in `main`, with the fakes.

final class FakeFailEveryProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// How often the fakes fail: `0` never (the default), `3` the first call and
  /// every third after it. Only the dev flavour sets it, from
  /// `--dart-define=FAKE_FAIL_EVERY=` in `main`, with the fakes.
  FakeFailEveryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fakeFailEveryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fakeFailEveryHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return fakeFailEvery(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$fakeFailEveryHash() => r'347eaf6c618d8636b5f585836382bb98e14ff136';

/// The fakes' pretend network delay. Router-level tests set
/// [Duration.zero], which also drops Soweto Teachers' extra slowness.

@ProviderFor(fakeDelay)
final fakeDelayProvider = FakeDelayProvider._();

/// The fakes' pretend network delay. Router-level tests set
/// [Duration.zero], which also drops Soweto Teachers' extra slowness.

final class FakeDelayProvider
    extends $FunctionalProvider<Duration, Duration, Duration>
    with $Provider<Duration> {
  /// The fakes' pretend network delay. Router-level tests set
  /// [Duration.zero], which also drops Soweto Teachers' extra slowness.
  FakeDelayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fakeDelayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fakeDelayHash();

  @$internal
  @override
  $ProviderElement<Duration> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Duration create(Ref ref) {
    return fakeDelay(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration>(value),
    );
  }
}

String _$fakeDelayHash() => r'4ba5ba795ca86c916f235f56774883fa048008b2';

/// The fakes' changeable copy of the seed: joining an invite adds a
/// membership here, and every fake reads it. One per app session (and per
/// test).

@ProviderFor(fakeStokvels)
final fakeStokvelsProvider = FakeStokvelsProvider._();

/// The fakes' changeable copy of the seed: joining an invite adds a
/// membership here, and every fake reads it. One per app session (and per
/// test).

final class FakeStokvelsProvider
    extends
        $FunctionalProvider<
          List<FakeStokvel>,
          List<FakeStokvel>,
          List<FakeStokvel>
        >
    with $Provider<List<FakeStokvel>> {
  /// The fakes' changeable copy of the seed: joining an invite adds a
  /// membership here, and every fake reads it. One per app session (and per
  /// test).
  FakeStokvelsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fakeStokvelsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fakeStokvelsHash();

  @$internal
  @override
  $ProviderElement<List<FakeStokvel>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<FakeStokvel> create(Ref ref) {
    return fakeStokvels(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<FakeStokvel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<FakeStokvel>>(value),
    );
  }
}

String _$fakeStokvelsHash() => r'3ced7d4f7cc494159cec54d89f54a5275f47474f';

/// The accounts the dev build's sign-in screen and persona switcher offer:
/// the three seed personas, which exist in the fakes and in the API's
/// Development seed (API PR #16) with the same emails.

@ProviderFor(demoAccounts)
final demoAccountsProvider = DemoAccountsProvider._();

/// The accounts the dev build's sign-in screen and persona switcher offer:
/// the three seed personas, which exist in the fakes and in the API's
/// Development seed (API PR #16) with the same emails.

final class DemoAccountsProvider
    extends
        $FunctionalProvider<
          List<({String email, String name})>,
          List<({String email, String name})>,
          List<({String email, String name})>
        >
    with $Provider<List<({String email, String name})>> {
  /// The accounts the dev build's sign-in screen and persona switcher offer:
  /// the three seed personas, which exist in the fakes and in the API's
  /// Development seed (API PR #16) with the same emails.
  DemoAccountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'demoAccountsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$demoAccountsHash();

  @$internal
  @override
  $ProviderElement<List<({String email, String name})>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<({String email, String name})> create(Ref ref) {
    return demoAccounts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<({String email, String name})> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<({String email, String name})>>(
        value,
      ),
    );
  }
}

String _$demoAccountsHash() => r'4a776dee9d5ef16bd4e397683c8ca9ed282038ba';

/// Signs in and out. Implementation: [ApiAuthRepository], or
/// [FakeAuthRepository].

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

/// Signs in and out. Implementation: [ApiAuthRepository], or
/// [FakeAuthRepository].

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// Signs in and out. Implementation: [ApiAuthRepository], or
  /// [FakeAuthRepository].
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'cf339617de056a40afd92b40e2909cf8f6b8df50';

/// Reads Home. Implementation: [ApiHomeRepository]; or
/// [FakeHomeRepository], wrapped in [FlakyHomeRepository] when
/// [fakeFailEvery] is set.
///
/// Every repository watches who is signed in, on the API too, so signing in
/// as someone else rebuilds it, and everything that read it.

@ProviderFor(homeRepository)
final homeRepositoryProvider = HomeRepositoryProvider._();

/// Reads Home. Implementation: [ApiHomeRepository]; or
/// [FakeHomeRepository], wrapped in [FlakyHomeRepository] when
/// [fakeFailEvery] is set.
///
/// Every repository watches who is signed in, on the API too, so signing in
/// as someone else rebuilds it, and everything that read it.

final class HomeRepositoryProvider
    extends $FunctionalProvider<HomeRepository, HomeRepository, HomeRepository>
    with $Provider<HomeRepository> {
  /// Reads Home. Implementation: [ApiHomeRepository]; or
  /// [FakeHomeRepository], wrapped in [FlakyHomeRepository] when
  /// [fakeFailEvery] is set.
  ///
  /// Every repository watches who is signed in, on the API too, so signing in
  /// as someone else rebuilds it, and everything that read it.
  HomeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeRepositoryHash();

  @$internal
  @override
  $ProviderElement<HomeRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HomeRepository create(Ref ref) {
    return homeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeRepository>(value),
    );
  }
}

String _$homeRepositoryHash() => r'40c6f74887047f67a8e6b1192fa75589a74b210f';

/// Reads stokvels and cycles. Implementation: [ApiStokvelRepository]; or
/// [FakeStokvelRepository], with Soweto Teachers slow, as it is on Lerato's
/// data bundle, wrapped in [FlakyStokvelRepository] when [fakeFailEvery] is
/// set.

@ProviderFor(stokvelRepository)
final stokvelRepositoryProvider = StokvelRepositoryProvider._();

/// Reads stokvels and cycles. Implementation: [ApiStokvelRepository]; or
/// [FakeStokvelRepository], with Soweto Teachers slow, as it is on Lerato's
/// data bundle, wrapped in [FlakyStokvelRepository] when [fakeFailEvery] is
/// set.

final class StokvelRepositoryProvider
    extends
        $FunctionalProvider<
          StokvelRepository,
          StokvelRepository,
          StokvelRepository
        >
    with $Provider<StokvelRepository> {
  /// Reads stokvels and cycles. Implementation: [ApiStokvelRepository]; or
  /// [FakeStokvelRepository], with Soweto Teachers slow, as it is on Lerato's
  /// data bundle, wrapped in [FlakyStokvelRepository] when [fakeFailEvery] is
  /// set.
  StokvelRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stokvelRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stokvelRepositoryHash();

  @$internal
  @override
  $ProviderElement<StokvelRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StokvelRepository create(Ref ref) {
    return stokvelRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StokvelRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StokvelRepository>(value),
    );
  }
}

String _$stokvelRepositoryHash() => r'ab446f1391288939bb0822254531d64a63cb5fa6';

/// Reads the activity feed. Implementation: [ApiActivityRepository]; or
/// [FakeActivityRepository], wrapped in [FlakyActivityRepository] when
/// [fakeFailEvery] is set.

@ProviderFor(activityRepository)
final activityRepositoryProvider = ActivityRepositoryProvider._();

/// Reads the activity feed. Implementation: [ApiActivityRepository]; or
/// [FakeActivityRepository], wrapped in [FlakyActivityRepository] when
/// [fakeFailEvery] is set.

final class ActivityRepositoryProvider
    extends
        $FunctionalProvider<
          ActivityRepository,
          ActivityRepository,
          ActivityRepository
        >
    with $Provider<ActivityRepository> {
  /// Reads the activity feed. Implementation: [ApiActivityRepository]; or
  /// [FakeActivityRepository], wrapped in [FlakyActivityRepository] when
  /// [fakeFailEvery] is set.
  ActivityRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityRepositoryHash();

  @$internal
  @override
  $ProviderElement<ActivityRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ActivityRepository create(Ref ref) {
    return activityRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivityRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivityRepository>(value),
    );
  }
}

String _$activityRepositoryHash() =>
    r'00ce49b7a78b65c32a26e5f2945d5f48d0b5763f';

/// Reads and accepts invites. Implementation: [ApiInviteRepository], or
/// [FakeInviteRepository].

@ProviderFor(inviteRepository)
final inviteRepositoryProvider = InviteRepositoryProvider._();

/// Reads and accepts invites. Implementation: [ApiInviteRepository], or
/// [FakeInviteRepository].

final class InviteRepositoryProvider
    extends
        $FunctionalProvider<
          InviteRepository,
          InviteRepository,
          InviteRepository
        >
    with $Provider<InviteRepository> {
  /// Reads and accepts invites. Implementation: [ApiInviteRepository], or
  /// [FakeInviteRepository].
  InviteRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inviteRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inviteRepositoryHash();

  @$internal
  @override
  $ProviderElement<InviteRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  InviteRepository create(Ref ref) {
    return inviteRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InviteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InviteRepository>(value),
    );
  }
}

String _$inviteRepositoryHash() => r'aee17ca50210401ff50350d7945965f5be6d28a3';

/// Reads a cycle's payout order. Implementation: [ApiPayoutRepository]; or
/// [FakePayoutRepository], wrapped in [FlakyPayoutRepository] when
/// [fakeFailEvery] is set.

@ProviderFor(payoutRepository)
final payoutRepositoryProvider = PayoutRepositoryProvider._();

/// Reads a cycle's payout order. Implementation: [ApiPayoutRepository]; or
/// [FakePayoutRepository], wrapped in [FlakyPayoutRepository] when
/// [fakeFailEvery] is set.

final class PayoutRepositoryProvider
    extends
        $FunctionalProvider<
          PayoutRepository,
          PayoutRepository,
          PayoutRepository
        >
    with $Provider<PayoutRepository> {
  /// Reads a cycle's payout order. Implementation: [ApiPayoutRepository]; or
  /// [FakePayoutRepository], wrapped in [FlakyPayoutRepository] when
  /// [fakeFailEvery] is set.
  PayoutRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'payoutRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$payoutRepositoryHash();

  @$internal
  @override
  $ProviderElement<PayoutRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PayoutRepository create(Ref ref) {
    return payoutRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PayoutRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PayoutRepository>(value),
    );
  }
}

String _$payoutRepositoryHash() => r'd80e6a695b3c6970cfad11e81764275c04902dd7';
