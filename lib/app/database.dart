import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:ronditrack_app/features/auth/data/last_user_table.dart';
import 'package:ronditrack_app/features/home/data/home_table.dart';
import 'package:ronditrack_app/features/payments/data/outbox_table.dart';
import 'package:ronditrack_app/features/stokvels/data/stokvel_tables.dart';

part 'database.g.dart';

/// The phone's database: what it last saw (Home, stokvels, cycles), who
/// was signed in, and the payment outbox. Each feature owns its tables and
/// the code that reads them, in its `data/` folder; this class only lists
/// them, as the composition root lists repositories.
///
/// Nothing here is a token, a proof of payment, or settings (README
/// "Offline").
@DriftDatabase(
  tables: [
    HomeCacheTable,
    StokvelCacheTable,
    CycleCacheTable,
    PaymentOutboxTable,
    LastUserTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Opens the database on [executor].
  new(super.e);

  /// The app's file, `ronditrack.sqlite`, in the app's private storage.
  factory onDevice() => AppDatabase(driftDatabase(name: 'ronditrack'));

  @override
  int get schemaVersion => 1;

  /// Empties every table: sign-out, on a phone a family shares. One
  /// transaction, so no screen ever sees half a person.
  Future<void> wipe() => transaction(() async {
    for (final table in allTables) {
      await delete(table).go();
    }
  });
}
