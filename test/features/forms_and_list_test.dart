import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/app/settings.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/features/payments/presentation/pay_screen.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_stokvel_writes.dart';
import 'package:ronditrack_app/features/stokvels/domain/contributions_list.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_editor.dart';
import 'package:ronditrack_app/l10n/generated/app_localizations.dart';

import '../helpers/app_harness.dart';

const String _mabena = FakeSeed.mabenaFamilyId;
const String _cycle = FakeSeed.mabenaCycleId;
const String _pay = '/stokvels/$_mabena/cycles/$_cycle/pay';
const String _list = '/stokvels/$_mabena/contributions';

String? _errorUnder(WidgetTester tester, String key) =>
    tester.widget<TextField>(find.byKey(Key(key))).decoration!.errorText;

/// An editor whose create is refused with the API's field errors.
class _RefusingEditor implements StokvelEditor {
  @override
  Future<Result<String>> createStokvel({
    required String name,
    required Cents contribution,
    required CalendarDate firstDueDate,
  }) async => const Err(
    ValidationFailure(
      fieldErrors: {
        'name': ['A stokvel with this name already exists.'],
        'contributionAmount': [
          'Contribution amount must be R1 000 000 or less.',
        ],
        'endDate': ['The due date must be in the future.'],
      },
    ),
  );

  @override
  Future<Result<void>> updateCycle({
    required String stokvelId,
    required StokvelCycle cycle,
    required Cents target,
    required CalendarDate dueDate,
  }) async => const Err(ConflictFailure());
}

/// A list repository the test scripts, keeping every request.
class _Pages implements ContributionsRepository {
  final List<({ContributionFilter filter, String? token})> asked = [];
  final List<Result<ContributionPage>> answers = [];

  /// Holds every page until the test completes it.
  Completer<void>? gate;

  static Contribution row(int i, {ContributionStatus? status}) => Contribution(
    id: 'c$i',
    userId: 'u$i',
    memberName: 'Member $i',
    memberRole: StokvelRole.member,
    amount: const Cents(50000),
    status: status ?? ContributionStatus.paid,
    recordedAt: DateTime.utc(2026, 11, 1, 8).add(Duration(minutes: i)),
  );

  @override
  Future<Result<List<CycleOption>>> fetchCycles(String stokvelId) async => Ok([
    (id: _cycle, period: '2026-11', dueDate: CalendarDate(2026, 11, 30)),
  ]);

  @override
  Future<Result<List<MemberOption>>> fetchMembers(String stokvelId) async =>
      const Ok([(userId: 'u1', name: 'Member 1')]);

  @override
  Future<Result<ContributionPage>> fetchPage(
    String stokvelId,
    ContributionFilter filter, {
    String? pageToken,
    int pageSize = 25,
  }) async {
    asked.add((filter: filter, token: pageToken));
    await gate?.future;
    return answers.isEmpty
        ? const Ok(ContributionPage([]))
        : answers.removeAt(0);
  }
}

void main() {
  group('forms', () {
    testWidgets('pay: an amount that is not money is refused under the '
        'field, and what was typed stays', (tester) async {
      await pumpApp(tester, as: FakeSeed.sipho, size: phone, coldStart: _pay);

      await tester.enterText(find.byKey(const Key('pay-amount')), '1.500');
      await tester.tap(find.byKey(const Key('pay-submit')));
      await tester.pumpAndSettle();

      expect(
        _errorUnder(tester, 'pay-amount'),
        'Cents have two digits at most.',
      );
      expect(find.text('1.500'), findsOneWidget);
    });

    testWidgets("create stokvel: each of the API's field errors under its "
        'field, and what was typed stays', (tester) async {
      await pumpApp(
        tester,
        as: FakeSeed.thabo,
        size: phone,
        coldStart: '/stokvels/new',
        overrides: [stokvelEditorProvider.overrideWithValue(_RefusingEditor())],
      );

      await tester.enterText(find.byKey(const Key('create-name')), 'Kasi');
      await tester.enterText(find.byKey(const Key('create-amount')), '300');
      await tester.tap(find.byKey(const Key('create-due')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('create-submit')));
      await tester.pumpAndSettle();

      expect(
        _errorUnder(tester, 'create-name'),
        'A stokvel with this name already exists.',
      );
      expect(
        _errorUnder(tester, 'create-amount'),
        'Contribution amount must be R1 000 000 or less.',
      );
      expect(find.text('The due date must be in the future.'), findsOneWidget);
      expect(find.text('Kasi'), findsOneWidget);
      expect(find.text('300'), findsOneWidget);
    });

    testWidgets('a stale edit is rolled back: the latest from the server, '
        'and words a member understands', (tester) async {
      final app = await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: phone,
        coldStart: '/stokvels/$_mabena/cycles/$_cycle/edit',
      );
      // Someone else saves a new target first.
      (app.read(stokvelEditorProvider) as FakeStokvelEditor).changeElsewhere(
        _mabena,
        target: const Cents(180000),
      );

      await tester.enterText(find.byKey(const Key('edit-target')), '2 000');
      await tester.tap(find.byKey(const Key('edit-submit')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('edit-stale')), findsOneWidget);
      expect(
        tester
            .widget<TextField>(find.byKey(const Key('edit-target')))
            .controller!
            .text,
        '1 800,00',
      );
    });
  });

  group('the contributions list', () {
    testWidgets('a filter change starts again from the first page, with no '
        'token', (tester) async {
      final pages = _Pages()
        ..answers.addAll([
          Ok(
            ContributionPage([
              for (var i = 0; i < 20; i++) _Pages.row(i),
            ], nextPageToken: 'p2'),
          ),
          Ok(ContributionPage([_Pages.row(20)])),
          Ok(ContributionPage([_Pages.row(1)])),
        ]);
      await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: phone,
        coldStart: _list,
        overrides: [contributionsRepositoryProvider.overrideWithValue(pages)],
      );
      await tester.scrollUntilVisible(find.byKey(const Key('list-end')), 400);
      expect(pages.asked.map((a) => a.token), [null, 'p2']);

      await tester.tap(find.byKey(const Key('filter-status-pending')));
      await tester.pumpAndSettle();

      expect(pages.asked.last.token, isNull);
      expect(pages.asked.last.filter.status, ContributionStatus.pending);
    });

    for (final (name, key, answers) in [
      ('nothing at all', 'list-nothing', [const Ok(ContributionPage([]))]),
      (
        'the first page failed',
        'list-first-failed',
        [const Err<ContributionPage>(NoAnswerFailure())],
      ),
      (
        'the end, with its words',
        'list-end',
        [
          Ok(ContributionPage([_Pages.row(1)])),
        ],
      ),
    ]) {
      testWidgets('its own words: $name', (tester) async {
        final pages = _Pages()..answers.addAll(answers);
        await pumpApp(
          tester,
          as: FakeSeed.lerato,
          size: phone,
          coldStart: _list,
          overrides: [contributionsRepositoryProvider.overrideWithValue(pages)],
        );

        expect(find.byKey(Key(key)), findsOneWidget);
      });
    }

    testWidgets('its own words: nothing for these filters, with a way to '
        'clear them', (tester) async {
      final pages = _Pages()
        ..answers.addAll([
          Ok(ContributionPage([_Pages.row(1)])),
          const Ok(ContributionPage([])),
          Ok(ContributionPage([_Pages.row(1)])),
        ]);
      await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: phone,
        coldStart: _list,
        overrides: [contributionsRepositoryProvider.overrideWithValue(pages)],
      );
      await tester.tap(find.byKey(const Key('filter-status-pending')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('list-nothing-for-filters')), findsOneWidget);

      await tester.tap(find.byKey(const Key('list-clear-filters')));
      await tester.pumpAndSettle();

      expect(pages.asked.last.filter.isNarrowed, isFalse);
      expect(find.text('Member 1'), findsOneWidget);
    });

    testWidgets('its own words: first page loading', (tester) async {
      final pages = _Pages()..gate = Completer<void>();
      await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: phone,
        coldStart: _list,
        settle: false,
        overrides: [contributionsRepositoryProvider.overrideWithValue(pages)],
      );
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.byKey(const Key('list-first-loading')), findsOneWidget);
      pages.gate!.complete();
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('list-nothing')), findsOneWidget);
    });

    testWidgets('a later page failed: the rows so far stay, with Try again '
        'at the bottom', (tester) async {
      final pages = _Pages()
        ..answers.addAll([
          Ok(
            ContributionPage([
              for (var i = 0; i < 20; i++) _Pages.row(i),
            ], nextPageToken: 'p2'),
          ),
          const Err(NoAnswerFailure()),
        ]);
      await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: phone,
        coldStart: _list,
        overrides: [contributionsRepositoryProvider.overrideWithValue(pages)],
      );
      await tester.scrollUntilVisible(
        find.byKey(const Key('list-more-failed')),
        400,
      );

      expect(find.byKey(const Key('list-more-failed')), findsOneWidget);
      expect(find.text('Member 19'), findsOneWidget);
    });
  });

  group('languages and access', () {
    for (final (code, title, button) in [
      ('en', 'Pay Mabena Family', 'Pay'),
      ('af', 'Betaal aan Mabena Family', 'Betaal'),
    ]) {
      testWidgets('both languages render the pay form: $code', (tester) async {
        await pumpApp(
          tester,
          as: FakeSeed.sipho,
          size: phone,
          coldStart: _pay,
          overrides: [
            settingsStoreProvider.overrideWithValue(
              InMemorySettingsStore(language: code),
            ),
          ],
        );
        expect(find.text(title), findsOneWidget);
        expect(find.text(button), findsOneWidget);
      });
    }

    test("plurals by each language's own rules, never n == 1", () {
      final en = lookupAppLocalizations(const Locale('en'));
      final af = lookupAppLocalizations(const Locale('af'));
      expect(
        [
          for (final n in [0, 1, 6]) en.memberCount(n),
        ],
        ['No members', '1 member', '6 members'],
      );
      expect(
        [
          for (final n in [0, 1, 6]) af.memberCount(n),
        ],
        ['Geen lede nie', '1 lid', '6 lede'],
      );
      expect(af.contributionCount(1), '1 bydrae');
      expect(af.contributionCount(6), '6 bydraes');
    });

    for (final (name, persona, address) in [
      ('the pay form', FakeSeed.sipho, _pay),
      ('the list', FakeSeed.lerato, _list),
    ]) {
      testWidgets('$name meets the 48 dp tap target guideline', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpApp(tester, as: persona, size: phone, coldStart: address);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        handle.dispose();
      });
    }

    for (final (code, paid) in [('en', 'Paid'), ('af', 'Betaal')]) {
      testWidgets('statuses have words, not only a colour: $code', (
        tester,
      ) async {
        await pumpApp(
          tester,
          as: FakeSeed.lerato,
          size: phone,
          coldStart: _list,
          overrides: [
            settingsStoreProvider.overrideWithValue(
              InMemorySettingsStore(language: code),
            ),
          ],
        );
        // In the rows themselves, not the filter chips.
        expect(
          find.descendant(
            of: find.byType(ListTile),
            matching: find.textContaining(paid),
          ),
          findsWidgets,
        );
      });
    }

    testWidgets('at 200% text the pay form has every field labelled and '
        'nothing overflowing', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpApp(
        tester,
        as: FakeSeed.sipho,
        size: phone,
        textScale: 2,
        coldStart: _pay,
      );

      expect(tester.takeException(), isNull);
      expect(find.bySemanticsLabel(RegExp('Amount in rand')), findsOneWidget);
      expect(find.byType(PayScreen), findsOneWidget);
      handle.dispose();
    });
  });
}
