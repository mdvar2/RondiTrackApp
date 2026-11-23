import 'package:drift/drift.dart';

/// Who was last signed in on this phone: what lets the app open offline as
/// that person, on their cached data. Deleted at sign-out with everything
/// else. Name and email only; never a token (the refresh token is in secure
/// storage, the access token in memory).
@DataClassName('LastUserRow')
class LastUserTable extends Table {
  @override
  String get tableName => 'last_user';

  /// Always 0: one person at a time.
  IntColumn get slot => integer()();

  /// The user's id.
  TextColumn get userId => text()();

  /// Their name.
  TextColumn get name => text()();

  /// Their email.
  TextColumn get email => text()();

  @override
  Set<Column<Object>> get primaryKey => {slot};
}
