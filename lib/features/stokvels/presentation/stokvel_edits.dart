import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';

part 'stokvel_edits.g.dart';

/// Creating a stokvel and editing a cycle, for the forms: they never see
/// which editor (the API's or the fakes') does it.
///
/// Lifetime: autoDispose; it holds nothing.
@riverpod
class StokvelEdits extends _$StokvelEdits {
  @override
  void build() {}

  /// Creates a stokvel and its first cycle; its id.
  Future<Result<String>> create({
    required String name,
    required Cents contribution,
    required CalendarDate firstDueDate,
  }) => ref
      .read(stokvelEditorProvider)
      .createStokvel(
        name: name,
        contribution: contribution,
        firstDueDate: firstDueDate,
      );

  /// Changes [cycle]'s target and due date, with the token it was read
  /// with.
  Future<Result<void>> updateCycle({
    required String stokvelId,
    required StokvelCycle cycle,
    required Cents target,
    required CalendarDate dueDate,
  }) => ref
      .read(stokvelEditorProvider)
      .updateCycle(
        stokvelId: stokvelId,
        cycle: cycle,
        target: target,
        dueDate: dueDate,
      );
}
