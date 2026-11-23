import 'package:drift/drift.dart';

/// Payments a member has tapped Pay for, waiting to be accepted by the API.
///
/// The `Idempotency-Key` is made once, when the row is written at the tap,
/// and every attempt sends this same key: after a timeout, after Try again,
/// after the app is killed and opened again (README "Offline").
@DataClassName('OutboxRow')
class PaymentOutboxTable extends Table {
  @override
  String get tableName => 'payment_outbox';

  /// The row's own id.
  IntColumn get id => integer().autoIncrement()();

  /// The `Idempotency-Key`, a v4 UUID made at the tap.
  TextColumn get idempotencyKey => text().unique()();

  /// The stokvel.
  TextColumn get stokvelId => text()();

  /// The cycle being paid for.
  TextColumn get cycleId => text()();

  /// Whose contribution it is (the signed-in member).
  TextColumn get userId => text()();

  /// The amount, in cents. Never a double.
  IntColumn get amountCents => integer()();

  /// When Pay was tapped (UTC). The outbox's maximum age counts from here.
  DateTimeColumn get createdAt => dateTime()();

  /// How many times it was sent.
  IntColumn get attempts => integer().withDefault(const Constant(0))();

  /// Not to be sent before this (UTC): the API's `Retry-After`.
  DateTimeColumn get waitUntil => dateTime().nullable()();
}
