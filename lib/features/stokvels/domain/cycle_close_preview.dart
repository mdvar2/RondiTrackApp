import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ronditrack_app/core/concurrency/concurrency_token.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';

part 'cycle_close_preview.freezed.dart';

/// What closing a cycle would record (`CycleClosePreviewResponse`, from
/// `GET /stokvels/{stokvelId}/cycles/{cycleId}/close/preview`): a treasurer
/// action. A Member gets `403`, a non-member `404`.
///
/// The API works out every shortfall and the total; the app shows them.
@freezed
abstract class CycleClosePreview with _$CycleClosePreview {
  /// Creates a preview.
  const factory({
    /// `cycleId`.
    required String cycleId,

    /// `period`, such as `2026-11`.
    required String period,

    /// `asOfDate`: the Johannesburg day the preview was worked out for.
    required CalendarDate asOf,

    /// `version`, kept exactly as sent: the close request must send it
    /// back, and a stale one is refused.
    required ConcurrencyToken version,

    /// `arrears`: who would be recorded short, and by how much.
    required List<CloseArrear> arrears,

    /// `totalCents`.
    required Cents total,
  }) = _CycleClosePreview;
}

/// One member's shortfall in a close preview (`CycleArrearPreview`).
@freezed
abstract class CloseArrear with _$CloseArrear {
  /// Creates a shortfall.
  const factory({
    /// `userId`.
    required String userId,

    /// `userName`.
    required String memberName,

    /// `amountCents`.
    required Cents amount,
  }) = _CloseArrear;
}
