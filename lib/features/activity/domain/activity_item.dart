import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';

part 'activity_item.freezed.dart';

/// One line in the activity feed: a contribution recorded in one of my
/// stokvels' current cycles.
///
/// The API has no feed endpoint yet (README "Contract notes"); the fake
/// builds it from the same contributions the cycle screen shows.
@freezed
abstract class ActivityItem with _$ActivityItem {
  /// Creates an activity item.
  const factory({
    /// The contribution's id.
    required String id,

    /// The stokvel it happened in.
    required String stokvelId,

    /// That stokvel's name.
    required String stokvelName,

    /// The cycle it belongs to, so the item can open it.
    required String cycleId,

    /// Who contributed.
    required String memberName,

    /// How much.
    required Cents amount,

    /// The contribution's status.
    required ContributionStatus status,

    /// When it was recorded, an instant.
    required DateTime occurredAt,
  }) = _ActivityItem;
}
