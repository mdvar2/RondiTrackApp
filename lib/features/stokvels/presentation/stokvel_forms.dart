import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/app/router/routes.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/money/rand_format.dart';
import 'package:ronditrack_app/core/money/rand_parser.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/core/time/sast.dart';
import 'package:ronditrack_app/core/widgets/message_panel.dart';
import 'package:ronditrack_app/features/home/presentation/home_controller.dart';
import 'package:ronditrack_app/features/payments/presentation/payment_words.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_editor.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_detail_provider.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_edits.dart';
import 'package:ronditrack_app/l10n/generated/app_localizations.dart';
import 'package:ronditrack_app/l10n/locale_dates.dart';

/// Rands typed into [text] as cents, or the words for why not.
({Cents? cents, String? error}) readRands(AppLocalizations l10n, String text) =>
    switch (parseRand(text)) {
      RandRefused(:final reason) => (
        cents: null,
        error: randErrorMessage(l10n, reason),
      ),
      RandParsed(:final cents) when cents.value <= 0 => (
        cents: null,
        error: l10n.amountZero,
      ),
      RandParsed(:final cents) => (cents: cents, error: null),
    };

/// The API's field errors, by the form's fields.
Map<StokvelField, String> fieldErrorsOf(Failure failure) => switch (failure) {
  ValidationFailure(:final fieldErrors) => {
    for (final MapEntry(:key, :value) in fieldErrors.entries)
      ?stokvelFieldsByApiName[key]: value.join(' '),
  },
  _ => const {},
};

/// A date field: shows the day, opens a picker. The day is a calendar day,
/// as picked: no time, no zone.
class DayField extends StatelessWidget {
  /// Creates the field.
  const new({
    required this.label,
    required this.day,
    required this.onPicked,
    required this.enabled,
    this.errorText,
    super.key,
  });

  /// What the date is.
  final String label;

  /// The day chosen, if any.
  final CalendarDate? day;

  /// Called with the day picked.
  final ValueChanged<CalendarDate> onPicked;

  /// Whether it can be changed.
  final bool enabled;

  /// What is wrong with it.
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final day = this.day;
    Future<void> pick() async {
      final today = Sast.today(DateTime.now());
      final initial = day ?? today;
      final picked = await showDatePicker(
        context: context,
        firstDate: DateTime(today.year - 1),
        lastDate: DateTime(today.year + 2),
        initialDate: DateTime(initial.year, initial.month, initial.day),
      );
      if (picked != null) {
        onPicked(CalendarDate(picked.year, picked.month, picked.day));
      }
    }

    return InkWell(
      onTap: enabled ? pick : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          errorText: errorText,
          errorMaxLines: 3,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          day == null ? l10n.createPickDate : formatDay(l10n.localeName, day),
        ),
      ),
    );
  }
}

/// `/stokvels/new`: a stokvel's name, its contribution in rands, and its
/// first due date. What was typed stays on a failure; each of the API's
/// field errors appears under its field.
class CreateStokvelScreen extends ConsumerStatefulWidget {
  /// Creates the form.
  const new({super.key});

  @override
  ConsumerState<CreateStokvelScreen> createState() => _CreateState();
}

class _CreateState extends ConsumerState<CreateStokvelScreen> {
  final _name = TextEditingController();
  final _amount = TextEditingController();
  CalendarDate? _due;
  bool _busy = false;
  Map<StokvelField, String> _errors = const {};
  String? _message;

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _create(AppLocalizations l10n) async {
    final amount = readRands(l10n, _amount.text);
    final errors = <StokvelField, String>{
      if (_name.text.trim().isEmpty) StokvelField.name: l10n.createNameRequired,
      StokvelField.amount: ?amount.error,
      if (_due == null) StokvelField.dueDate: l10n.createDueDateRequired,
    };
    setState(() {
      _errors = errors;
      _message = null;
    });
    if (errors.isNotEmpty) return;
    setState(() => _busy = true);
    final result = await ref
        .read(stokvelEditsProvider.notifier)
        .create(
          name: _name.text,
          contribution: amount.cents!,
          firstDueDate: _due!,
        );
    if (!mounted) return;
    switch (result) {
      case Ok(value: final id):
        ref.invalidate(homeControllerProvider);
        StokvelRoute(id: id).go(context);
      case Err(:final failure):
        setState(() {
          _busy = false;
          _errors = fieldErrorsOf(failure);
          _message = _errors.isEmpty ? failure.message : null;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.createTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            key: const Key('create-name'),
            controller: _name,
            enabled: !_busy,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: l10n.createName,
              border: const OutlineInputBorder(),
              errorText: _errors[StokvelField.name],
              errorMaxLines: 3,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            key: const Key('create-amount'),
            controller: _amount,
            enabled: !_busy,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.createAmount,
              hintText: l10n.payAmountHint,
              prefixText: 'R ',
              border: const OutlineInputBorder(),
              errorText: _errors[StokvelField.amount],
              errorMaxLines: 3,
            ),
          ),
          const SizedBox(height: 16),
          DayField(
            key: const Key('create-due'),
            label: l10n.createDueDate,
            day: _due,
            enabled: !_busy,
            errorText: _errors[StokvelField.dueDate],
            onPicked: (day) => setState(() => _due = day),
          ),
          if (_message case final message?) ...[
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            key: const Key('create-submit'),
            onPressed: _busy ? null : () => _create(l10n),
            child: Text(_busy ? l10n.createBusy : l10n.createButton),
          ),
        ],
      ),
    );
  }
}

/// `/stokvels/:id/cycles/:cycleId/edit`: a treasurer changes the cycle's
/// target and due date, sent with the ETag it was read with.
///
/// If someone else saved first (the API's `412`), the edit is rolled back:
/// the cycle is fetched again, the form shows the latest values, and the
/// person is told in plain words, not the API's.
class EditCycleScreen extends ConsumerStatefulWidget {
  /// Creates the form for cycle [cycleId] of stokvel [stokvelId].
  const new({required this.stokvelId, required this.cycleId, super.key});

  /// The stokvel.
  final String stokvelId;

  /// The cycle.
  final String cycleId;

  @override
  ConsumerState<EditCycleScreen> createState() => _EditState();
}

class _EditState extends ConsumerState<EditCycleScreen> {
  final _target = TextEditingController();
  CalendarDate? _due;
  Object? _filledFrom;
  bool _busy = false;
  bool _stale = false;
  Map<StokvelField, String> _errors = const {};
  String? _message;

  @override
  void dispose() {
    _target.dispose();
    super.dispose();
  }

  void _fill(StokvelCycle cycle) {
    final token = (cycle.concurrencyToken?.value, cycle.target, cycle.dueDate);
    if (_filledFrom == token) return;
    _filledFrom = token;
    _target.text = formatRand(cycle.target).replaceFirst('R ', '');
    _due = cycle.dueDate;
  }

  Future<void> _save(AppLocalizations l10n, StokvelCycle cycle) async {
    final target = readRands(l10n, _target.text);
    final errors = <StokvelField, String>{
      StokvelField.amount: ?target.error,
      if (_due == null) StokvelField.dueDate: l10n.createDueDateRequired,
    };
    setState(() {
      _errors = errors;
      _message = null;
      _stale = false;
    });
    if (errors.isNotEmpty) return;
    setState(() => _busy = true);
    final result = await ref
        .read(stokvelEditsProvider.notifier)
        .updateCycle(
          stokvelId: widget.stokvelId,
          cycle: cycle,
          target: target.cents!,
          dueDate: _due!,
        );
    if (!mounted) return;
    void refreshEverywhere() => ref
      ..invalidate(cycleDetailProvider(widget.stokvelId, widget.cycleId))
      ..invalidate(stokvelDetailProvider(widget.stokvelId))
      ..invalidate(homeControllerProvider);
    switch (result) {
      case Ok():
        refreshEverywhere();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.editCycleSaved)));
        Navigator.of(context).maybePop();
      case Err(failure: ConflictFailure()):
        // Rolled back: the latest from the server replaces the edit.
        _filledFrom = null;
        refreshEverywhere();
        setState(() {
          _busy = false;
          _stale = true;
        });
      case Err(:final failure):
        setState(() {
          _busy = false;
          _errors = fieldErrorsOf(failure);
          _message = _errors.isEmpty ? failure.message : null;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = cycleDetailProvider(widget.stokvelId, widget.cycleId);
    final view = cycleDetailViewState(ref.watch(provider));
    return Scaffold(
      appBar: AppBar(
        title: Text(switch (view) {
          ViewData(value: final d) => l10n.editCycleTitle(d.cycle.period),
          _ => l10n.editCycle,
        }),
      ),
      body: switch (view) {
        ViewLoading() ||
        ViewEmpty() => const Center(child: CircularProgressIndicator()),
        ViewFailure(:final message, :final reference) => MessagePanel(
          title: message,
          reference: reference,
          action: FilledButton(
            onPressed: () => ref.invalidate(provider),
            child: Text(l10n.tryAgain),
          ),
        ),
        ViewData(value: final detail) => _form(l10n, detail.cycle),
      },
    );
  }

  Widget _form(AppLocalizations l10n, StokvelCycle cycle) {
    _fill(cycle);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_stale) ...[
          Semantics(
            liveRegion: true,
            child: Card(
              key: const Key('edit-stale'),
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(l10n.editCycleStale),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        TextField(
          key: const Key('edit-target'),
          controller: _target,
          enabled: !_busy,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: l10n.editCycleTarget,
            prefixText: 'R ',
            border: const OutlineInputBorder(),
            errorText: _errors[StokvelField.amount],
            errorMaxLines: 3,
          ),
        ),
        const SizedBox(height: 16),
        DayField(
          key: const Key('edit-due'),
          label: l10n.editCycleDueDate,
          day: _due,
          enabled: !_busy,
          errorText: _errors[StokvelField.dueDate],
          onPicked: (day) => setState(() => _due = day),
        ),
        if (_message case final message?) ...[
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          key: const Key('edit-submit'),
          onPressed: _busy ? null : () => _save(l10n, cycle),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
