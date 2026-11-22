import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/core/session/refresh_token_store.dart';
import 'package:ronditrack_app/features/activity/presentation/activity_screen.dart';
import 'package:ronditrack_app/features/auth/data/api_auth_repository.dart';
import 'package:ronditrack_app/features/auth/domain/auth_repository.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/domain/auth_user.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/auth/presentation/register_screen.dart';
import 'package:ronditrack_app/features/auth/presentation/sign_in_screen.dart';
import 'package:ronditrack_app/features/auth/presentation/splash_screen.dart';
import 'package:ronditrack_app/features/home/presentation/home_screen.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fake_auth_server.dart';

/// Restores with whatever the test hands it, one call at a time.
class _ScriptedRestore implements AuthRepository {
  new(this.answers);

  final List<Completer<Result<AuthUser?>>> answers;
  int restores = 0;

  @override
  Future<Result<AuthUser?>> restore() => answers[restores++].future;

  @override
  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  }) async => const Err(UnauthorisedFailure(atSignIn: true));

  @override
  Future<Result<AuthUser>> register({
    required String name,
    required String email,
    required String password,
  }) async => const Err(UnauthorisedFailure(atSignIn: true));

  @override
  Future<void> signOut() async {}
}

final _lerato = AuthUser(
  id: FakeSeed.lerato.id,
  name: FakeSeed.lerato.name,
  email: FakeSeed.lerato.email,
);

/// The sign-in and register forms on the API's auth calls, over [server];
/// the rest of the app on the fakes.
List<Override> _onTheApi(FakeAuthServer server) => [
  httpAdapterProvider.overrideWithValue(server),
  refreshTokenStoreProvider.overrideWithValue(InMemoryRefreshTokenStore()),
  authRepositoryProvider.overrideWith(
    (ref) => ApiAuthRepository(
      ref.watch(authCallsProvider),
      ref.watch(sessionProvider),
      ref.watch(apiProvider),
    ),
  ),
];

const _passwordTooShort =
    "The length of 'Password' must be at least 12 characters. You entered "
    '5 characters.';

String? _errorUnder(WidgetTester tester, String key) =>
    tester.widget<TextField>(find.byKey(Key(key))).decoration!.errorText;

String _text(WidgetTester tester, String key) =>
    tester.widget<TextField>(find.byKey(Key(key))).controller!.text;

bool _enabled(WidgetTester tester) =>
    tester.widget<FilledButton>(find.byKey(const Key('auth-submit'))).enabled;

void main() {
  group('the splash', () {
    testWidgets('a stored session: the splash shows while the one refresh '
        'runs, never the sign-in form, then the screen the link was '
        'for', (tester) async {
      final answer = Completer<Result<AuthUser?>>();
      final app = await pumpApp(
        tester,
        coldStart: '/activity',
        settle: false,
        overrides: [
          authRepositoryProvider.overrideWithValue(_ScriptedRestore([answer])),
        ],
      );

      for (var frame = 0; frame < 30; frame++) {
        await tester.pump(const Duration(milliseconds: 16));
        expect(find.byType(SignInScreen), findsNothing, reason: '$frame');
        expect(find.byType(SplashScreen), findsOneWidget, reason: '$frame');
      }
      expect(locationOf(app), '/splash?from=%2Factivity');

      answer.complete(Ok(_lerato));
      await tester.pumpAndSettle();

      expect(locationOf(app), '/activity');
      expect(find.byType(ActivityScreen), findsOneWidget);
    });

    testWidgets('no signal: not signed out. Try again and Sign out', (
      tester,
    ) async {
      final offline = Completer<Result<AuthUser?>>()
        ..complete(const Err(NoAnswerFailure()));
      final back = Completer<Result<AuthUser?>>();
      final repository = _ScriptedRestore([offline, back]);
      final app = await pumpApp(
        tester,
        size: phone,
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
      );

      expect(find.byKey(const Key('splash-offline')), findsOneWidget);
      expect(
        find.text("You're offline, or we couldn't reach the server."),
        findsOneWidget,
      );
      expect(find.byKey(const Key('splash-retry')), findsOneWidget);
      expect(find.byKey(const Key('splash-sign-out')), findsOneWidget);
      expect(find.byType(SignInScreen), findsNothing);
      expect(app.read(authControllerProvider), isA<Restoring>());

      await tester.tap(find.byKey(const Key('splash-retry')));
      await tester.pump();
      expect(repository.restores, 2);
      back.complete(Ok(_lerato));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets("the offline splash's Sign out signs out, to sign-in", (
      tester,
    ) async {
      final offline = Completer<Result<AuthUser?>>()
        ..complete(const Err(NoAnswerFailure()));
      final app = await pumpApp(
        tester,
        size: phone,
        overrides: [
          authRepositoryProvider.overrideWithValue(_ScriptedRestore([offline])),
        ],
      );

      await tester.tap(find.byKey(const Key('splash-sign-out')));
      await tester.pumpAndSettle();

      expect(app.read(authControllerProvider), const SignedOut());
      expect(find.byType(SignInScreen), findsOneWidget);
    });
  });

  group('sign-in', () {
    testWidgets('a wrong password says only that the email and password '
        "don't match: the same words as an unknown email", (tester) async {
      final server = FakeAuthServer(now: DateTime.now);
      await pumpApp(tester, size: phone, overrides: _onTheApi(server));

      await typeSignIn(tester, 'lerato@ronditrack.example');
      final wrongPassword = find.byKey(const Key('auth-message'));
      expect(wrongPassword, findsOneWidget);
      expect(
        find.text("That email and password don't match an account."),
        findsOneWidget,
      );
      for (final hint in ['password is', 'wrong password', 'no account']) {
        expect(find.textContaining(hint), findsNothing, reason: hint);
      }

      await typeSignIn(tester, 'nobody@ronditrack.example');
      expect(
        find.text("That email and password don't match an account."),
        findsOneWidget,
      );
      expect(_text(tester, 'sign-in-email'), 'nobody@ronditrack.example');
    });

    testWidgets('the 429: how long to wait, from Retry-After, and the button '
        'stays disabled until then', (tester) async {
      final server = FakeAuthServer(now: DateTime.now)
        ..everyLogin = const Status(429, retryAfter: 3);
      await pumpApp(tester, size: phone, overrides: _onTheApi(server));

      await typeSignIn(tester, 'lerato@ronditrack.example');

      expect(
        find.text('Too many attempts. Wait 3 seconds, then try again.'),
        findsOneWidget,
      );
      expect(_enabled(tester), isFalse);

      await tester.pump(const Duration(seconds: 1));
      expect(
        find.text('Too many attempts. Wait 2 seconds, then try again.'),
        findsOneWidget,
      );
      expect(_enabled(tester), isFalse);

      // Over to register: the API counts both, so the wait goes too.
      await tester.tap(find.byKey(const Key('sign-in-register')));
      await tester.pumpAndSettle();
      expect(find.byType(RegisterScreen), findsOneWidget);
      expect(_enabled(tester), isFalse);

      await tester.pump(const Duration(seconds: 2));
      expect(find.byKey(const Key('auth-wait')), findsNothing);
      expect(_enabled(tester), isTrue);
    });
  });

  group('register', () {
    Future<void> fill(WidgetTester tester) async {
      await tester.enterText(find.byKey(const Key('register-name')), 'Zanele');
      await tester.enterText(
        find.byKey(const Key('register-email')),
        'zanele@ronditrack.example',
      );
      await tester.enterText(find.byKey(const Key('auth-password')), 'short');
      await tester.tap(find.byKey(const Key('auth-submit')));
      await tester.pumpAndSettle();
    }

    testWidgets("the API's field errors appear under the right fields, and "
        'what was typed stays', (tester) async {
      final server = FakeAuthServer(now: DateTime.now)
        ..everyRegister = Status(
          400,
          body: jsonEncode({
            'status': 400,
            'detail': 'Validation failed.',
            'errors': {
              'name': ["'Name' must not be empty."],
              'email': ["'Email' is not a valid email address."],
              'password': [_passwordTooShort],
            },
          }),
        );
      await pumpApp(
        tester,
        size: phone,
        coldStart: '/register',
        overrides: _onTheApi(server),
      );

      await fill(tester);

      expect(_errorUnder(tester, 'register-name'), "'Name' must not be empty.");
      expect(
        _errorUnder(tester, 'register-email'),
        "'Email' is not a valid email address.",
      );
      expect(
        _errorUnder(tester, 'auth-password'),
        startsWith("The length of 'Password'"),
      );
      expect(_text(tester, 'register-name'), 'Zanele');
      expect(_text(tester, 'register-email'), 'zanele@ronditrack.example');
    });

    testWidgets('an address already in use says so, under the email', (
      tester,
    ) async {
      final server = FakeAuthServer(now: DateTime.now)
        ..everyRegister = Status(
          409,
          body: jsonEncode({
            'status': 409,
            'detail': 'An account with this email already exists.',
          }),
        );
      await pumpApp(
        tester,
        size: phone,
        coldStart: '/register',
        overrides: _onTheApi(server),
      );

      await fill(tester);

      expect(
        _errorUnder(tester, 'register-email'),
        'An account with this email already exists.',
      );
      expect(_errorUnder(tester, 'register-name'), isNull);
    });

    testWidgets('registering signs in with the same details, and lands '
        'Home', (tester) async {
      final server = FakeAuthServer(now: DateTime.now);
      final app = await pumpApp(
        tester,
        size: phone,
        coldStart: '/register',
        overrides: _onTheApi(server),
      );

      await tester.enterText(find.byKey(const Key('register-name')), 'Lerato');
      await tester.enterText(
        find.byKey(const Key('register-email')),
        'lerato@ronditrack.example',
      );
      await tester.enterText(
        find.byKey(const Key('auth-password')),
        server.password,
      );
      await tester.tap(find.byKey(const Key('auth-submit')));
      await tester.pumpAndSettle();

      expect(app.read(authControllerProvider), isA<SignedIn>());
      expect(server.log.where((l) => l.startsWith('/api/v1/auth/')), [
        '/api/v1/auth/register 201',
        '/api/v1/auth/login 200',
      ]);
    });
  });

  for (final (flavour, config) in [
    ('staging', stagingConfig),
    ('prod', prodConfig),
  ]) {
    testWidgets('the $flavour build has no session tools on Profile', (
      tester,
    ) async {
      await pumpApp(
        tester,
        as: FakeSeed.lerato,
        config: config,
        coldStart: '/profile',
      );

      expect(find.byKey(const Key('sign-out')), findsOneWidget);
      expect(find.byKey(const Key('session-tools')), findsNothing);
      expect(find.byKey(const Key('session-spoil')), findsNothing);
      expect(find.byKey(const Key('session-expire')), findsNothing);
    });
  }

  testWidgets('the dev build has them', (tester) async {
    await pumpApp(tester, as: FakeSeed.lerato, coldStart: '/profile');

    expect(find.byKey(const Key('session-spoil')), findsOneWidget);
    expect(find.byKey(const Key('session-expire')), findsOneWidget);
  });
}
