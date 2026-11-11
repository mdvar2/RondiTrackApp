import 'package:ronditrack_app/features/home/domain/home_entry.dart';
import 'package:ronditrack_app/features/home/domain/home_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/domain/membership.dart';

/// A [HomeRepository] over [FakeSeed], signed in as [userId].
///
/// It returns what `GET /me/home` would: one entry per membership, ordered
/// by stokvel name, the role from that stokvel's membership, and the API's
/// own paid, owed and arrears figures. `nextPayoutDate` is `null`, as the
/// API always sends today.
class FakeHomeRepository implements HomeRepository {
  /// Creates the fake. [delay] pretends to be the network; tests pass
  /// [Duration.zero].
  new({
    required this.userId,
    this.delay = const Duration(milliseconds: 600),
    List<FakeStokvel>? stokvels,
  }) : _stokvels = stokvels ?? FakeSeed.stokvels;

  /// The signed-in person.
  final String userId;

  /// The pretend network delay.
  final Duration delay;

  final List<FakeStokvel> _stokvels;

  @override
  Future<List<HomeEntry>> fetchHome() async {
    await Future<void>.delayed(delay);

    final entries = <HomeEntry>[];
    for (final entry in _stokvels) {
      final role = entry.roles[userId];
      final figures = entry.home[userId];
      if (role == null || figures == null) continue;
      final cycle = entry.cycle;
      entries.add(
        HomeEntry(
          membership: Membership(stokvelId: entry.stokvel.id, role: role),
          stokvelName: entry.stokvel.name,
          currentCycle: cycle == null
              ? null
              : HomeCycle(
                  period: cycle.period,
                  status: cycle.status,
                  dueDate: cycle.dueDate,
                ),
          amountPaid: figures.paid,
          amountOwed: figures.owed,
          arrears: figures.arrears,
          nextPayoutDate: null,
        ),
      );
    }
    entries.sort((a, b) => a.stokvelName.compareTo(b.stokvelName));
    return List.unmodifiable(entries);
  }
}
