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

/// How often the fakes fail: `0` never (the default), `3` the first call and
/// every third after it. Only the dev flavour sets it, from
/// `--dart-define=FAKE_FAIL_EVERY=` in `main`. Week 11 deletes it.

@ProviderFor(fakeFailEvery)
final fakeFailEveryProvider = FakeFailEveryProvider._();

/// How often the fakes fail: `0` never (the default), `3` the first call and
/// every third after it. Only the dev flavour sets it, from
/// `--dart-define=FAKE_FAIL_EVERY=` in `main`. Week 11 deletes it.

final class FakeFailEveryProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// How often the fakes fail: `0` never (the default), `3` the first call and
  /// every third after it. Only the dev flavour sets it, from
  /// `--dart-define=FAKE_FAIL_EVERY=` in `main`. Week 11 deletes it.
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
/// Week 11 deletes it.

@ProviderFor(fakeDelay)
final fakeDelayProvider = FakeDelayProvider._();

/// The fakes' pretend network delay. Router-level tests set
/// [Duration.zero], which also drops Soweto Teachers' extra slowness.
/// Week 11 deletes it.

final class FakeDelayProvider
    extends $FunctionalProvider<Duration, Duration, Duration>
    with $Provider<Duration> {
  /// The fakes' pretend network delay. Router-level tests set
  /// [Duration.zero], which also drops Soweto Teachers' extra slowness.
  /// Week 11 deletes it.
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
/// test). Week 11 deletes it.

@ProviderFor(fakeStokvels)
final fakeStokvelsProvider = FakeStokvelsProvider._();

/// The fakes' changeable copy of the seed: joining an invite adds a
/// membership here, and every fake reads it. One per app session (and per
/// test). Week 11 deletes it.

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
  /// test). Week 11 deletes it.
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

/// The accounts the sign-in screen offers to fill in, so a tester needn't
/// type an email. Week 11 makes this empty.

@ProviderFor(demoAccounts)
final demoAccountsProvider = DemoAccountsProvider._();

/// The accounts the sign-in screen offers to fill in, so a tester needn't
/// type an email. Week 11 makes this empty.

final class DemoAccountsProvider
    extends
        $FunctionalProvider<
          List<({String email, String name})>,
          List<({String email, String name})>,
          List<({String email, String name})>
        >
    with $Provider<List<({String email, String name})>> {
  /// The accounts the sign-in screen offers to fill in, so a tester needn't
  /// type an email. Week 11 makes this empty.
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

/// Signs in and out. Implementation: [FakeAuthRepository].

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

/// Signs in and out. Implementation: [FakeAuthRepository].

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// Signs in and out. Implementation: [FakeAuthRepository].
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

String _$authRepositoryHash() => r'fdf69d26fa7dac0c40337cd69c692e55876abf7e';

/// Reads Home. Implementation: [FakeHomeRepository], wrapped in
/// [FlakyHomeRepository] when [fakeFailEvery] is set.

@ProviderFor(homeRepository)
final homeRepositoryProvider = HomeRepositoryProvider._();

/// Reads Home. Implementation: [FakeHomeRepository], wrapped in
/// [FlakyHomeRepository] when [fakeFailEvery] is set.

final class HomeRepositoryProvider
    extends $FunctionalProvider<HomeRepository, HomeRepository, HomeRepository>
    with $Provider<HomeRepository> {
  /// Reads Home. Implementation: [FakeHomeRepository], wrapped in
  /// [FlakyHomeRepository] when [fakeFailEvery] is set.
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

String _$homeRepositoryHash() => r'c173fd592539f781a8c9c85d46f86b976701896b';

/// Reads stokvels and cycles. Implementation: [FakeStokvelRepository], with
/// Soweto Teachers slow, as it is on Lerato's data bundle; wrapped in
/// [FlakyStokvelRepository] when [fakeFailEvery] is set.

@ProviderFor(stokvelRepository)
final stokvelRepositoryProvider = StokvelRepositoryProvider._();

/// Reads stokvels and cycles. Implementation: [FakeStokvelRepository], with
/// Soweto Teachers slow, as it is on Lerato's data bundle; wrapped in
/// [FlakyStokvelRepository] when [fakeFailEvery] is set.

final class StokvelRepositoryProvider
    extends
        $FunctionalProvider<
          StokvelRepository,
          StokvelRepository,
          StokvelRepository
        >
    with $Provider<StokvelRepository> {
  /// Reads stokvels and cycles. Implementation: [FakeStokvelRepository], with
  /// Soweto Teachers slow, as it is on Lerato's data bundle; wrapped in
  /// [FlakyStokvelRepository] when [fakeFailEvery] is set.
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

String _$stokvelRepositoryHash() => r'900de1268c7e8310934dcd9d8c649de04656d4ff';

/// Reads the activity feed. Implementation: [FakeActivityRepository],
/// wrapped in [FlakyActivityRepository] when [fakeFailEvery] is set.

@ProviderFor(activityRepository)
final activityRepositoryProvider = ActivityRepositoryProvider._();

/// Reads the activity feed. Implementation: [FakeActivityRepository],
/// wrapped in [FlakyActivityRepository] when [fakeFailEvery] is set.

final class ActivityRepositoryProvider
    extends
        $FunctionalProvider<
          ActivityRepository,
          ActivityRepository,
          ActivityRepository
        >
    with $Provider<ActivityRepository> {
  /// Reads the activity feed. Implementation: [FakeActivityRepository],
  /// wrapped in [FlakyActivityRepository] when [fakeFailEvery] is set.
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
    r'2cfbdd0652ece13e066fdf63eff5a0f2b43a1549';

/// Reads and accepts invites. Implementation: [FakeInviteRepository].

@ProviderFor(inviteRepository)
final inviteRepositoryProvider = InviteRepositoryProvider._();

/// Reads and accepts invites. Implementation: [FakeInviteRepository].

final class InviteRepositoryProvider
    extends
        $FunctionalProvider<
          InviteRepository,
          InviteRepository,
          InviteRepository
        >
    with $Provider<InviteRepository> {
  /// Reads and accepts invites. Implementation: [FakeInviteRepository].
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

String _$inviteRepositoryHash() => r'4ed8aecfabb04bffaf5878a8f52d7a34d9a65e72';
