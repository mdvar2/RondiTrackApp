import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/database.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_app/features/home/data/home_cache.dart';
import 'package:ronditrack_app/features/payments/data/drift_payment_outbox.dart';
import 'package:ronditrack_app/features/payments/domain/payment_outbox.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:uuid/uuid.dart';

import '../../helpers/test_database.dart';

/// A sender that answers from a script and keeps every key it was sent.
class _Sender implements PaymentSender {
  new(this.answers);

  final List<Result<void>> answers;
  final List<String> keys = [];

  @override
  Future<Result<void>> send(PendingPayment payment) async {
    keys.add(payment.idempotencyKey);
    return answers.length > 1 ? answers.removeAt(0) : answers.single;
  }
}

/// A server that keeps one contribution per idempotency key, as the API
/// does, and can lose its answer after saving (the phone hears nothing).
class _Server implements PaymentSender {
  new({this.loseAnswers = 0});

  /// How many answers are lost on the way back, after the save.
  int loseAnswers;

  /// The contributions it stored, by key.
  final Map<String, PendingPayment> stored = {};

  /// Every key it was sent.
  final List<String> keys = [];

  @override
  Future<Result<void>> send(PendingPayment payment) async {
    keys.add(payment.idempotencyKey);
    stored.putIfAbsent(payment.idempotencyKey, () => payment);
    if (loseAnswers > 0) {
      loseAnswers--;
      return const Err(NoAnswerFailure());
    }
    return const Ok(null);
  }
}

const _amount = Cents(50000);

Future<PendingPayment> _tap(PaymentOutbox outbox) => outbox.enqueue(
  stokvelId: FakeSeed.mabenaFamilyId,
  cycleId: FakeSeed.mabenaCycleId,
  userId: FakeSeed.sipho.id,
  amount: _amount,
);

void main() {
  late AppDatabase db;
  var now = DateTime.utc(2026, 11, 22, 8);

  setUp(() {
    db = memoryDatabase();
    now = DateTime.utc(2026, 11, 22, 8);
  });
  tearDown(() => db.close());

  DriftPaymentOutbox outboxWith(PaymentSender sender, {AppDatabase? on}) =>
      DriftPaymentOutbox(
        on ?? db,
        sender,
        newKey: const Uuid().v4,
        clock: () => now,
      );

  group('keys', () {
    test('one key per tap, made at the tap: two taps, two keys', () async {
      final outbox = outboxWith(_Sender([const Ok(null)]));

      final first = await _tap(outbox);
      final second = await _tap(outbox);

      expect(first.idempotencyKey, isNot(second.idempotencyKey));
      expect(
        first.idempotencyKey,
        matches(RegExp('^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-')),
      );
    });

    test(
      'every attempt sends the same key: a timeout, then Try again',
      () async {
        final sender = _Sender([
          const Err(NoAnswerFailure()),
          const Err(NoAnswerFailure()),
          const Ok(null),
        ]);
        final outbox = outboxWith(sender);
        final payment = await _tap(outbox);

        await outbox.send(payment);
        await outbox.sendAll();
        await outbox.sendAll();

        expect(sender.keys, [
          payment.idempotencyKey,
          payment.idempotencyKey,
          payment.idempotencyKey,
        ]);
        expect(await outbox.waiting(), isEmpty);
      },
    );

    test('a retry after a lost answer: the same key, and the server stores '
        'one contribution', () async {
      final server = _Server(loseAnswers: 1);
      final outbox = outboxWith(server);
      final payment = await _tap(outbox);

      expect(await outbox.send(payment), isA<PaymentStillPending>());
      await outbox.sendAll();

      expect(server.keys, [payment.idempotencyKey, payment.idempotencyKey]);
      expect(server.stored, hasLength(1));
      expect(await outbox.waiting(), isEmpty);
    });

    test('the same key after the app is killed and opened again', () async {
      final dir = await Directory.systemTemp.createTemp('outbox');
      final file = File('${dir.path}/ronditrack.sqlite');
      AppDatabase open() => AppDatabase(
        DatabaseConnection(
          NativeDatabase(file),
          closeStreamsSynchronously: true,
        ),
      );

      // Before the kill: tapped, sent, no answer.
      final before = open();
      final firstSender = _Sender([const Err(NoAnswerFailure())]);
      final payment = await _tap(outboxWith(firstSender, on: before));
      await outboxWith(firstSender, on: before).send(payment);
      await before.close();

      // Opened again: a new database connection, a new outbox.
      final after = open();
      final secondSender = _Sender([const Ok(null)]);
      await outboxWith(secondSender, on: after).sendAll();
      await after.close();
      await dir.delete(recursive: true);

      expect(firstSender.keys, [payment.idempotencyKey]);
      expect(secondSender.keys, [payment.idempotencyKey]);
    });
  });

  group('each answer has one outcome', () {
    test('success: removed', () async {
      final outbox = outboxWith(_Sender([const Ok(null)]));
      final outcome = await outbox.send(await _tap(outbox));

      expect(outcome, isA<PaymentAccepted>());
      expect(await outbox.waiting(), isEmpty);
    });

    for (final (detail, reason) in [
      (
        'A contribution already exists for this member and cycle.',
        PaymentRefusal.alreadyPaid,
      ),
      (
        'This contribution cycle is no longer open.',
        PaymentRefusal.cycleClosed,
      ),
    ]) {
      test('refused ($reason): removed, and why', () async {
        final sender = _Sender([Err(RuleFailure(detail: detail))]);
        final outbox = outboxWith(sender);
        final outcome = await outbox.send(await _tap(outbox));

        expect(
          outcome,
          isA<PaymentRefused>().having((o) => o.reason, 'reason', reason),
        );
        expect(await outbox.waiting(), isEmpty);

        // Nothing is sent again: not on the next sync, not on the one after.
        await outbox.sendAll();
        await outbox.sendAll();
        expect(sender.keys, hasLength(1));
      });
    }

    test(
      '429: kept, with its key, and not sent again before Retry-After',
      () async {
        final sender = _Sender([
          const Err(RateLimitedFailure(wait: Duration(seconds: 30))),
          const Ok(null),
        ]);
        final outbox = outboxWith(sender);
        final payment = await _tap(outbox);

        final outcome = await outbox.send(payment);
        expect(
          outcome,
          isA<PaymentWaiting>().having(
            (o) => o.wait,
            'wait',
            const Duration(seconds: 30),
          ),
        );
        final kept = (await outbox.waiting()).single;
        expect(kept.idempotencyKey, payment.idempotencyKey);

        now = now.add(const Duration(seconds: 10));
        expect(await outbox.send(kept), isA<PaymentWaiting>());
        expect(sender.keys, hasLength(1), reason: 'not sent while waiting');

        now = now.add(const Duration(seconds: 21));
        expect(await outbox.send(kept), isA<PaymentAccepted>());
        expect(sender.keys, [payment.idempotencyKey, payment.idempotencyKey]);
      },
    );

    test('no answer: kept, with its key, pending', () async {
      final outbox = outboxWith(_Sender([const Err(NoAnswerFailure())]));
      final payment = await _tap(outbox);

      expect(await outbox.send(payment), isA<PaymentStillPending>());
      expect(
        (await outbox.waiting()).single.idempotencyKey,
        payment.idempotencyKey,
      );
    });
  });

  test('the maximum age: shorter than the API keeps a key, and after it '
      'the payment is never sent again', () async {
    expect(PaymentOutbox.maxAge, lessThan(PaymentOutbox.apiKeyRetention));
    final sender = _Sender([const Err(NoAnswerFailure())]);
    final outbox = outboxWith(sender);
    final payment = await _tap(outbox);
    await outbox.send(payment);

    now = now.add(PaymentOutbox.maxAge);
    final outcome = await outbox.send((await outbox.waiting()).single);

    expect(outcome, isA<PaymentExpired>());
    expect(sender.keys, hasLength(1), reason: 'never sent after the age');
    expect(await outbox.waiting(), isEmpty);
  });

  test('no total changes while a payment is pending', () async {
    final home = HomeCache(
      db,
      FakeHomeRepository(userId: FakeSeed.sipho.id, delay: Duration.zero),
    );
    await home.refresh();
    final before = (await home.watch().first)!.value;
    final outbox = outboxWith(_Sender([const Err(NoAnswerFailure())]));

    await outbox.send(await _tap(outbox));

    final after = (await home.watch().first)!.value;
    expect(after, before);
    expect((await outbox.waiting()).single.amount, _amount);
  });
}
