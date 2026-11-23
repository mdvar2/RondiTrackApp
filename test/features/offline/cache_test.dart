import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/database.dart';
import 'package:ronditrack_app/core/cache/cached.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/features/auth/data/last_user_store.dart';
import 'package:ronditrack_app/features/auth/domain/auth_user.dart';
import 'package:ronditrack_app/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_app/features/home/data/home_cache.dart';
import 'package:ronditrack_app/features/home/domain/home_entry.dart';
import 'package:ronditrack_app/features/home/domain/home_repository.dart';
import 'package:ronditrack_app/features/payments/data/drift_payment_outbox.dart';
import 'package:ronditrack_app/features/payments/data/payment_senders.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/stokvel_cache.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_repository.dart';

import '../../helpers/test_database.dart';

/// A Home repository that answers what the test sets.
class _Remote implements HomeRepository {
  Result<List<HomeEntry>> answer = const Err(NoAnswerFailure());
  int calls = 0;

  @override
  Future<Result<List<HomeEntry>>> fetchHome() async {
    calls++;
    return answer;
  }
}

/// A stokvel repository whose stokvel answers are set per id.
class _Stokvels implements StokvelRepository {
  new(this.inner);

  final StokvelRepository inner;
  final Map<String, Failure> failing = {};

  @override
  Future<Result<StokvelDetail>> fetchStokvel(String stokvelId) async {
    final failure = failing[stokvelId];
    return failure != null ? Err(failure) : await inner.fetchStokvel(stokvelId);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<List<HomeEntry>> _lerato() async => (await FakeHomeRepository(
  userId: FakeSeed.lerato.id,
  delay: Duration.zero,
).fetchHome()).valueOrThrow;

void main() {
  late AppDatabase db;

  setUp(() => db = memoryDatabase());
  tearDown(() => db.close());

  group('the database', () {
    test('what is saved comes back as domain types, cents and calendar '
        'days included', () async {
      final entries = await _lerato();
      final remote = _Remote()..answer = Ok(entries);
      final cache = HomeCache(
        db,
        remote,
        clock: () => DateTime.utc(2026, 11, 22, 9),
      );

      expect(await cache.refresh(), isNull);
      final cached = (await cache.watch().first)!;

      expect(cached.value, entries);
      expect(cached.value.first.amountPaid, isA<Cents>());
      expect(cached.fetchedAt, DateTime.utc(2026, 11, 22, 9));
    });

    test('a screen watching before the first fetch sees it arrive', () async {
      final remote = _Remote()..answer = Ok(await _lerato());
      final cache = HomeCache(db, remote);
      final seen = <int?>[];
      final watching = cache.watch().listen((c) => seen.add(c?.value.length));
      await pumpEventQueue();

      await cache.refresh();
      await pumpEventQueue();

      expect(seen, [null, 2]);
      await watching.cancel();
    });

    test('two screens watching two stokvels at once each see their own '
        'changes', () async {
      final remote = FakeStokvelRepository(
        userId: FakeSeed.lerato.id,
        delay: Duration.zero,
        stokvels: FakeSeed.fresh(),
      );
      final mabena = StokvelCache(db, remote, FakeSeed.mabenaFamilyId);
      final soweto = StokvelCache(db, remote, FakeSeed.sowetoTeachersId);
      final a = <String?>[];
      final b = <String?>[];
      final subA = mabena.watch().listen((c) => a.add(c?.value.stokvel.name));
      final subB = soweto.watch().listen((c) => b.add(c?.value.stokvel.name));
      await pumpEventQueue();

      await mabena.refresh();
      await pumpEventQueue();
      await soweto.refresh();
      await pumpEventQueue();

      expect(a.whereType<String>().toSet(), {'Mabena Family'});
      expect(b.whereType<String>().toSet(), {'Soweto Teachers'});
      expect(b.last, 'Soweto Teachers');
      await subA.cancel();
      await subB.cancel();
    });

    test('sign-out leaves nothing: every cached row, the outbox, who was '
        'signed in', () async {
      await HomeCache(db, _Remote()..answer = Ok(await _lerato())).refresh();
      await StokvelCache(
        db,
        FakeStokvelRepository(
          userId: FakeSeed.lerato.id,
          delay: Duration.zero,
          stokvels: FakeSeed.fresh(),
        ),
        FakeSeed.mabenaFamilyId,
      ).refresh();
      await DriftPaymentOutbox(
        db,
        FakePaymentSender(stokvels: FakeSeed.fresh()),
        newKey: () => 'key-1',
      ).enqueue(
        stokvelId: 's',
        cycleId: 'c',
        userId: 'u',
        amount: const Cents(100),
      );
      await DriftLastUser(db)
          .remember(const AuthUser(id: 'u', name: 'Lerato', email: 'l@x'));

      await db.wipe();

      for (final table in db.allTables) {
        expect(
          await db.select(table).get(),
          isEmpty,
          reason: table.actualTableName,
        );
      }
    });
  });

  group('cache and sync', () {
    test('offline, the cache stays and the sync says why', () async {
      final remote = _Remote()..answer = Ok(await _lerato());
      final cache = HomeCache(db, remote);
      await cache.refresh();
      remote.answer = const Err(NoAnswerFailure());
      final statuses = <SyncStatus>[];
      final sync = CacheSync(cache, onStatus: statuses.add);
      final values = <List<HomeEntry>>[];
      final sub = sync.start().listen(values.add);

      await pumpEventQueue();

      expect(values.single, hasLength(2));
      expect(statuses.last.failure, isA<NoAnswerFailure>());
      expect(statuses.last.fetchedAt, isNotNull);
      expect(statuses.last.isStale, isTrue);
      await sub.cancel();
    });

    test('a fetch updates the cache, and the banner goes', () async {
      final remote = _Remote()..answer = Ok(await _lerato());
      final cache = HomeCache(db, remote);
      await cache.refresh();
      remote.answer = const Err(NoAnswerFailure());
      final statuses = <SyncStatus>[];
      final sync = CacheSync(cache, onStatus: statuses.add);
      final sub = sync.start().listen((_) {});
      await pumpEventQueue();
      expect(sync.status.isStale, isTrue);

      remote.answer = const Ok([]);
      await sync.refresh();
      await pumpEventQueue();

      expect(sync.status.isStale, isFalse);
      expect(sync.status.failure, isNull);
      expect((await cache.watch().first)!.value, isEmpty);
      await sub.cancel();
    });

    test('not found removes the row', () async {
      final remote = _Stokvels(
        FakeStokvelRepository(
          userId: FakeSeed.lerato.id,
          delay: Duration.zero,
          stokvels: FakeSeed.fresh(),
        ),
      );
      final cache = StokvelCache(db, remote, FakeSeed.mabenaFamilyId);
      await cache.refresh();
      expect(await cache.watch().first, isNotNull);

      remote.failing[FakeSeed.mabenaFamilyId] = const NotFoundFailure();
      final errors = <Object>[];
      final sync = CacheSync(cache, onStatus: (_) {});
      final sub = sync.start().listen((_) {}, onError: errors.add);
      await pumpEventQueue();

      expect(await cache.watch().first, isNull);
      expect(errors.single, isA<NotFoundFailure>());
      await sub.cancel();
    });
  });
}
