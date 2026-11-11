import 'package:ronditrack_app/features/home/domain/home_entry.dart';

/// Reads the signed-in person's Home (`GET /api/v1/me/home`).
abstract interface class HomeRepository {
  /// One entry per stokvel the caller belongs to; empty when none.
  Future<List<HomeEntry>> fetchHome();
}
