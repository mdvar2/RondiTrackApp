import 'package:drift/drift.dart';
import 'package:ronditrack_app/app/database.dart';
import 'package:ronditrack_app/core/cache/cached.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/stokvels/data/stokvel_codec.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';

/// One stokvel's detail in the database, refreshed from [_remote].
class StokvelCache implements CachedSource<StokvelDetail> {
  /// Creates the cache for [stokvelId].
  new(this._db, this._remote, this.stokvelId, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final StokvelRepository _remote;
  final DateTime Function() _clock;

  /// The stokvel.
  final String stokvelId;

  @override
  Stream<Cached<StokvelDetail>?> watch() =>
      (_db.select(_db.stokvelCacheTable)
            ..where((row) => row.stokvelId.equals(stokvelId)))
          .watchSingleOrNull()
          .map(
            (row) => row == null
                ? null
                : Cached(
                    StokvelCodec.decodeDetail(row.detail),
                    fetchedAt: row.fetchedAt.toUtc(),
                  ),
          );

  @override
  Future<Failure?> refresh() async {
    switch (await _remote.fetchStokvel(stokvelId)) {
      case Ok(value: final detail):
        await save(detail);
        return null;
      case Err(:final NotFoundFailure failure):
        // Gone, or no longer theirs: nothing of it stays on the phone.
        await (_db.delete(
          _db.stokvelCacheTable,
        )..where((row) => row.stokvelId.equals(stokvelId))).go();
        return failure;
      case Err(:final failure):
        return failure;
    }
  }

  /// Writes [detail] as fetched now.
  Future<void> save(StokvelDetail detail) => _db
      .into(_db.stokvelCacheTable)
      .insertOnConflictUpdate(
        StokvelCacheTableCompanion.insert(
          stokvelId: stokvelId,
          detail: StokvelCodec.encodeDetail(detail),
          fetchedAt: _clock().toUtc(),
        ),
      );
}

/// One cycle in the database, refreshed from [_remote].
class CycleCache implements CachedSource<CycleDetail> {
  /// Creates the cache for cycle [cycleId] of stokvel [stokvelId].
  new(
    this._db,
    this._remote,
    this.stokvelId,
    this.cycleId, {
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final StokvelRepository _remote;
  final DateTime Function() _clock;

  /// The stokvel.
  final String stokvelId;

  /// The cycle.
  final String cycleId;

  @override
  Stream<Cached<CycleDetail>?> watch() =>
      (_db.select(_db.cycleCacheTable)..where(
            (row) =>
                row.stokvelId.equals(stokvelId) & row.cycleId.equals(cycleId),
          ))
          .watchSingleOrNull()
          .map(
            (row) => row == null
                ? null
                : Cached(
                    StokvelCodec.decodeCycle(row.detail),
                    fetchedAt: row.fetchedAt.toUtc(),
                  ),
          );

  @override
  Future<Failure?> refresh() async {
    switch (await _remote.fetchCycle(stokvelId, cycleId)) {
      case Ok(value: final detail):
        await save(detail);
        return null;
      case Err(:final NotFoundFailure failure):
        await (_db.delete(_db.cycleCacheTable)..where(
              (row) =>
                  row.stokvelId.equals(stokvelId) & row.cycleId.equals(cycleId),
            ))
            .go();
        return failure;
      case Err(:final failure):
        return failure;
    }
  }

  /// Writes [detail] as fetched now.
  Future<void> save(CycleDetail detail) => _db
      .into(_db.cycleCacheTable)
      .insertOnConflictUpdate(
        CycleCacheTableCompanion.insert(
          stokvelId: stokvelId,
          cycleId: cycleId,
          detail: StokvelCodec.encodeCycle(detail),
          fetchedAt: _clock().toUtc(),
        ),
      );
}
