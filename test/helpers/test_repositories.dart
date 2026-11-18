import 'dart:async';

import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/home/domain/home_entry.dart';
import 'package:ronditrack_app/features/home/domain/home_repository.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_order.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_repository.dart';
import 'package:ronditrack_app/features/stokvels/domain/cycle_close_preview.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';

/// A Home repository whose answers a test hands out one call at a time.
class ScriptedHomeRepository implements HomeRepository {
  /// Each call takes the next answer. A [Completer] answer stays pending
  /// until the test completes it; a [Failure] answer fails with it, and any
  /// other [Exception] stands for a dropped connection ([NoAnswerFailure]).
  new(this.answers);

  /// The answers, in call order.
  final List<Object> answers;

  /// How many times Home was fetched.
  int calls = 0;

  @override
  Future<Result<List<HomeEntry>>> fetchHome() {
    final answer = answers[calls < answers.length ? calls : answers.length - 1];
    calls++;
    return switch (answer) {
      final Completer<List<HomeEntry>> completer => completer.future.then(
        Ok.new,
      ),
      final List<HomeEntry> entries => Future.value(Ok(entries)),
      final Failure failure => Future.value(Err(failure)),
      Exception() => Future.value(const Err(NoAnswerFailure())),
      _ => throw StateError('Unexpected answer $answer'),
    };
  }
}

/// A stokvel repository that counts calls per id and can fail.
class CountingStokvelRepository implements StokvelRepository {
  /// Wraps [inner]. The first [failures] calls get no answer.
  new(this.inner, {this.failures = 0});

  /// The repository that answers.
  final StokvelRepository inner;

  /// How many calls fail before calls go through.
  int failures;

  /// Calls per stokvel id.
  final Map<String, int> calls = {};

  @override
  Future<Result<StokvelDetail>> fetchStokvel(String stokvelId) async {
    calls.update(stokvelId, (count) => count + 1, ifAbsent: () => 1);
    if (failures > 0) {
      failures--;
      return const Err(NoAnswerFailure());
    }
    return await inner.fetchStokvel(stokvelId);
  }

  @override
  Future<Result<CycleDetail>> fetchCycle(String stokvelId, String cycleId) =>
      inner.fetchCycle(stokvelId, cycleId);

  @override
  Future<Result<CycleClosePreview>> fetchClosePreview(
    String stokvelId,
    String cycleId,
  ) => inner.fetchClosePreview(stokvelId, cycleId);
}

/// A stokvel repository that never answers, for the loading state.
class PendingStokvelRepository implements StokvelRepository {
  @override
  Future<Result<StokvelDetail>> fetchStokvel(String stokvelId) =>
      Completer<Result<StokvelDetail>>().future;

  @override
  Future<Result<CycleDetail>> fetchCycle(String stokvelId, String cycleId) =>
      Completer<Result<CycleDetail>>().future;

  @override
  Future<Result<CycleClosePreview>> fetchClosePreview(
    String stokvelId,
    String cycleId,
  ) => Completer<Result<CycleClosePreview>>().future;
}

/// A payout repository whose answers a test sets per cycle id, counting
/// calls. A [Completer] answer stays pending until the test completes it;
/// a [Failure] answer fails with it, and any other [Exception] stands for a
/// dropped connection.
class ScriptedPayoutRepository implements PayoutRepository {
  /// Answers [answers] by cycle id.
  new(this.answers);

  /// The answer for each cycle id.
  final Map<String, Object> answers;

  /// Calls per cycle id.
  final Map<String, int> calls = {};

  @override
  Future<Result<PayoutOrder>> fetchPayoutOrder(
    String stokvelId,
    String cycleId,
  ) {
    calls.update(cycleId, (count) => count + 1, ifAbsent: () => 1);
    return switch (answers[cycleId]) {
      final Completer<PayoutOrder> completer => completer.future.then(Ok.new),
      final PayoutOrder order => Future.value(Ok(order)),
      final Failure failure => Future.value(Err(failure)),
      Exception() => Future.value(const Err(NoAnswerFailure())),
      final answer => throw StateError('Unexpected answer $answer'),
    };
  }
}
