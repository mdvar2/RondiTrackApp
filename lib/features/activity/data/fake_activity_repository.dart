import 'package:ronditrack_app/features/activity/domain/activity_item.dart';
import 'package:ronditrack_app/features/activity/domain/activity_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

/// An [ActivityRepository] over [FakeSeed], signed in as [userId]: every
/// contribution in the current cycle of each stokvel [userId] is in.
class FakeActivityRepository implements ActivityRepository {
  /// Creates the fake. [delay] pretends to be the network.
  new({
    required this.userId,
    this.delay = const Duration(milliseconds: 600),
    List<FakeStokvel>? stokvels,
  }) : _stokvels = stokvels ?? FakeSeed.stokvels;

  /// The signed-in person, `null` when nobody is.
  final String? userId;

  /// The pretend network delay.
  final Duration delay;

  final List<FakeStokvel> _stokvels;

  @override
  Future<List<ActivityItem>> fetchActivity() async {
    await Future<void>.delayed(delay);

    final items = <ActivityItem>[
      for (final entry in _stokvels)
        if (entry.roles[userId] != null)
          if (entry.cycle case final cycle?)
            for (final contribution in entry.contributions)
              ActivityItem(
                id: contribution.id,
                stokvelId: entry.stokvel.id,
                stokvelName: entry.stokvel.name,
                cycleId: cycle.id,
                memberName: contribution.memberName,
                amount: contribution.amount,
                status: contribution.status,
                occurredAt: contribution.recordedAt,
              ),
    ]..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return List.unmodifiable(items);
  }
}
