import 'package:drift/drift.dart';
import 'package:ronditrack_app/app/database.dart';
import 'package:ronditrack_app/features/auth/domain/auth_user.dart';
import 'package:ronditrack_app/features/auth/domain/last_user.dart';

/// [LastUser] in the database's `last_user` table.
class DriftLastUser implements LastUser {
  /// Creates the store.
  new(this._db);

  final AppDatabase _db;

  @override
  Future<AuthUser?> read() async {
    final row = await _db.select(_db.lastUserTable).getSingleOrNull();
    return row == null
        ? null
        : AuthUser(id: row.userId, name: row.name, email: row.email);
  }

  @override
  Future<void> remember(AuthUser user) => _db
      .into(_db.lastUserTable)
      .insertOnConflictUpdate(
        LastUserTableCompanion.insert(
          slot: const Value(0),
          userId: user.id,
          name: user.name,
          email: user.email,
        ),
      );
}
