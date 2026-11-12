import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/domain/membership.dart';
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
  Future<StokvelDetail> fetchStokvel(String stokvelId) async {
    await Future<void>.delayed(delay + (slowStokvels[stokvelId] ?? .zero));

    for (final entry in _stokvels) {
      if (entry.stokvel.id != stokvelId) continue;
      final role = entry.roles[userId];
      // Not a member: the same answer as a stokvel that doesn't exist.
      if (role == null) break;
      return StokvelDetail(
        stokvel: entry.stokvel,
        membership: Membership(stokvelId: stokvelId, role: role),
        currentCycle: entry.cycle,
        contributions: List.unmodifiable(entry.contributions),
      );
    }
    throw const StokvelNotFoundException();
  }

  @override
  Future<CycleDetail> fetchCycle(String stokvelId, String cycleId) async {
    await Future<void>.delayed(delay + (slowStokvels[stokvelId] ?? .zero));

    for (final entry in _stokvels) {
      if (entry.stokvel.id != stokvelId) continue;
      final cycle = entry.cycle;
      // Not a member, or a cycle of another stokvel: the same answer as a
      // cycle that doesn't exist.
      if (entry.roles[userId] == null || cycle == null) break;
      if (cycle.id != cycleId) break;
      return CycleDetail(
        stokvel: entry.stokvel,
        cycle: cycle,
        contributions: List.unmodifiable(entry.contributions),
      );
    }
    throw const CycleNotFoundException();
  }
}
