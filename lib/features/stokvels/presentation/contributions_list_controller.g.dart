// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contributions_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A stokvel's cycles, for the cycle filter. Lifetime: autoDispose.

@ProviderFor(contributionCycles)
final contributionCyclesProvider = ContributionCyclesFamily._();

/// A stokvel's cycles, for the cycle filter. Lifetime: autoDispose.

final class ContributionCyclesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CycleOption>>,
          List<CycleOption>,
          FutureOr<List<CycleOption>>
        >
    with
        $FutureModifier<List<CycleOption>>,
        $FutureProvider<List<CycleOption>> {
  /// A stokvel's cycles, for the cycle filter. Lifetime: autoDispose.
  ContributionCyclesProvider._({
    required ContributionCyclesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'contributionCyclesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$contributionCyclesHash();

  @override
  String toString() {
    return r'contributionCyclesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CycleOption>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CycleOption>> create(Ref ref) {
    final argument = this.argument as String;
    return contributionCycles(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ContributionCyclesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$contributionCyclesHash() =>
    r'5acdf7ef1054f92f2281408f67852c4b532156e6';

/// A stokvel's cycles, for the cycle filter. Lifetime: autoDispose.

final class ContributionCyclesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CycleOption>>, String> {
  ContributionCyclesFamily._()
    : super(
        retry: null,
        name: r'contributionCyclesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// A stokvel's cycles, for the cycle filter. Lifetime: autoDispose.

  ContributionCyclesProvider call(String stokvelId) =>
      ContributionCyclesProvider._(argument: stokvelId, from: this);

  @override
  String toString() => r'contributionCyclesProvider';
}

/// A stokvel's members, for the member filter. Lifetime: autoDispose.

@ProviderFor(contributionMembers)
final contributionMembersProvider = ContributionMembersFamily._();

/// A stokvel's members, for the member filter. Lifetime: autoDispose.

final class ContributionMembersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MemberOption>>,
          List<MemberOption>,
          FutureOr<List<MemberOption>>
        >
    with
        $FutureModifier<List<MemberOption>>,
        $FutureProvider<List<MemberOption>> {
  /// A stokvel's members, for the member filter. Lifetime: autoDispose.
  ContributionMembersProvider._({
    required ContributionMembersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'contributionMembersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$contributionMembersHash();

  @override
  String toString() {
    return r'contributionMembersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<MemberOption>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MemberOption>> create(Ref ref) {
    final argument = this.argument as String;
    return contributionMembers(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ContributionMembersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$contributionMembersHash() =>
    r'81cfff75da2bbe81c1a5892ca5cb70dd279de72e';

/// A stokvel's members, for the member filter. Lifetime: autoDispose.

final class ContributionMembersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<MemberOption>>, String> {
  ContributionMembersFamily._()
    : super(
        retry: null,
        name: r'contributionMembersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// A stokvel's members, for the member filter. Lifetime: autoDispose.

  ContributionMembersProvider call(String stokvelId) =>
      ContributionMembersProvider._(argument: stokvelId, from: this);

  @override
  String toString() => r'contributionMembersProvider';
}

/// A stokvel's contributions, a page at a time, paged by hand.
///
/// * One request in flight at a time.
/// * Changing any filter starts again from the first page, with no token.
/// * Pull to refresh starts again from page 1, keeping the old rows on
///   screen until the new ones arrive.
/// * A page that answers for a filter no longer shown is dropped.
///
/// Lifetime: autoDispose, keyed by stokvel.

@ProviderFor(ContributionsList)
final contributionsListProvider = ContributionsListFamily._();

/// A stokvel's contributions, a page at a time, paged by hand.
///
/// * One request in flight at a time.
/// * Changing any filter starts again from the first page, with no token.
/// * Pull to refresh starts again from page 1, keeping the old rows on
///   screen until the new ones arrive.
/// * A page that answers for a filter no longer shown is dropped.
///
/// Lifetime: autoDispose, keyed by stokvel.
final class ContributionsListProvider
    extends $NotifierProvider<ContributionsList, ContributionsListState> {
  /// A stokvel's contributions, a page at a time, paged by hand.
  ///
  /// * One request in flight at a time.
  /// * Changing any filter starts again from the first page, with no token.
  /// * Pull to refresh starts again from page 1, keeping the old rows on
  ///   screen until the new ones arrive.
  /// * A page that answers for a filter no longer shown is dropped.
  ///
  /// Lifetime: autoDispose, keyed by stokvel.
  ContributionsListProvider._({
    required ContributionsListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'contributionsListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$contributionsListHash();

  @override
  String toString() {
    return r'contributionsListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ContributionsList create() => ContributionsList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContributionsListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContributionsListState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ContributionsListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$contributionsListHash() => r'25d7575c522863c2e55197b3c19b75475921c2eb';

/// A stokvel's contributions, a page at a time, paged by hand.
///
/// * One request in flight at a time.
/// * Changing any filter starts again from the first page, with no token.
/// * Pull to refresh starts again from page 1, keeping the old rows on
///   screen until the new ones arrive.
/// * A page that answers for a filter no longer shown is dropped.
///
/// Lifetime: autoDispose, keyed by stokvel.

final class ContributionsListFamily extends $Family
    with
        $ClassFamilyOverride<
          ContributionsList,
          ContributionsListState,
          ContributionsListState,
          ContributionsListState,
          String
        > {
  ContributionsListFamily._()
    : super(
        retry: null,
        name: r'contributionsListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// A stokvel's contributions, a page at a time, paged by hand.
  ///
  /// * One request in flight at a time.
  /// * Changing any filter starts again from the first page, with no token.
  /// * Pull to refresh starts again from page 1, keeping the old rows on
  ///   screen until the new ones arrive.
  /// * A page that answers for a filter no longer shown is dropped.
  ///
  /// Lifetime: autoDispose, keyed by stokvel.

  ContributionsListProvider call(String stokvelId) =>
      ContributionsListProvider._(argument: stokvelId, from: this);

  @override
  String toString() => r'contributionsListProvider';
}

/// A stokvel's contributions, a page at a time, paged by hand.
///
/// * One request in flight at a time.
/// * Changing any filter starts again from the first page, with no token.
/// * Pull to refresh starts again from page 1, keeping the old rows on
///   screen until the new ones arrive.
/// * A page that answers for a filter no longer shown is dropped.
///
/// Lifetime: autoDispose, keyed by stokvel.

abstract class _$ContributionsList extends $Notifier<ContributionsListState> {
  late final _$args = ref.$arg as String;
  String get stokvelId => _$args;

  ContributionsListState build(String stokvelId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<ContributionsListState, ContributionsListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ContributionsListState, ContributionsListState>,
              ContributionsListState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
