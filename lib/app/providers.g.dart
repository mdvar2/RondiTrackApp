// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Who is signed in. Until Week 11 adds sign-in, a seed persona (Lerato,
/// unless `--dart-define=FAKE_PERSONA=` picks another in `main`).

@ProviderFor(signedInUserId)
final signedInUserIdProvider = SignedInUserIdProvider._();

/// Who is signed in. Until Week 11 adds sign-in, a seed persona (Lerato,
/// unless `--dart-define=FAKE_PERSONA=` picks another in `main`).

final class SignedInUserIdProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Who is signed in. Until Week 11 adds sign-in, a seed persona (Lerato,
  /// unless `--dart-define=FAKE_PERSONA=` picks another in `main`).
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
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return signedInUserId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$signedInUserIdHash() => r'bd40bb8de53e36e6a45d45e9f6863e84ddf91b09';

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

String _$homeRepositoryHash() => r'c4d7f2275de044acfbd91ae5aae78ea615e40f23';

/// Reads one stokvel. Implementation: [FakeStokvelRepository], with Soweto
/// Teachers slow, as it is on Lerato's data bundle; wrapped in
/// [FlakyStokvelRepository] when [fakeFailEvery] is set.

@ProviderFor(stokvelRepository)
final stokvelRepositoryProvider = StokvelRepositoryProvider._();

/// Reads one stokvel. Implementation: [FakeStokvelRepository], with Soweto
/// Teachers slow, as it is on Lerato's data bundle; wrapped in
/// [FlakyStokvelRepository] when [fakeFailEvery] is set.

final class StokvelRepositoryProvider
    extends
        $FunctionalProvider<
          StokvelRepository,
          StokvelRepository,
          StokvelRepository
        >
    with $Provider<StokvelRepository> {
  /// Reads one stokvel. Implementation: [FakeStokvelRepository], with Soweto
  /// Teachers slow, as it is on Lerato's data bundle; wrapped in
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

String _$stokvelRepositoryHash() => r'aace4701f1e5ed78a20fad70a1b6d7af2d2859b1';
