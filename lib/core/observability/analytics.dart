import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Product events contain identifiers only; never names, contact details or
/// financial values.
abstract interface class Analytics {
  /// Records a server-confirmed contribution.
  void contributionRecorded({
    required String stokvelId,
    required String memberId,
  });
}

/// Analytics stays off until a provider is deliberately configured.
final analyticsProvider = Provider<Analytics>((ref) => const _NoOpAnalytics());

class _NoOpAnalytics implements Analytics {
  const new();

  @override
  void contributionRecorded({
    required String stokvelId,
    required String memberId,
  }) {}
}
