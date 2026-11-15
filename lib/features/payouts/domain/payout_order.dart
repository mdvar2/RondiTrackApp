import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_status.dart';

part 'payout_order.freezed.dart';

/// A cycle's payout order (`PayoutOrderResponse`, from
/// `GET /stokvels/{stokvelId}/cycles/{cycleId}/payouts`).
///
/// Shown exactly as the API sends it. The app doesn't sort `entries`, count
/// who has been paid, add up the pot or decide who is next: each of those is
/// the server's decision.
@freezed
abstract class PayoutOrder with _$PayoutOrder {
  /// Creates a payout order.
  const factory({
    /// `stokvelId`.
    required String stokvelId,

    /// `cycleId`.
    required String cycleId,

    /// `items`, in the API's order (the rotation). Empty when the cycle has
    /// no payout order.
    required List<PayoutEntry> entries,
  }) = _PayoutOrder;
}

/// One member in the rotation (`PayoutOrderEntryResponse`).
@freezed
abstract class PayoutEntry with _$PayoutEntry {
  /// Creates an entry.
  const factory({
    /// `position`, 1-based, as the API numbers it. Shown, never sorted on.
    required int position,

    /// `userId`.
    required String userId,

    /// `memberName`.
    required String memberName,

    /// `amountCents`: the payout for a paid member, the cycle's pot for the
    /// rest. The API's number, never computed here.
    required Cents amount,

    /// `paidAtUtc`, an instant; `null` unless `status` is
    /// [PayoutStatus.paid].
    required DateTime? paidAt,

    /// `status`.
    required PayoutStatus status,
  }) = _PayoutEntry;
}
