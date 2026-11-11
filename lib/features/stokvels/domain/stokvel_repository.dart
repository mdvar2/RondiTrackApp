import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';

/// Thrown when a stokvel can't be shown: it doesn't exist, *or* the caller
/// isn't a member.
///
/// The two are deliberately the same. The API answers both with `404`, so
/// nobody can tell whether a stokvel they aren't in exists.
class StokvelNotFoundException implements Exception {
  /// Creates the exception. It carries no id or name, so it is safe to log.
  const new();

  @override
  String toString() => 'StokvelNotFoundException';
}

/// Reads one stokvel for the signed-in person.
abstract interface class StokvelRepository {
  /// The stokvel, the caller's membership, its current cycle and that
  /// cycle's contributions.
  ///
  /// Throws [StokvelNotFoundException] for a stokvel that doesn't exist and
  /// for one the caller isn't a member of.
  Future<StokvelDetail> fetchStokvel(String stokvelId);
}
