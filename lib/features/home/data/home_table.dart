import 'package:drift/drift.dart';

/// Home, as the phone last saw it: one row, the entries as JSON (the
/// domain's, encoded by `home_codec.dart`), and
/// when they were fetched. Only `data/` reads it.
@DataClassName('HomeRow')
class HomeCacheTable extends Table {
  @override
  String get tableName => 'home_cache';

  /// Always 0: Home is one thing per signed-in person, and the database is
  /// emptied at sign-out.
  IntColumn get slot => integer()();

  /// The entries, encoded.
  TextColumn get entries => text()();

  /// When the server answered with them (UTC).
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {slot};
}
