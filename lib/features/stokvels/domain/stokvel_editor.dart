import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';

/// The field a create or edit refused, in the form's terms.
enum StokvelField {
  /// The stokvel's name.
  name,

  /// An amount: the contribution, or a cycle's target.
  amount,

  /// A date: the first due date, or a cycle's due date.
  dueDate,
}

/// The API's field names (`errors` keys) for each [StokvelField] (README
/// "Contract notes › Offline, forms and lists", question 5).
const Map<String, StokvelField> stokvelFieldsByApiName = {
  'name': StokvelField.name,
  'contributionAmount': StokvelField.amount,
  'targetAmount': StokvelField.amount,
  'endDate': StokvelField.dueDate,
  'period': StokvelField.dueDate,
};

/// Creates stokvels and edits cycles.
abstract interface class StokvelEditor {
  /// Creates a stokvel (the person becomes its chairperson) and its first
  /// cycle, due on [firstDueDate]. Returns the new stokvel's id. Field
  /// errors are a [ValidationFailure], by the API's names.
  Future<Result<String>> createStokvel({
    required String name,
    required Cents contribution,
    required CalendarDate firstDueDate,
  });

  /// Changes [cycle]'s target and due date, sent with the concurrency token
  /// it was read with. A stale token is a [ConflictFailure]: someone else
  /// changed it first.
  Future<Result<void>> updateCycle({
    required String stokvelId,
    required StokvelCycle cycle,
    required Cents target,
    required CalendarDate dueDate,
  });
}
