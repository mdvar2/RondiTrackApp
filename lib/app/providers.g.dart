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

String _$signedInUserIdHash() => r'0cef776003950fafefe8a4a22eacf0484b19ca69';

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

/// Where the refresh token is kept: `flutter_secure_storage`. Tests
/// override it with an [InMemoryRefreshTokenStore].

@ProviderFor(refreshTokenStore)
final refreshTokenStoreProvider = RefreshTokenStoreProvider._();

/// Where the refresh token is kept: `flutter_secure_storage`. Tests
/// override it with an [InMemoryRefreshTokenStore].

final class RefreshTokenStoreProvider
    extends
        $FunctionalProvider<
          RefreshTokenStore,
          RefreshTokenStore,
          RefreshTokenStore
        >
    with $Provider<RefreshTokenStore> {
  /// Where the refresh token is kept: `flutter_secure_storage`. Tests
  /// override it with an [InMemoryRefreshTokenStore].
  RefreshTokenStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refreshTokenStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refreshTokenStoreHash();

  @$internal
  @override
  $ProviderElement<RefreshTokenStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RefreshTokenStore create(Ref ref) {
    return refreshTokenStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RefreshTokenStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RefreshTokenStore>(value),
    );
  }
}

String _$refreshTokenStoreHash() => r'28b9e7947e88cc109dd4b0e520edceff19688e99';

/// What carries the requests: Dio's own (`null`) in the app. Tests put a
/// fake server here, under both clients.

@ProviderFor(httpAdapter)
final httpAdapterProvider = HttpAdapterProvider._();

/// What carries the requests: Dio's own (`null`) in the app. Tests put a
/// fake server here, under both clients.

final class HttpAdapterProvider
    extends
        $FunctionalProvider<
          HttpClientAdapter?,
          HttpClientAdapter?,
          HttpClientAdapter?
        >
    with $Provider<HttpClientAdapter?> {
  /// What carries the requests: Dio's own (`null`) in the app. Tests put a
  /// fake server here, under both clients.
  HttpAdapterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'httpAdapterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$httpAdapterHash();

  @$internal
  @override
  $ProviderElement<HttpClientAdapter?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HttpClientAdapter? create(Ref ref) {
    return httpAdapter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HttpClientAdapter? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HttpClientAdapter?>(value),
    );
  }
}

String _$httpAdapterHash() => r'8a40f9ca9de79fe420fa6db688c592e7b3e855b8';

/// The bare client: no session. The auth calls and the session
/// interceptor's one retry go through it (README "The session").

@ProviderFor(bareClient)
final bareClientProvider = BareClientProvider._();

/// The bare client: no session. The auth calls and the session
/// interceptor's one retry go through it (README "The session").

final class BareClientProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// The bare client: no session. The auth calls and the session
  /// interceptor's one retry go through it (README "The session").
  BareClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bareClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bareClientHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return bareClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$bareClientHash() => r'49f960276079d9c360a2f4ce937ad43d1a108597';

/// Sign-in, register, refresh and logout, on the bare client, reading the
/// refresh cookie by the name in the flavour's config.

@ProviderFor(authCalls)
final authCallsProvider = AuthCallsProvider._();

/// Sign-in, register, refresh and logout, on the bare client, reading the
/// refresh cookie by the name in the flavour's config.

final class AuthCallsProvider
    extends $FunctionalProvider<AuthCalls, AuthCalls, AuthCalls>
    with $Provider<AuthCalls> {
  /// Sign-in, register, refresh and logout, on the bare client, reading the
  /// refresh cookie by the name in the flavour's config.
  AuthCallsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authCallsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authCallsHash();

  @$internal
  @override
  $ProviderElement<AuthCalls> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthCalls create(Ref ref) {
    return authCalls(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthCalls value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthCalls>(value),
    );
  }
}

String _$authCallsHash() => r'5e8527851763d859dde5d895f4211e54fc05ebeb';

/// The session: the access token in memory, the refresh token in
/// [refreshTokenStore], and the one refresh that may be running. Only the
/// refresh's own `401` ends it.

@ProviderFor(session)
final sessionProvider = SessionProvider._();

/// The session: the access token in memory, the refresh token in
/// [refreshTokenStore], and the one refresh that may be running. Only the
/// refresh's own `401` ends it.

final class SessionProvider
    extends $FunctionalProvider<Session, Session, Session>
    with $Provider<Session> {
  /// The session: the access token in memory, the refresh token in
  /// [refreshTokenStore], and the one refresh that may be running. Only the
  /// refresh's own `401` ends it.
  SessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionHash();

  @$internal
  @override
  $ProviderElement<Session> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Session create(Ref ref) {
    return session(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Session value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Session>(value),
    );
  }
}

String _$sessionHash() => r'39c94cc477e526cf94da448d912e5016f277bdc9';

/// The client every repository uses, for the app's whole life: its base
/// URL from the flavour's config, never typed in code, and the session
/// interceptor, which retries on [bareClient].

@ProviderFor(apiClient)
final apiClientProvider = ApiClientProvider._();

/// The client every repository uses, for the app's whole life: its base
/// URL from the flavour's config, never typed in code, and the session
/// interceptor, which retries on [bareClient].

final class ApiClientProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// The client every repository uses, for the app's whole life: its base
  /// URL from the flavour's config, never typed in code, and the session
  /// interceptor, which retries on [bareClient].
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

String _$apiClientHash() => r'1fc85823184b91e2fef9c1e5a5b5b27691f4cf34';

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
/// Development seed (API PR #16) with the same emails. Choosing one fills
/// in the email; the password is typed.

@ProviderFor(demoAccounts)
final demoAccountsProvider = DemoAccountsProvider._();

/// The accounts the dev build's sign-in screen and persona switcher offer:
/// the three seed personas, which exist in the fakes and in the API's
/// Development seed (API PR #16) with the same emails. Choosing one fills
/// in the email; the password is typed.

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
  /// Development seed (API PR #16) with the same emails. Choosing one fills
  /// in the email; the password is typed.
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

/// Signs in, registers, restores and signs out. Implementation:
/// [ApiAuthRepository], or [FakeAuthRepository].

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

/// Signs in, registers, restores and signs out. Implementation:
/// [ApiAuthRepository], or [FakeAuthRepository].

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// Signs in, registers, restores and signs out. Implementation:
  /// [ApiAuthRepository], or [FakeAuthRepository].
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

String _$authRepositoryHash() => r'c61adff5e9584439156c5c1eccb02e37a7fe95c8';

/// The phone's database: Home, stokvels and cycles as last seen, who was
/// signed in, and the payment outbox. Tests override it with an in-memory
/// one.

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// The phone's database: Home, stokvels and cycles as last seen, who was
/// signed in, and the payment outbox. Tests override it with an in-memory
/// one.

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// The phone's database: Home, stokvels and cycles as last seen, who was
  /// signed in, and the payment outbox. Tests override it with an in-memory
  /// one.
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'742ceb6fe06dae282a737a0b1b2766b29e27599d';

/// Sends a payment to the API, or to the fakes. It follows who is signed
/// in, like every repository.

@ProviderFor(paymentSender)
final paymentSenderProvider = PaymentSenderProvider._();

/// Sends a payment to the API, or to the fakes. It follows who is signed
/// in, like every repository.

final class PaymentSenderProvider
    extends $FunctionalProvider<PaymentSender, PaymentSender, PaymentSender>
    with $Provider<PaymentSender> {
  /// Sends a payment to the API, or to the fakes. It follows who is signed
  /// in, like every repository.
  PaymentSenderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentSenderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentSenderHash();

  @$internal
  @override
  $ProviderElement<PaymentSender> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PaymentSender create(Ref ref) {
    return paymentSender(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaymentSender value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaymentSender>(value),
    );
  }
}

String _$paymentSenderHash() => r'bdb1df7ad9312d4f1f0633f71e1f9a0cc9feb69b';

/// Makes an `Idempotency-Key`: a v4 UUID from the `uuid` package (a
/// cryptographic random source). Called only when a payment is recorded.

@ProviderFor(idempotencyKeys)
final idempotencyKeysProvider = IdempotencyKeysProvider._();

/// Makes an `Idempotency-Key`: a v4 UUID from the `uuid` package (a
/// cryptographic random source). Called only when a payment is recorded.

final class IdempotencyKeysProvider
    extends
        $FunctionalProvider<
          String Function(),
          String Function(),
          String Function()
        >
    with $Provider<String Function()> {
  /// Makes an `Idempotency-Key`: a v4 UUID from the `uuid` package (a
  /// cryptographic random source). Called only when a payment is recorded.
  IdempotencyKeysProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'idempotencyKeysProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$idempotencyKeysHash();

  @$internal
  @override
  $ProviderElement<String Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  String Function() create(Ref ref) {
    return idempotencyKeys(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String Function()>(value),
    );
  }
}

String _$idempotencyKeysHash() => r'bea198af32d3fb489397f820c90a331304bd6f52';

/// The payment outbox, in the database (README "Offline").

@ProviderFor(paymentOutbox)
final paymentOutboxProvider = PaymentOutboxProvider._();

/// The payment outbox, in the database (README "Offline").

final class PaymentOutboxProvider
    extends $FunctionalProvider<PaymentOutbox, PaymentOutbox, PaymentOutbox>
    with $Provider<PaymentOutbox> {
  /// The payment outbox, in the database (README "Offline").
  PaymentOutboxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentOutboxProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentOutboxHash();

  @$internal
  @override
  $ProviderElement<PaymentOutbox> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PaymentOutbox create(Ref ref) {
    return paymentOutbox(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaymentOutbox value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaymentOutbox>(value),
    );
  }
}

String _$paymentOutboxHash() => r'698f6ca4a07840b5aaea0a00833006cbede130a3';

/// The contributions list's data. Implementation:
/// [ApiContributionsRepository], or [FakeContributionsRepository].

@ProviderFor(contributionsRepository)
final contributionsRepositoryProvider = ContributionsRepositoryProvider._();

/// The contributions list's data. Implementation:
/// [ApiContributionsRepository], or [FakeContributionsRepository].

final class ContributionsRepositoryProvider
    extends
        $FunctionalProvider<
          ContributionsRepository,
          ContributionsRepository,
          ContributionsRepository
        >
    with $Provider<ContributionsRepository> {
  /// The contributions list's data. Implementation:
  /// [ApiContributionsRepository], or [FakeContributionsRepository].
  ContributionsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contributionsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contributionsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ContributionsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ContributionsRepository create(Ref ref) {
    return contributionsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContributionsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContributionsRepository>(value),
    );
  }
}

String _$contributionsRepositoryHash() =>
    r'6c8005f425d93a37dc3320eb6fcbf900a5169a24';

/// Creates stokvels and edits cycles. Implementation: [ApiStokvelEditor],
/// or [FakeStokvelEditor].

@ProviderFor(stokvelEditor)
final stokvelEditorProvider = StokvelEditorProvider._();

/// Creates stokvels and edits cycles. Implementation: [ApiStokvelEditor],
/// or [FakeStokvelEditor].

final class StokvelEditorProvider
    extends $FunctionalProvider<StokvelEditor, StokvelEditor, StokvelEditor>
    with $Provider<StokvelEditor> {
  /// Creates stokvels and edits cycles. Implementation: [ApiStokvelEditor],
  /// or [FakeStokvelEditor].
  StokvelEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stokvelEditorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stokvelEditorHash();

  @$internal
  @override
  $ProviderElement<StokvelEditor> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StokvelEditor create(Ref ref) {
    return stokvelEditor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StokvelEditor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StokvelEditor>(value),
    );
  }
}

String _$stokvelEditorHash() => r'8c455655ed691c07ca752b967d2409ac8aa6927d';

/// Who was last signed in on this phone, kept with their cached data.

@ProviderFor(lastUser)
final lastUserProvider = LastUserProvider._();

/// Who was last signed in on this phone, kept with their cached data.

final class LastUserProvider
    extends $FunctionalProvider<LastUser, LastUser, LastUser>
    with $Provider<LastUser> {
  /// Who was last signed in on this phone, kept with their cached data.
  LastUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastUserHash();

  @$internal
  @override
  $ProviderElement<LastUser> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LastUser create(Ref ref) {
    return lastUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LastUser value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LastUser>(value),
    );
  }
}

String _$lastUserHash() => r'48970d2675838c7190ba2ebebb69a7d8403903d9';

/// Home as the phone last saw it, refreshed from [homeRepository]. It
/// follows who is signed in, like the repository.

@ProviderFor(homeCache)
final homeCacheProvider = HomeCacheProvider._();

/// Home as the phone last saw it, refreshed from [homeRepository]. It
/// follows who is signed in, like the repository.

final class HomeCacheProvider
    extends
        $FunctionalProvider<
          CachedSource<List<HomeEntry>>,
          CachedSource<List<HomeEntry>>,
          CachedSource<List<HomeEntry>>
        >
    with $Provider<CachedSource<List<HomeEntry>>> {
  /// Home as the phone last saw it, refreshed from [homeRepository]. It
  /// follows who is signed in, like the repository.
  HomeCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeCacheHash();

  @$internal
  @override
  $ProviderElement<CachedSource<List<HomeEntry>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CachedSource<List<HomeEntry>> create(Ref ref) {
    return homeCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CachedSource<List<HomeEntry>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CachedSource<List<HomeEntry>>>(
        value,
      ),
    );
  }
}

String _$homeCacheHash() => r'cfb8d61b8b1592d20e5760f698c6cb1c6a6b77df';

/// One stokvel as the phone last saw it, refreshed from
/// [stokvelRepository].

@ProviderFor(stokvelCache)
final stokvelCacheProvider = StokvelCacheFamily._();

/// One stokvel as the phone last saw it, refreshed from
/// [stokvelRepository].

final class StokvelCacheProvider
    extends
        $FunctionalProvider<
          CachedSource<StokvelDetail>,
          CachedSource<StokvelDetail>,
          CachedSource<StokvelDetail>
        >
    with $Provider<CachedSource<StokvelDetail>> {
  /// One stokvel as the phone last saw it, refreshed from
  /// [stokvelRepository].
  StokvelCacheProvider._({
    required StokvelCacheFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stokvelCacheProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stokvelCacheHash();

  @override
  String toString() {
    return r'stokvelCacheProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<CachedSource<StokvelDetail>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CachedSource<StokvelDetail> create(Ref ref) {
    final argument = this.argument as String;
    return stokvelCache(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CachedSource<StokvelDetail> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CachedSource<StokvelDetail>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StokvelCacheProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stokvelCacheHash() => r'1c49556c996ee5d1206598c489e95fa5daad7356';

/// One stokvel as the phone last saw it, refreshed from
/// [stokvelRepository].

final class StokvelCacheFamily extends $Family
    with $FunctionalFamilyOverride<CachedSource<StokvelDetail>, String> {
  StokvelCacheFamily._()
    : super(
        retry: null,
        name: r'stokvelCacheProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One stokvel as the phone last saw it, refreshed from
  /// [stokvelRepository].

  StokvelCacheProvider call(String stokvelId) =>
      StokvelCacheProvider._(argument: stokvelId, from: this);

  @override
  String toString() => r'stokvelCacheProvider';
}

/// One cycle as the phone last saw it, refreshed from [stokvelRepository].

@ProviderFor(cycleCache)
final cycleCacheProvider = CycleCacheFamily._();

/// One cycle as the phone last saw it, refreshed from [stokvelRepository].

final class CycleCacheProvider
    extends
        $FunctionalProvider<
          CachedSource<CycleDetail>,
          CachedSource<CycleDetail>,
          CachedSource<CycleDetail>
        >
    with $Provider<CachedSource<CycleDetail>> {
  /// One cycle as the phone last saw it, refreshed from [stokvelRepository].
  CycleCacheProvider._({
    required CycleCacheFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'cycleCacheProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cycleCacheHash();

  @override
  String toString() {
    return r'cycleCacheProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<CachedSource<CycleDetail>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CachedSource<CycleDetail> create(Ref ref) {
    final argument = this.argument as (String, String);
    return cycleCache(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CachedSource<CycleDetail> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CachedSource<CycleDetail>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CycleCacheProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cycleCacheHash() => r'4349d833a732a47a6fca59b2ecb323fcdfe5a434';

/// One cycle as the phone last saw it, refreshed from [stokvelRepository].

final class CycleCacheFamily extends $Family
    with
        $FunctionalFamilyOverride<CachedSource<CycleDetail>, (String, String)> {
  CycleCacheFamily._()
    : super(
        retry: null,
        name: r'cycleCacheProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One cycle as the phone last saw it, refreshed from [stokvelRepository].

  CycleCacheProvider call(String stokvelId, String cycleId) =>
      CycleCacheProvider._(argument: (stokvelId, cycleId), from: this);

  @override
  String toString() => r'cycleCacheProvider';
}

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

/// The API's record of this member's phones.

@ProviderFor(deviceRegistry)
final deviceRegistryProvider = DeviceRegistryProvider._();

/// The API's record of this member's phones.

final class DeviceRegistryProvider
    extends $FunctionalProvider<DeviceRegistry, DeviceRegistry, DeviceRegistry>
    with $Provider<DeviceRegistry> {
  /// The API's record of this member's phones.
  DeviceRegistryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceRegistryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceRegistryHash();

  @$internal
  @override
  $ProviderElement<DeviceRegistry> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeviceRegistry create(Ref ref) {
    return deviceRegistry(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceRegistry value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceRegistry>(value),
    );
  }
}

String _$deviceRegistryHash() => r'9d83ad1a7e48d56723c593068f7fa8e670a998e4';
