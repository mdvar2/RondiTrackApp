import 'package:ronditrack_app/core/concurrency/concurrency_token.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/domain/cycle_close_preview.dart';
import 'package:ronditrack_app/features/stokvels/domain/membership.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';

/// A [StokvelRepository] over [FakeSeed], signed in as [userId].
///
/// It answers like the API: the role comes from this stokvel's membership,
/// and a stokvel the caller isn't in fails exactly like one that doesn't
/// exist (the API's `404`).
class FakeStokvelRepository implements StokvelRepository {
  /// Creates the fake.
  ///
  /// [delay] pretends to be the network; tests pass [Duration.zero].
  /// [slowStokvels] adds more delay for particular ids, like a stokvel that
  /// is slow on a data bundle.
  new({
    required this.userId,
    this.delay = const Duration(milliseconds: 600),
    this.slowStokvels = const {},
    List<FakeStokvel>? stokvels,
  }) : _stokvels = stokvels ?? FakeSeed.stokvels;

  /// The signed-in person, `null` when nobody is: every stokvel is then
  /// not found.
  final String? userId;

  /// The pretend network delay for every call.
  final Duration delay;

  /// Extra delay per stokvel id.
  final Map<String, Duration> slowStokvels;

  final List<FakeStokvel> _stokvels;

  @override
  Future<Result<StokvelDetail>> fetchStokvel(String stokvelId) async {
    await Future<void>.delayed(delay + (slowStokvels[stokvelId] ?? .zero));

    for (final entry in _stokvels) {
      if (entry.stokvel.id != stokvelId) continue;
      final role = entry.roles[userId];
      // Not a member: the same answer as a stokvel that doesn't exist.
      if (role == null) break;
      return Ok(
        StokvelDetail(
          stokvel: entry.stokvel,
          membership: Membership(stokvelId: stokvelId, role: role),
          currentCycle: entry.cycle,
          contributions: List.unmodifiable(entry.contributions),
        ),
      );
    }
    return const Err(StokvelNotFoundException());
  }

  @override
  Future<Result<CycleDetail>> fetchCycle(
    String stokvelId,
    String cycleId,
  ) async {
    await Future<void>.delayed(delay + (slowStokvels[stokvelId] ?? .zero));

    for (final entry in _stokvels) {
      if (entry.stokvel.id != stokvelId) continue;
      final cycle = entry.cycle;
      // Not a member, or a cycle of another stokvel: the same answer as a
      // cycle that doesn't exist.
      if (entry.roles[userId] == null || cycle == null) break;
      if (cycle.id != cycleId) break;
      return Ok(
        CycleDetail(
          stokvel: entry.stokvel,
          cycle: cycle,
          contributions: List.unmodifiable(entry.contributions),
        ),
      );
    }
    return const Err(CycleNotFoundException());
  }

  /// Answers like the API: a Treasurer or Chairperson gets the preview, a
  /// Member is refused (`403`), anyone else gets "not found" (`404`). The
  /// shortfalls are each member's contribution less what they paid, as the
  /// API works them out; the fake stands in for the server here.
  @override
  Future<Result<CycleClosePreview>> fetchClosePreview(
    String stokvelId,
    String cycleId,
  ) async {
    await Future<void>.delayed(delay + (slowStokvels[stokvelId] ?? .zero));

    for (final entry in _stokvels) {
      if (entry.stokvel.id != stokvelId) continue;
      final role = entry.roles[userId];
      final cycle = entry.cycle;
      if (role == null || cycle == null || cycle.id != cycleId) break;
      switch (role) {
        case StokvelRole.treasurer || StokvelRole.chairperson:
          break;
        case StokvelRole.member || StokvelRole.unknown:
          return const Err(ForbiddenFailure());
      }
      final arrears = <CloseArrear>[
        for (final MapEntry(key: memberId) in entry.roles.entries)
          if (_shortfall(entry, memberId) case final short when short > .zero)
            CloseArrear(
              userId: memberId,
              memberName: _nameOf(entry, memberId),
              amount: short,
            ),
      ];
      return Ok(
        CycleClosePreview(
          cycleId: cycleId,
          period: cycle.period,
          asOf: cycle.dueDate ?? CalendarDate(2026, 11, 30),
          version: ConcurrencyToken('fake-$cycleId'),
          arrears: List.unmodifiable(arrears),
          total: arrears.fold(Cents.zero, (sum, a) => sum + a.amount),
        ),
      );
    }
    return const Err(CycleNotFoundException());
  }

  Cents _shortfall(FakeStokvel entry, String memberId) {
    final paid = entry.contributions
        .where((c) => c.userId == memberId)
        .fold(Cents.zero, (sum, c) => sum + c.amount);
    final short = entry.stokvel.contributionAmount - paid;
    return short.isNegative ? Cents.zero : short;
  }

  String _nameOf(FakeStokvel entry, String memberId) {
    for (final persona in FakeSeed.personas.values) {
      if (persona.id == memberId) return persona.name;
    }
    for (final contribution in entry.contributions) {
      if (contribution.userId == memberId) return contribution.memberName;
    }
    return 'A member';
  }
}
