import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/session/refresh_token_store.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fake_auth_server.dart';

/// The app's providers on the API, over [server], with [store] as the
/// phone's secure storage.
ProviderContainer _app(FakeAuthServer server, InMemoryRefreshTokenStore store) {
  // The auth state is listened to, as the router does.
  return ProviderContainer.test(
    overrides: [
      appConfigProvider.overrideWithValue(devConfig),
      httpAdapterProvider.overrideWithValue(server),
      refreshTokenStoreProvider.overrideWithValue(store),
    ],
  )..listen(authControllerProvider, (_, _) {});
}

/// Waits until the launch's restore has decided.
Future<AuthState> _settled(ProviderContainer app) async {
  for (var i = 0; i < 100; i++) {
    final state = app.read(authControllerProvider);
    if (state is! Restoring || state.failure != null) return state;
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
  final state = app.read(authControllerProvider);
  return state;
}

void main() {
  late FakeAuthServer server;

  setUp(() => server = FakeAuthServer(now: DateTime.now));

  group('restore on launch: one refresh', () {
    test(
      'a good stored token: signed in, with the rotated one stored',
      () async {
        final store = InMemoryRefreshTokenStore(
          server.signIn('lerato@ronditrack.example').refresh,
        );
        final before = store.token;
        final app = _app(server, store);

        expect(app.read(authControllerProvider), const Restoring());
        final state = await _settled(app);

        expect(state, isA<SignedIn>());
        expect(server.rotations, 1);
        expect(store.token, isNot(before));
        expect(server.isAlive(store.token!), isTrue);
      },
    );

    test('a refused one: signed out, and the dead token deleted', () async {
      final store = InMemoryRefreshTokenStore('a-token-the-api-never-issued');
      final app = _app(server, store);

      expect(await _settled(app), const SignedOut());
      expect(store.token, isNull);
    });

    test('none stored: signed out, and nothing is sent', () async {
      final app = _app(server, InMemoryRefreshTokenStore());

      expect(await _settled(app), const SignedOut());
      expect(server.requests, isEmpty);
    });

    test('no network: not signed out. Still restoring, with why, and the '
        'token kept; Try again signs in once the API answers', () async {
      final store = InMemoryRefreshTokenStore(
        server.signIn('lerato@ronditrack.example').refresh,
      );
      server.nextRefresh = const Offline();
      final app = _app(server, store);

      final offline = await _settled(app);
      expect(
        offline,
        isA<Restoring>().having(
          (s) => s.failure,
          'failure',
          isA<NoAnswerFailure>(),
        ),
      );
      expect(store.token, isNotNull);

      await app.read(authControllerProvider.notifier).restore();
      expect(app.read(authControllerProvider), isA<SignedIn>());
    });
  });

  test("a sign-in sent before the launch's restore has run is not "
      'overruled by it', () async {
    final store = InMemoryRefreshTokenStore();
    final app = _app(server, store);

    await app
        .read(authControllerProvider.notifier)
        .signIn(email: 'lerato@ronditrack.example', password: server.password);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(app.read(authControllerProvider), isA<SignedIn>());
    expect(store.token, isNotNull);
  });

  test('sign-in stores the refresh token, and only that', () async {
    final store = InMemoryRefreshTokenStore();
    final app = _app(server, store);
    await _settled(app);

    await app
        .read(authControllerProvider.notifier)
        .signIn(email: 'lerato@ronditrack.example', password: server.password);

    expect(app.read(authControllerProvider), isA<SignedIn>());
    expect(store.writes, 1);
    expect(server.isAlive(store.token!), isTrue);
    expect(store.token, isNot(contains('.')), reason: 'not the access JWT');
  });

  group('sign-out', () {
    Future<(ProviderContainer, InMemoryRefreshTokenStore, String)>
    signedIn() async {
      final store = InMemoryRefreshTokenStore();
      final app = _app(server, store);
      await _settled(app);
      await app
          .read(authControllerProvider.notifier)
          .signIn(
            email: 'lerato@ronditrack.example',
            password: server.password,
          );
      return (app, store, store.token!);
    }

    test('with a network: the phone is wiped, and the API revokes the '
        'token', () async {
      final (app, store, old) = await signedIn();

      await app.read(authControllerProvider.notifier).signOut();

      expect(app.read(authControllerProvider), const SignedOut());
      expect(store.token, isNull);
      expect(app.read(sessionProvider).access, isNull);
      expect(server.isAlive(old), isFalse);
    });

    test('with no network: the phone is wiped all the same', () async {
      final (app, store, _) = await signedIn();
      server.everyLogout = const Offline();

      await app.read(authControllerProvider.notifier).signOut();

      expect(app.read(authControllerProvider), const SignedOut());
      expect(store.token, isNull);
      expect(app.read(sessionProvider).access, isNull);
    });

    test('with a slow network: signed out and wiped before the API '
        'answers', () async {
      final (app, store, old) = await signedIn();
      final gate = server.logoutGate = Completer<void>();

      final signingOut = app.read(authControllerProvider.notifier).signOut();
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(app.read(authControllerProvider), const SignedOut());
      expect(store.token, isNull);
      expect(server.isAlive(old), isTrue, reason: 'the API not told yet');
      gate.complete();
      await signingOut;
      expect(server.isAlive(old), isFalse);
    });
  });

  test('a late refresh after sign-out is ignored: the slow restore '
      'finishes, and nobody is signed back in', () async {
    final store = InMemoryRefreshTokenStore(
      server.signIn('lerato@ronditrack.example').refresh,
    );
    final gate = server.refreshGate = Completer<void>();
    final app = _app(server, store);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(app.read(sessionProvider).refreshes, 1, reason: 'restore started');

    // The splash's Sign out, while the restore is still out.
    await app.read(authControllerProvider.notifier).signOut();
    gate.complete();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(app.read(authControllerProvider), const SignedOut());
    expect(store.token, isNull);
    expect(app.read(sessionProvider).access, isNull);
  });
}
