import 'package:drift/drift.dart';

/// A stokvel's detail (with its current cycle), as the phone last saw it.
@DataClassName('StokvelRow')
class StokvelCacheTable extends Table {
  @override
  String get tableName => 'stokvel_cache';

  /// The stokvel's id.
  TextColumn get stokvelId => text()();

  /// The detail, encoded (`stokvel_codec.dart`).
  TextColumn get detail => text()();

  /// When the server answered with it (UTC).
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {stokvelId};
}

/// One cycle (and its contributions), as the phone last saw it.
@DataClassName('CycleRow')
class CycleCacheTable extends Table {
  @override
  String get tableName => 'cycle_cache';

  /// The stokvel's id.
  TextColumn get stokvelId => text()();

  /// The cycle's id.
  TextColumn get cycleId => text()();

  /// The cycle, encoded.
  TextColumn get detail => text()();

  /// When the server answered with it (UTC).
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {stokvelId, cycleId};
}
