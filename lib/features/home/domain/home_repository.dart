import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/home/domain/home_entry.dart';

/// Reads the signed-in person's Home (`GET /api/v1/me/home`).
abstract interface class HomeRepository {
  /// One entry per stokvel the caller belongs to; empty when none.
  Future<Result<List<HomeEntry>>> fetchHome();
}
