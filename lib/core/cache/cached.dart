import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:ronditrack_app/core/errors/failure.dart';

/// [value], as the server sent it at [fetchedAt]: what the phone last saw.
@immutable
class Cached<T> {
  /// Creates the cached value.
  const new(this.value, {required this.fetchedAt});

  /// The value.
  final T value;

  /// When the server answered with it (UTC).
  final DateTime fetchedAt;
}

/// Something the phone keeps and the server can refresh: Home, a stokvel,
/// a cycle. The implementation (in a feature's `data/`) keeps it in the
/// database; nothing above `data/` sees a row.
abstract interface class CachedSource<T> {
  /// What the phone has, at once and on every change; `null` while it has
  /// nothing.
  Stream<Cached<T>?> watch();

  /// Asks the server, and writes the answer into the cache, never straight
  /// to a screen. Returns `null` when it worked, or why it didn't. A
  /// [NotFoundFailure] also deletes what the phone had.
  Future<Failure?> refresh();
}

/// How a screen's data stands: when it was last fetched, and whether the
/// last refresh failed (and why). It comes from what happened to a
/// request, never from the connection type.
@immutable
class SyncStatus {
  /// Creates the status.
  const new({this.fetchedAt, this.failure, this.refreshing = false});

  /// When the data on screen was fetched; `null` when there is none.
  final DateTime? fetchedAt;

  /// Why the last refresh failed; `null` when it worked or is running.
  final Failure? failure;

  /// Whether a refresh is running.
  final bool refreshing;

  /// Whether the data on screen is not live: the last refresh failed.
  bool get isStale => failure != null && fetchedAt != null;

  @override
  bool operator ==(Object other) =>
      other is SyncStatus &&
      other.fetchedAt == fetchedAt &&
      other.failure == failure &&
      other.refreshing == refreshing;

  @override
  int get hashCode => Object.hash(fetchedAt, failure, refreshing);
}

/// What a provider gives a screen: the cache at once, then whatever each
/// refresh writes into it (stale-while-revalidate).
///
/// [onStatus] hears when the data was fetched and how each refresh went,
/// for the banner. An error reaches the screen only when there is nothing
/// cached to show, or when the server says it is gone (not found).
class CacheSync<T> {
  /// Creates the sync over [source].
  new(this.source, {required this.onStatus});

  /// The cache and its server.
  final CachedSource<T> source;

  /// Hears every change of [status].
  final void Function(SyncStatus status) onStatus;

  final _out = StreamController<T>();
  StreamSubscription<Cached<T>?>? _cached;
  SyncStatus _status = const SyncStatus();
  bool _closed = false;

  /// How the data stands now.
  SyncStatus get status => _status;

  void _set(SyncStatus status) {
    _status = status;
    if (!_closed) onStatus(status);
  }

  /// The cached value at once and on every change, and one refresh started
  /// after the provider that asked has finished building (it may not
  /// change another provider while it builds).
  Stream<T> start() {
    _cached = source.watch().listen((cached) {
      if (cached == null) return;
      _out.add(cached.value);
      _set(
        SyncStatus(
          fetchedAt: cached.fetchedAt,
          failure: _status.failure,
          refreshing: _status.refreshing,
        ),
      );
    }, onError: _out.addError);
    _out.onCancel = close;
    unawaited(Future.microtask(refresh));
    return _out.stream;
  }

  /// Asks the server once; the answer goes into the cache, and from there
  /// to the screen. Completes when it is done, whatever happened.
  Future<void> refresh() async {
    if (_closed) return;
    _set(
      SyncStatus(
        fetchedAt: _status.fetchedAt,
        failure: _status.failure,
        refreshing: true,
      ),
    );
    Failure? failure;
    try {
      failure = await source.refresh();
    } on Object catch (error) {
      failure = failureOf(error);
    }
    if (_closed) return;
    _set(SyncStatus(fetchedAt: _status.fetchedAt, failure: failure));
    if (failure != null &&
        (_status.fetchedAt == null || failure is NotFoundFailure)) {
      _out.addError(failure, StackTrace.current);
    }
  }

  /// Stops watching.
  Future<void> close() async {
    _closed = true;
    await _cached?.cancel();
    await _out.close();
  }
}
