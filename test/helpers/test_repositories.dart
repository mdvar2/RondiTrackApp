import 'dart:async';

import 'package:ronditrack_app/features/home/domain/home_entry.dart';
import 'package:ronditrack_app/features/home/domain/home_repository.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';

/// A Home repository whose answers a test hands out one call at a time.
class ScriptedHomeRepository implements HomeRepository {
  /// Each call takes the next answer. A [Completer] answer stays pending
  /// until the test completes it; an [Exception] answer throws.
  new(this.answers);

  /// The answers, in call order.
  final List<Object> answers;

  /// How many times Home was fetched.
  int calls = 0;

  @override
  Future<List<HomeEntry>> fetchHome() {
    final answer = answers[calls < answers.length ? calls : answers.length - 1];
    calls++;
    return switch (answer) {
      final Completer<List<HomeEntry>> completer => completer.future,
      final List<HomeEntry> entries => Future.value(entries),
      final Exception error => Future.error(error),
      _ => throw StateError('Unexpected answer $answer'),
    };
  }
}

/// A stokvel repository that counts calls per id and can fail.
class CountingStokvelRepository implements StokvelRepository {
  /// Wraps [inner]. The first [failures] calls throw.
  new(this.inner, {this.failures = 0});

  /// The repository that answers.
  final StokvelRepository inner;

  /// How many calls throw before calls go through.
  int failures;

  /// Calls per stokvel id.
  final Map<String, int> calls = {};

  @override
  Future<StokvelDetail> fetchStokvel(String stokvelId) async {
    calls.update(stokvelId, (count) => count + 1, ifAbsent: () => 1);
    if (failures > 0) {
      failures--;
      throw Exception('offline');
    }
    return await inner.fetchStokvel(stokvelId);
  }

  @override
  Future<CycleDetail> fetchCycle(String stokvelId, String cycleId) =>
      inner.fetchCycle(stokvelId, cycleId);
}

/// A stokvel repository that never answers, for the loading state.
class PendingStokvelRepository implements StokvelRepository {
  @override
  Future<StokvelDetail> fetchStokvel(String stokvelId) =>
      Completer<StokvelDetail>().future;

  @override
  Future<CycleDetail> fetchCycle(String stokvelId, String cycleId) =>
      Completer<CycleDetail>().future;
}
