import 'package:flutter/material.dart';

/// A cycle's payout order (`/stokvels/:id/cycles/:cycleId/payouts`).
class PayoutsScreen extends StatelessWidget {
  /// Shows the payout order of cycle [cycleId] of stokvel [stokvelId].
  const new({required this.stokvelId, required this.cycleId, super.key});

  /// The stokvel, from the address.
  final String stokvelId;

  /// The cycle, from the address.
  final String cycleId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('payouts-$cycleId'),
      appBar: AppBar(title: const Text('Payout order')),
    );
  }
}
