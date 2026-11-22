import 'package:drift/drift.dart';
import 'package:ronditrack_app/app/database.dart';
import 'package:ronditrack_app/core/cache/cached.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/home/data/home_codec.dart';
import 'package:ronditrack_app/features/home/domain/home_entry.dart';
import 'package:ronditrack_app/features/home/domain/home_repository.dart';

/// Home in the database, refreshed from [_remote] (the API's repository,
/// or the fakes').
class HomeCache implements CachedSource<List<HomeEntry>> {
  /// Creates the cache.
  new(this._db, this._remote, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final HomeRepository _remote;
  final DateTime Function() _clock;

  @override
  Stream<Cached<List<HomeEntry>>?> watch() => _db
      .select(_db.homeCacheTable)
      .watchSingleOrNull()
      .map(
        (row) => row == null
            ? null
            : Cached(HomeCodec.decode(row.entries), fetchedAt: row.fetchedAt),
      );

  @override
  Future<Failure?> refresh() async {
    switch (await _remote.fetchHome()) {
      case Ok(value: final entries):
        await save(entries);
        return null;
      case Err(:final failure):
        return failure;
    }
  }

  /// Writes [entries] as fetched now.
  Future<void> save(List<HomeEntry> entries) => _db
      .into(_db.homeCacheTable)
      .insertOnConflictUpdate(
        HomeCacheTableCompanion.insert(
          slot: const Value(0),
          entries: HomeCodec.encode(entries),
          fetchedAt: _clock().toUtc(),
        ),
      );
}
