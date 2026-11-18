import 'package:ronditrack_app/core/data/api_values.dart';
import 'package:ronditrack_app/core/data/generated/models/payout_order_response.dart';
import 'package:ronditrack_app/core/data/generated/rondi_track_api.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_order.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_repository.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_status.dart';

/// `PayoutOrderResponse` as a [PayoutOrder], in the API's order: each
/// status into [PayoutStatus] (`unknown` for a spelling the app doesn't
/// know), amounts as [Cents], `paidAtUtc` as a UTC instant.
PayoutOrder payoutOrderFrom(PayoutOrderResponse response) => PayoutOrder(
  stokvelId: response.stokvelId,
  cycleId: response.cycleId,
  entries: List.unmodifiable([
    for (final item in response.items)
      PayoutEntry(
        position: item.position,
        userId: item.userId,
        memberName: item.memberName,
        amount: Cents(item.amountCents),
        paidAt: switch (item.paidAtUtc) {
          null => null,
          final DateTime paid => instantOf(paid),
        },
        status: PayoutStatus.fromApi(item.status),
      ),
  ]),
);

/// [PayoutRepository] on the API:
/// `GET /stokvels/{stokvelId}/cycles/{cycleId}/payouts`.
class ApiPayoutRepository implements PayoutRepository {
  /// Creates the repository over the generated client.
  new(this._api);

  final RondiTrackApi _api;

  @override
  Future<Result<PayoutOrder>> fetchPayoutOrder(
    String stokvelId,
    String cycleId,
  ) => guard(() async {
    final response = await _api.payouts
        .getApiV1StokvelsStokvelIdCyclesCycleIdPayouts(
          stokvelId: stokvelId,
          cycleId: cycleId,
        );
    return payoutOrderFrom(response.data);
  });
}
