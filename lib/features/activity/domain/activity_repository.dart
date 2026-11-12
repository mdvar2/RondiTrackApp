import 'package:ronditrack_app/features/activity/domain/activity_item.dart';

/// Reads the signed-in person's activity across their stokvels.
abstract interface class ActivityRepository {
  /// Newest first. Empty when nothing has happened in any of my stokvels,
  /// or when I'm in none.
  Future<List<ActivityItem>> fetchActivity();
}
