import 'package:ronditrack_app/core/concurrency/concurrency_token.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/core/time/sast.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/domain/contributions_list.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_editor.dart';

FakeStokvel? _entry(List<FakeStokvel> stokvels, String stokvelId) =>
    stokvels.where((s) => s.stokvel.id == stokvelId).firstOrNull;

/// [ContributionsRepository] over the fakes' seed, paging and filtering in
/// memory the way the API does: newest first, a South African day as the
/// half-open instants `Sast.bounds` gives, an offset as the page token.
class FakeContributionsRepository implements ContributionsRepository {
  /// Creates the fake. Only members of a stokvel see it ([userId]).
  new({required this.userId, required this.stokvels});

  /// The signed-in person.
  final String? userId;

  /// The fakes' shared seed.
  final List<FakeStokvel> stokvels;

  FakeStokvel? _mine(String stokvelId) {
    final entry = _entry(stokvels, stokvelId);
    return entry != null && entry.roles.containsKey(userId) ? entry : null;
  }

  @override
  Future<Result<List<CycleOption>>> fetchCycles(String stokvelId) async {
    final cycle = _mine(stokvelId)?.cycle;
    if (_mine(stokvelId) == null) return const Err(NotFoundFailure());
    return Ok([
      if (cycle != null)
        (id: cycle.id, period: cycle.period, dueDate: cycle.dueDate),
    ]);
  }

  @override
  Future<Result<List<MemberOption>>> fetchMembers(String stokvelId) async {
    final entry = _mine(stokvelId);
    if (entry == null) return const Err(NotFoundFailure());
    String nameOf(String id) =>
        FakeSeed.personas.values.where((p) => p.id == id).firstOrNull?.name ??
        entry.contributions
            .where((c) => c.userId == id)
            .firstOrNull
            ?.memberName ??
        'Member';
    return Ok([
      for (final id in entry.roles.keys) (userId: id, name: nameOf(id)),
    ]);
  }

  @override
  Future<Result<ContributionPage>> fetchPage(
    String stokvelId,
    ContributionFilter filter, {
    String? pageToken,
    int pageSize = 25,
  }) async {
    final entry = _mine(stokvelId);
    if (entry == null || entry.cycle?.id != filter.cycleId) {
      return const Err(NotFoundFailure());
    }
    final first = filter.firstDay;
    final last = filter.lastDay ?? first;
    final bounds = first == null || last == null
        ? null
        : Sast.bounds(first, last);
    final matching = [
      for (final c in entry.contributions)
        if ((filter.status == null || c.status == filter.status) &&
            (filter.userId == null || c.userId == filter.userId) &&
            (bounds == null ||
                (!c.recordedAt.isBefore(bounds.from) &&
                    c.recordedAt.isBefore(bounds.before))))
          c,
    ]..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    final start = int.tryParse(pageToken ?? '') ?? 0;
    final end = (start + pageSize).clamp(0, matching.length);
    return Ok(
      ContributionPage(
        matching.sublist(start.clamp(0, matching.length), end),
        nextPageToken: end < matching.length ? '$end' : null,
      ),
    );
  }
}

/// [StokvelEditor] over the fakes' seed. A cycle's concurrency token is a
/// version the fake counts; [changeElsewhere] stands in for another
/// treasurer saving first.
class FakeStokvelEditor implements StokvelEditor {
  /// Creates the fake for [userId].
  new({required this.userId, required this.stokvels});

  /// The signed-in person.
  final String? userId;

  /// The fakes' shared seed.
  final List<FakeStokvel> stokvels;

  static ConcurrencyToken _tokenOf(StokvelCycle cycle) =>
      cycle.concurrencyToken ?? const ConcurrencyToken('"1"');

  static ConcurrencyToken _next(ConcurrencyToken token) {
    final n = int.tryParse(token.value.replaceAll('"', '')) ?? 1;
    return ConcurrencyToken('"${n + 1}"');
  }

  void _replace(FakeStokvel entry, StokvelCycle cycle) {
    final i = stokvels.indexOf(entry);
    stokvels[i] = (
      stokvel: entry.stokvel,
      roles: entry.roles,
      cycle: cycle,
      contributions: entry.contributions,
      home: entry.home,
    );
  }

  /// Another treasurer changes [stokvelId]'s cycle: its token moves on, so
  /// an edit made from the old one is stale.
  void changeElsewhere(String stokvelId, {Cents? target}) {
    final entry = _entry(stokvels, stokvelId)!;
    final cycle = entry.cycle!;
    _replace(
      entry,
      cycle.copyWith(
        target: target ?? cycle.target,
        concurrencyToken: _next(_tokenOf(cycle)),
      ),
    );
  }

  @override
  Future<Result<String>> createStokvel({
    required String name,
    required Cents contribution,
    required CalendarDate firstDueDate,
  }) async {
    final me = userId;
    if (me == null) return const Err(UnauthorisedFailure());
    if (name.trim().isEmpty) {
      return const Err(
        ValidationFailure(
          fieldErrors: {
            'name': ['Stokvel name is required.'],
          },
        ),
      );
    }
    final id = 'fake-stokvel-${stokvels.length + 1}';
    final period =
        '${firstDueDate.year}-${firstDueDate.month.toString().padLeft(2, '0')}';
    stokvels.add((
      stokvel: Stokvel(
        id: id,
        name: name.trim(),
        contributionAmount: contribution,
        memberCount: 1,
      ),
      roles: {me: StokvelRole.chairperson},
      cycle: StokvelCycle(
        id: '$id-cycle-1',
        period: period,
        status: CycleStatus.open,
        dueDate: firstDueDate,
        membersPaid: 0,
        collected: Cents.zero,
        target: contribution,
      ),
      contributions: [],
      home: {me: (paid: Cents.zero, owed: contribution, arrears: Cents.zero)},
    ));
    return Ok(id);
  }

  @override
  Future<Result<void>> updateCycle({
    required String stokvelId,
    required StokvelCycle cycle,
    required Cents target,
    required CalendarDate dueDate,
  }) async {
    final entry = _entry(stokvels, stokvelId);
    final current = entry?.cycle;
    if (entry == null || current == null || current.id != cycle.id) {
      return const Err(NotFoundFailure());
    }
    final role = entry.roles[userId];
    if (role != StokvelRole.treasurer && role != StokvelRole.chairperson) {
      return const Err(ForbiddenFailure());
    }
    if (_tokenOf(current) != _tokenOf(cycle)) {
      return const Err(ConflictFailure());
    }
    _replace(
      entry,
      current.copyWith(
        target: target,
        dueDate: dueDate,
        concurrencyToken: _next(_tokenOf(current)),
      ),
    );
    return const Ok(null);
  }
}
