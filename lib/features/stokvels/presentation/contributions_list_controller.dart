import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/stokvels/domain/contributions_list.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';

part 'contributions_list_controller.g.dart';

/// A stokvel's cycles, for the cycle filter. Lifetime: autoDispose.
@riverpod
Future<List<CycleOption>> contributionCycles(Ref ref, String stokvelId) async =>
    (await ref.watch(contributionsRepositoryProvider).fetchCycles(stokvelId))
        .valueOrThrow;

/// A stokvel's members, for the member filter. Lifetime: autoDispose.
@riverpod
Future<List<MemberOption>> contributionMembers(
  Ref ref,
  String stokvelId,
) async =>
    (await ref.watch(contributionsRepositoryProvider).fetchMembers(stokvelId))
        .valueOrThrow;

/// The list's six states, each with its own words on screen.
enum ListPhase {
  /// The first page is loading, with nothing to show yet.
  firstLoading,

  /// The cycle has no contributions at all.
  nothingAtAll,

  /// Nothing matches the filters (with a way to clear them).
  nothingForFilters,

  /// The first page failed.
  firstFailed,

  /// A later page failed: the rows so far stay, with Try again below.
  moreFailed,

  /// Rows, and possibly more pages to come.
  rows,

  /// Every row is here.
  end,
}

/// Where the contributions list is.
@immutable
class ContributionsListState {
  /// Creates the state.
  const new({
    this.filter,
    this.rows = const [],
    this.nextPageToken,
    this.loading = false,
    this.reachedEnd = false,
    this.failure,
  });

  /// What is shown; `null` until the cycles are known.
  final ContributionFilter? filter;

  /// The rows so far.
  final List<Contribution> rows;

  /// The next page's token.
  final String? nextPageToken;

  /// Whether a request is in flight (only ever one).
  final bool loading;

  /// Whether the last page has arrived.
  final bool reachedEnd;

  /// Why the last request failed.
  final Failure? failure;

  /// Which of the six states this is.
  ListPhase get phase {
    if (rows.isEmpty) {
      if (failure != null) return ListPhase.firstFailed;
      if (!reachedEnd) return ListPhase.firstLoading;
      return filter?.isNarrowed ?? false
          ? ListPhase.nothingForFilters
          : ListPhase.nothingAtAll;
    }
    if (failure != null) return ListPhase.moreFailed;
    return reachedEnd ? ListPhase.end : ListPhase.rows;
  }
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
@riverpod
class ContributionsList extends _$ContributionsList {
  /// Rows per page.
  static const pageSize = 20;

  int _generation = 0;

  @override
  ContributionsListState build(String stokvelId) {
    ref.watch(contributionsRepositoryProvider);
    unawaited(Future.microtask(_start));
    return const ContributionsListState();
  }

  Future<void> _start() async {
    try {
      final cycles = await ref.read(
        contributionCyclesProvider(stokvelId).future,
      );
      if (!ref.mounted || state.filter != null) return;
      if (cycles.isEmpty) {
        state = const ContributionsListState(reachedEnd: true);
        return;
      }
      await setFilter(ContributionFilter(cycleId: cycles.first.id));
    } on Object catch (error) {
      if (ref.mounted) {
        state = ContributionsListState(failure: failureOf(error));
      }
    }
  }

  /// Shows [filter], from its first page.
  Future<void> setFilter(ContributionFilter filter) {
    _generation++;
    state = ContributionsListState(filter: filter, loading: true);
    return _load(keepRows: false);
  }

  /// Starts again from page 1, the old rows on screen until the new ones
  /// arrive.
  Future<void> refresh() async {
    final filter = state.filter;
    if (filter == null) return await _start();
    _generation++;
    state = ContributionsListState(
      filter: filter,
      rows: state.rows,
      loading: true,
    );
    await _load(keepRows: true);
  }

  /// The next page, if there is one and nothing is in flight.
  Future<void> loadMore() async {
    if (state.loading || state.reachedEnd || state.filter == null) return;
    state = ContributionsListState(
      filter: state.filter,
      rows: state.rows,
      nextPageToken: state.nextPageToken,
      loading: true,
    );
    await _load(keepRows: true, token: state.nextPageToken);
  }

  Future<void> _load({required bool keepRows, String? token}) async {
    final generation = _generation;
    final filter = state.filter!;
    final result = await ref
        .read(contributionsRepositoryProvider)
        .fetchPage(stokvelId, filter, pageToken: token, pageSize: pageSize);
    if (!ref.mounted || generation != _generation) return;
    switch (result) {
      case Ok(value: final page):
        final rows = token == null
            ? page.items
            : [...state.rows, ...page.items];
        state = ContributionsListState(
          filter: filter,
          rows: rows,
          nextPageToken: page.nextPageToken,
          reachedEnd: page.nextPageToken == null,
        );
      case Err(:final failure):
        state = ContributionsListState(
          filter: filter,
          rows: keepRows ? state.rows : const [],
          nextPageToken: state.nextPageToken,
          failure: failure,
        );
    }
  }

  /// Asks again after a failure: the first page, or the page that failed.
  Future<void> retry() => state.rows.isEmpty
      ? (state.filter == null ? _start() : refresh())
      : loadMore();
}
