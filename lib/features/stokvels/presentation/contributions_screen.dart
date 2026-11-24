import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/money/rand_format.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/core/time/sast.dart';
import 'package:ronditrack_app/core/widgets/message_panel.dart';
import 'package:ronditrack_app/features/stokvels/domain/contributions_list.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/presentation/contributions_list_controller.dart';
import 'package:ronditrack_app/l10n/generated/app_localizations.dart';
import 'package:ronditrack_app/l10n/locale_dates.dart';

/// A contribution's status in words, in the person's language: never a
/// colour alone. "Late" is a contribution recorded after its cycle's due
/// date, on South African days.
String contributionStatusWords(
  AppLocalizations l10n,
  Contribution contribution, {
  CalendarDate? dueDate,
}) {
  final words = switch (contribution.status) {
    ContributionStatus.paid => l10n.statusPaid,
    ContributionStatus.pending => l10n.statusPending,
    ContributionStatus.confirmed => l10n.statusConfirmed,
    ContributionStatus.unknown => l10n.statusUnknown,
  };
  final late =
      dueDate != null &&
      Sast.dayOf(contribution.recordedAt).compareTo(dueDate) > 0;
  return late ? '$words · ${l10n.statusLate}' : words;
}

/// `/stokvels/:id/contributions`: every contribution to one of the
/// stokvel's cycles, newest first, a page at a time, filtered by cycle,
/// status, member and South African days.
class ContributionsScreen extends StatelessWidget {
  /// Creates the screen for [stokvelId].
  const new({required this.stokvelId, super.key});

  /// The stokvel.
  final String stokvelId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.contributionsTitle)),
      body: Column(
        children: [
          _Filters(stokvelId: stokvelId),
          Expanded(child: _ContributionBody(stokvelId: stokvelId)),
        ],
      ),
    );
  }
}

class _ContributionBody extends ConsumerWidget {
  const new({required this.stokvelId});

  final String stokvelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = contributionsListProvider(stokvelId);
    final list = ref.watch(
      provider.select(
        (state) => (
          phase: state.phase,
          rows: state.rows,
          filter: state.filter,
          failure: state.failure,
        ),
      ),
    );
    final controller = ref.read(provider.notifier);
    final cycles = ref.watch(contributionCyclesProvider(stokvelId)).value;
    final dueDate = cycles
        ?.where((cycle) => cycle.id == list.filter?.cycleId)
        .firstOrNull
        ?.dueDate;

    return switch (list.phase) {
      ListPhase.firstLoading => Center(
        key: const Key('list-first-loading'),
        child: CircularProgressIndicator(semanticsLabel: l10n.listLoading),
      ),
      ListPhase.nothingAtAll => MessagePanel(
        key: const Key('list-nothing'),
        title: l10n.listEmpty,
        action: OutlinedButton(
          onPressed: controller.refresh,
          child: Text(l10n.tryAgain),
        ),
      ),
      ListPhase.nothingForFilters => MessagePanel(
        key: const Key('list-nothing-for-filters'),
        title: l10n.listEmptyFiltered,
        action: FilledButton(
          key: const Key('list-clear-filters'),
          onPressed: () => controller.setFilter(list.filter!.cleared()),
          child: Text(l10n.filterClear),
        ),
      ),
      ListPhase.firstFailed => MessagePanel(
        key: const Key('list-first-failed'),
        title: l10n.listFailed,
        body: list.failure?.message,
        reference: list.failure?.reference,
        action: FilledButton(
          onPressed: controller.retry,
          child: Text(l10n.tryAgain),
        ),
      ),
      ListPhase.rows ||
      ListPhase.end ||
      ListPhase.moreFailed => RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView.builder(
          key: const Key('list-rows'),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: list.rows.length + 1,
          itemBuilder: (context, index) => index < list.rows.length
              ? _Row(contribution: list.rows[index], dueDate: dueDate)
              : _Footer(stokvelId: stokvelId),
        ),
      ),
    };
  }
}

class _Filters extends ConsumerWidget {
  const new({required this.stokvelId});

  final String stokvelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = contributionsListProvider(stokvelId);
    final filter = ref.watch(provider.select((state) => state.filter));
    if (filter == null) return const SizedBox.shrink();
    final controller = ref.read(provider.notifier);
    final cycles = ref.watch(contributionCyclesProvider(stokvelId)).value;
    final members = ref.watch(contributionMembersProvider(stokvelId)).value;
    final first = filter.firstDay;
    final last = filter.lastDay ?? first;

    Future<void> pickDays() async {
      final today = Sast.today(DateTime.now());
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(today.year - 2),
        lastDate: DateTime(today.year, today.month, today.day),
        initialDateRange: first == null || last == null
            ? null
            : DateTimeRange(
                start: DateTime(first.year, first.month, first.day),
                end: DateTime(last.year, last.month, last.day),
              ),
      );
      if (picked == null) return;
      // The days a person picks are calendar days: South African days,
      // whatever zone the phone is in.
      await controller.setFilter(
        ContributionFilter(
          cycleId: filter.cycleId,
          status: filter.status,
          userId: filter.userId,
          firstDay: CalendarDate(
            picked.start.year,
            picked.start.month,
            picked.start.day,
          ),
          lastDay: CalendarDate(
            picked.end.year,
            picked.end.month,
            picked.end.day,
          ),
        ),
      );
    }

    final dayWords = first == null || last == null
        ? l10n.filterAnyDay
        : first == last
        ? l10n.filterOneDay(formatDay(l10n.localeName, first))
        : l10n.filterDayRange(
            formatDay(l10n.localeName, first),
            formatDay(l10n.localeName, last),
          );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (cycles case final cycles? when cycles.length > 1)
            DropdownButton<String>(
              key: const Key('filter-cycle'),
              value: filter.cycleId,
              hint: Text(l10n.filterCycle),
              items: [
                for (final c in cycles)
                  DropdownMenuItem(value: c.id, child: Text(c.period)),
              ],
              onChanged: (id) => id == null
                  ? null
                  : controller.setFilter(ContributionFilter(cycleId: id)),
            ),
          for (final status in [
            null,
            ContributionStatus.pending,
            ContributionStatus.paid,
            ContributionStatus.confirmed,
          ])
            ChoiceChip(
              key: Key('filter-status-${status?.name ?? 'all'}'),
              label: Text(switch (status) {
                null => l10n.filterAll,
                ContributionStatus.pending => l10n.statusPending,
                ContributionStatus.paid => l10n.statusPaid,
                ContributionStatus.confirmed => l10n.statusConfirmed,
                ContributionStatus.unknown => l10n.statusUnknown,
              }),
              selected: filter.status == status,
              onSelected: (_) => controller.setFilter(
                ContributionFilter(
                  cycleId: filter.cycleId,
                  status: status,
                  userId: filter.userId,
                  firstDay: filter.firstDay,
                  lastDay: filter.lastDay,
                ),
              ),
            ),
          if (members != null)
            DropdownButton<String?>(
              key: const Key('filter-member'),
              value: filter.userId,
              hint: Text(l10n.filterMember),
              items: [
                DropdownMenuItem(child: Text(l10n.filterAnyone)),
                for (final m in members)
                  DropdownMenuItem(value: m.userId, child: Text(m.name)),
              ],
              onChanged: (userId) => controller.setFilter(
                ContributionFilter(
                  cycleId: filter.cycleId,
                  status: filter.status,
                  userId: userId,
                  firstDay: filter.firstDay,
                  lastDay: filter.lastDay,
                ),
              ),
            ),
          OutlinedButton.icon(
            key: const Key('filter-dates'),
            onPressed: pickDays,
            icon: const Icon(Icons.date_range),
            label: Text(dayWords),
          ),
          if (filter.isNarrowed)
            TextButton(
              key: const Key('filter-clear'),
              onPressed: () => controller.setFilter(filter.cleared()),
              child: Text(l10n.filterClear),
            ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const new({required this.contribution, this.dueDate});

  final Contribution contribution;
  final CalendarDate? dueDate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final day = formatDay(l10n.localeName, Sast.dayOf(contribution.recordedAt));
    final status = contributionStatusWords(
      l10n,
      contribution,
      dueDate: dueDate,
    );
    return ListTile(
      key: Key('contribution-${contribution.id}'),
      title: Text(contribution.memberName),
      subtitle: Text(l10n.recordedOn(day)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(formatRand(contribution.amount)),
          Text(status, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _Footer extends ConsumerStatefulWidget {
  const new({required this.stokvelId});

  final String stokvelId;

  @override
  ConsumerState<_Footer> createState() => _FooterState();
}

class _FooterState extends ConsumerState<_Footer> {
  @override
  void initState() {
    super.initState();
    _askIfNear();
  }

  @override
  void didUpdateWidget(_Footer old) {
    super.didUpdateWidget(old);
    _askIfNear();
  }

  void _askIfNear() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = ref.read(contributionsListProvider(widget.stokvelId));
      if (state.phase == ListPhase.rows && !state.loading) {
        unawaited(
          ref
              .read(contributionsListProvider(widget.stokvelId).notifier)
              .loadMore(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(
      contributionsListProvider(widget.stokvelId).select(
        (state) => (
          phase: state.phase,
          loading: state.loading,
          failure: state.failure,
          rowCount: state.rows.length,
        ),
      ),
    );
    ref.listen(
      contributionsListProvider(widget.stokvelId)
          .select((state) => (state.phase, state.loading)),
      (_, _) => _askIfNear(),
    );
    return Padding(
      padding: const EdgeInsets.all(16),
      child: switch (state.phase) {
        ListPhase.moreFailed => Column(
          key: const Key('list-more-failed'),
          children: [
            Text(l10n.listMoreFailed),
            if (state.failure case final Failure failure)
              Text(failure.message, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: ref
                  .read(contributionsListProvider(widget.stokvelId).notifier)
                  .retry,
              child: Text(l10n.tryAgain),
            ),
          ],
        ),
        ListPhase.end => Text(
          l10n.listEnd(state.rowCount),
          key: const Key('list-end'),
          textAlign: TextAlign.center,
        ),
        _ => const Center(
          key: Key('list-more-loading'),
          child: CircularProgressIndicator(),
        ),
      },
    );
  }
}
