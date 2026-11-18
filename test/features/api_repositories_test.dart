import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/concurrency/concurrency_token.dart';
import 'package:ronditrack_app/core/data/api_client.dart';
import 'package:ronditrack_app/core/data/generated/rondi_track_api.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/features/activity/data/api_activity_repository.dart';
import 'package:ronditrack_app/features/auth/data/api_auth_repository.dart';
import 'package:ronditrack_app/features/home/data/api_home_repository.dart';
import 'package:ronditrack_app/features/invites/data/api_invite_repository.dart';
import 'package:ronditrack_app/features/payouts/data/api_payout_repository.dart';
import 'package:ronditrack_app/features/payouts/domain/payout_status.dart';
import 'package:ronditrack_app/features/stokvels/data/api_stokvel_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';

import '../helpers/api_fixtures.dart';
import '../helpers/fake_http_adapter.dart';
import '../helpers/result_matchers.dart';

const String _mabena = FakeSeed.mabenaFamilyId;
const String _cycle = FakeSeed.mabenaCycleId;
const _base = '/api/v1/stokvels/$_mabena';

/// The generated client over a fake adapter that answers [routes] by path
/// (`METHOD /path`); anything else is a 404 with the API's body.
({RondiTrackApi api, FakeHttpAdapter adapter, AccessTokenHolder tokens}) _api(
  Map<String, FakeAnswer Function(RequestOptions request)> routes,
) {
  final tokens = AccessTokenHolder();
  final adapter = FakeHttpAdapter((request) {
    final route = routes['${request.method} ${request.uri.path}'];
    return route?.call(request) ??
        Answer(404, apiFixtureText('problem_404_nonmember'));
  });
  final dio = createApiClient(
    baseUri: Uri.parse('http://127.0.0.1:8081'),
    tokens: tokens,
    onSessionEnded: () {},
    log: (_) {},
    adapter: adapter,
  );
  return (api: RondiTrackApi(dio), adapter: adapter, tokens: tokens);
}

/// The fixture [name], answered with status 200 and [headers].
FakeAnswer Function(RequestOptions) _ok(
  String name, {
  Map<String, List<String>> headers = const {},
}) =>
    (_) => Answer(200, apiFixtureText(name), headers: headers);

/// The fixture [name] with [change] applied to its JSON first.
FakeAnswer Function(RequestOptions) _okWith(
  String name,
  void Function(Map<String, Object?> json) change,
) => (_) {
  final json = apiFixture(name)! as Map<String, Object?>;
  change(json);
  return Answer(200, jsonEncode(json));
};

void main() {
  group('Home', () {
    test("Lerato's Home becomes her two entries: roles, Cents, SA due "
        'dates', () async {
      final client = _api({'GET /api/v1/me/home': _ok('home_lerato')});

      final home = (await ApiHomeRepository(
        client.api,
      ).fetchHome()).valueOrThrow;

      expect(home.map((e) => (e.stokvelName, e.membership.role)), [
        ('Mabena Family', StokvelRole.treasurer),
        ('Soweto Teachers', StokvelRole.member),
      ]);
      final soweto = home[1];
      expect(soweto.amountPaid, const Cents(75000));
      expect(soweto.amountOwed, const Cents(75000));
      expect(soweto.arrears, Cents.zero);
      expect(soweto.currentCycle!.status, CycleStatus.open);
      // "2026-11-25": the 25th of November, a calendar day, not an instant.
      expect(soweto.currentCycle!.dueDate, CalendarDate(2026, 11, 25));
      expect(soweto.nextPayoutDate, isNull);
    });

    test('a status or role the app has never seen is unknown, not a '
        'crash', () async {
      final client = _api({
        'GET /api/v1/me/home': _okWith('home_sipho', (json) {
          final first =
              (json['stokvels']! as List<Object?>).first!
                  as Map<String, Object?>;
          first['role'] = 'Auditor';
          (first['currentCycle']! as Map<String, Object?>)['status'] =
              'Suspended';
        }),
      });

      final home = (await ApiHomeRepository(
        client.api,
      ).fetchHome()).valueOrThrow;

      expect(home.first.membership.role, StokvelRole.unknown);
      expect(home.first.currentCycle!.status, CycleStatus.unknown);
      expect(home.first.arrears, const Cents(25000));
    });

    test('a wrong case is unknown too: "open" is not "Open"', () async {
      final client = _api({
        'GET /api/v1/me/home': _okWith('home_lerato', (json) {
          final first =
              (json['stokvels']! as List<Object?>).first!
                  as Map<String, Object?>;
          (first['currentCycle']! as Map<String, Object?>)['status'] = 'open';
        }),
      });

      final home = (await ApiHomeRepository(
        client.api,
      ).fetchHome()).valueOrThrow;
      expect(home.first.currentCycle!.status, CycleStatus.unknown);
    });

    test("a body the models can't read is a server failure", () async {
      final client = _api({
        'GET /api/v1/me/home': (_) => const Answer(200, '{"stokvels": 7}'),
      });

      expect(
        await ApiHomeRepository(client.api).fetchHome(),
        failsWith<ServerFailure>(),
      );
    });
  });

  group('a stokvel', () {
    test('becomes its detail: ETag kept exactly as sent, every page of '
        'contributions, the end marker read as "no more"', () async {
      final page2 = <String, Object?>{
        ...(apiFixture('contributions_all')! as Map<String, Object?>),
      };
      final firstPage = <String, Object?>{
        ...page2,
        'items': [(page2['items']! as List<Object?>).first],
        'nextPageToken': 'eyJTb3J0QnkiOiJyZWNvcmRlZEF0VXRjIn0=',
        'hasMore': true,
      };
      final secondPage = <String, Object?>{
        ...page2,
        'items': [(page2['items']! as List<Object?>).last],
        'nextPageToken': '',
        'hasMore': false,
      };
      final client = _api({
        'GET $_base': _ok(
          'stokvel_mabena_lerato',
          headers: {
            'etag': ['"2324"'],
          },
        ),
        'GET $_base/cycles/$_cycle/contributions': (request) => Answer(
          200,
          jsonEncode(
            request.uri.queryParameters['pageToken'] == null
                ? firstPage
                : secondPage,
          ),
        ),
      });

      final detail = (await ApiStokvelRepository(
        client.api,
      ).fetchStokvel(_mabena)).valueOrThrow;

      expect(detail.stokvel.concurrencyToken, const ConcurrencyToken('"2324"'));
      expect(detail.stokvel.contributionAmount, const Cents(50000));
      expect(detail.membership.role, StokvelRole.treasurer);
      expect(detail.currentCycle!.id, _cycle);
      expect(detail.currentCycle!.dueDate, CalendarDate(2026, 11, 30));
      expect(detail.currentCycle!.collected, const Cents(100000));
      expect(detail.contributions.map((c) => c.memberName), [
        'Lerato Mokoena',
        'Nomsa Mabena',
      ]);
      expect(detail.contributions.first.recordedAt.isUtc, isTrue);
      expect(detail.contributions.last.status, ContributionStatus.confirmed);

      final pages = [
        for (final r in client.adapter.requests)
          if (r.uri.path.endsWith('/contributions'))
            r.uri.queryParameters['pageToken'],
      ];
      expect(pages, [null, 'eyJTb3J0QnkiOiJyZWNvcmRlZEF0VXRjIn0=']);
    });

    test("a non-member's 404 is not found", () async {
      final client = _api({});
      expect(
        await ApiStokvelRepository(client.api).fetchStokvel(_mabena),
        failsWith<NotFoundFailure>(),
      );
    });

    test('a cycle: three calls together, and a 404 among them is still not '
        'found', () async {
      final client = _api({
        'GET $_base': _ok('stokvel_mabena_lerato'),
        'GET $_base/cycles/$_cycle/contributions': _ok('contributions_all'),
      });

      expect(
        await ApiStokvelRepository(client.api).fetchCycle(_mabena, _cycle),
        failsWith<NotFoundFailure>(),
      );
    });

    test("a cycle, all three answered: the summary, with the cycle's "
        'ETag', () async {
      final client = _api({
        'GET $_base': _ok('stokvel_mabena_lerato'),
        'GET $_base/cycles/$_cycle': _ok(
          'cycle_mabena',
          headers: {
            'etag': ['"2324"'],
          },
        ),
        'GET $_base/cycles/$_cycle/contributions': _ok('contributions_all'),
      });

      final detail = (await ApiStokvelRepository(
        client.api,
      ).fetchCycle(_mabena, _cycle)).valueOrThrow;

      expect(detail.cycle.membersPaid, 2);
      expect(detail.cycle.target, const Cents(150000));
      expect(detail.cycle.concurrencyToken, const ConcurrencyToken('"2324"'));
      expect(detail.contributions, hasLength(2));
    });

    test('the close preview keeps its version exactly as sent', () async {
      final client = _api({
        'GET $_base/cycles/$_cycle/close/preview': _ok('close_preview_lerato'),
      });

      final preview = (await ApiStokvelRepository(
        client.api,
      ).fetchClosePreview(_mabena, _cycle)).valueOrThrow;

      expect(
        preview.version,
        const ConcurrencyToken(
          'BD351F68D58C795CB70501C5837CDE07D46C813A74762603221D733763954CD6',
        ),
      );
      expect(preview.asOf, CalendarDate(2026, 11, 18));
      expect(preview.total, const Cents(50000));
    });

    test("a Member's close preview is the API's 403: forbidden", () async {
      final client = _api({
        'GET $_base/cycles/$_cycle/close/preview': (_) =>
            Answer(403, apiFixtureText('problem_403_member')),
      });
      expect(
        await ApiStokvelRepository(client.api)
            .fetchClosePreview(_mabena, _cycle),
        failsWith<ForbiddenFailure>(),
      );
    });
  });

  test('payouts: statuses into the enum, a new one unknown, paidAt in '
      'UTC', () async {
    final client = _api({
      'GET $_base/cycles/$_cycle/payouts': _okWith('payouts_mabena', (json) {
        final items = json['items']! as List<Object?>;
        (items.last! as Map<String, Object?>)['status'] = 'Skipped';
      }),
    });

    final order = (await ApiPayoutRepository(
      client.api,
    ).fetchPayoutOrder(_mabena, _cycle)).valueOrThrow;

    expect(order.entries.map((e) => e.status), [
      PayoutStatus.paid,
      PayoutStatus.next,
      PayoutStatus.unknown,
    ]);
    expect(order.entries.first.paidAt!.isUtc, isTrue);
    expect(order.entries.first.amount, const Cents(150000));
  });

  test('an invite joins, and the stokvel id comes from the preview, since '
      'the join answers 204', () async {
    final client = _api({
      'GET /api/v1/invites/MABENA26': _ok('invite_mabena'),
      'POST /api/v1/invites/MABENA26/join': (_) => const Answer(204, ''),
    });

    expect(
      (await ApiInviteRepository(client.api).join('MABENA26')).valueOrThrow,
      _mabena,
    );
  });

  test("activity: each stokvel's current-cycle contributions, newest "
      'first', () async {
    final client = _api({
      'GET /api/v1/me/home': _okWith('home_lerato', (json) {
        (json['stokvels']! as List<Object?>).removeLast();
      }),
      'GET $_base': _ok('stokvel_mabena_lerato'),
      'GET $_base/cycles/$_cycle/contributions': _ok('contributions_all'),
    });

    final items = (await ApiActivityRepository(
      client.api,
    ).fetchActivity()).valueOrThrow;

    expect(items.map((i) => (i.memberName, i.stokvelName)), [
      ('Lerato Mokoena', 'Mabena Family'),
      ('Nomsa Mabena', 'Mabena Family'),
    ]);
  });

  group('sign-in', () {
    test('signs in with the seed password, keeps the token in memory and '
        'asks who that is', () async {
      final client = _api({
        'POST /api/v1/auth/login': (_) => const Answer(
          200,
          '{"accessToken":"t0k3n","expiresAtUtc":"2026-11-18T06:00:00Z"}',
        ),
        'GET /api/v1/me': (_) => Answer(
          200,
          jsonEncode({
            'id': FakeSeed.lerato.id,
            'name': 'Lerato Mokoena',
            'email': 'lerato@ronditrack.example',
            'version': 1,
          }),
        ),
      });

      final user = (await ApiAuthRepository(
        client.api,
        client.tokens,
        seedPassword: 'pw-from-dart-define',
      ).signIn(email: ' lerato@ronditrack.example ')).valueOrThrow;

      expect(user.id, FakeSeed.lerato.id);
      expect(client.tokens.token, 't0k3n');
      final login = client.adapter.requests.first;
      expect(login.data, {
        'email': 'lerato@ronditrack.example',
        'password': 'pw-from-dart-define',
      });
      expect(
        client.adapter.requests.last.headers['Authorization'],
        'Bearer t0k3n',
      );
    });

    test("a refused password is the sign-in's own words, and no token is "
        'kept', () async {
      final client = _api({
        'POST /api/v1/auth/login': (_) =>
            Answer(401, apiFixtureText('problem_401_login')),
      });

      final result = await ApiAuthRepository(
        client.api,
        client.tokens,
        seedPassword: 'wrong',
      ).signIn(email: 'lerato@ronditrack.example');

      expect(result, failsWith<UnauthorisedFailure>());
      expect(
        failureIn(result),
        isA<UnauthorisedFailure>().having((f) => f.atSignIn, 'atSignIn', true),
      );
      expect(client.tokens.token, isNull);
    });

    test('too many sign-ins: the wait from Retry-After', () async {
      final client = _api({
        'POST /api/v1/auth/login': (_) => Answer(
          429,
          apiFixtureText('problem_429'),
          headers: {
            'retry-after': ['60'],
          },
        ),
      });

      final result = await ApiAuthRepository(
        client.api,
        client.tokens,
        seedPassword: 'x',
      ).signIn(email: 'lerato@ronditrack.example');

      expect(
        failureIn(result).message,
        'Too many attempts. Wait 60 seconds, then try again.',
      );
    });

    test('signing out forgets the token even when the API is '
        'unreachable', () async {
      final client = _api({'POST /api/v1/auth/logout': (_) => const NoAnswer()})
        ..tokens.token = 't0k3n';

      await ApiAuthRepository(
        client.api,
        client.tokens,
        seedPassword: 'x',
      ).signOut();

      expect(client.tokens.token, isNull);
    });
  });
}
