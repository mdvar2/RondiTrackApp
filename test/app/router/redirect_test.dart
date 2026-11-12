import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/router/redirect.dart';
import 'package:ronditrack_app/app/router/routes.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

import '../../helpers/app_harness.dart';

/// The gate, tested as a plain function: no widget, no router.
void main() {
  const signedOut = SignedOut();
  final lerato = signedInAs(FakeSeed.lerato);
  const stokvel = '/stokvels/${FakeSeed.mabenaFamilyId}';
  const cycle = '$stokvel/cycles/${FakeSeed.mabenaCycleId}';

  String? gate(AuthState auth, String location) =>
      redirectFor(auth: auth, location: Uri.parse(location));

  group('signed out', () {
    test('Home goes to sign-in, remembering nothing', () {
      expect(gate(signedOut, '/'), '/sign-in');
    });

    test('every tab goes to sign-in, remembering where it was', () {
      expect(gate(signedOut, '/stokvels'), '/sign-in?from=%2Fstokvels');
      expect(gate(signedOut, '/activity'), '/sign-in?from=%2Factivity');
      expect(gate(signedOut, '/profile'), '/sign-in?from=%2Fprofile');
    });

    test('a stokvel or cycle link goes to sign-in, remembering the link', () {
      expect(
        gate(signedOut, stokvel),
        const SignInRoute(from: stokvel).location,
      );
      expect(gate(signedOut, cycle), const SignInRoute(from: cycle).location);
    });

    test('/join/:code goes to sign-in, remembering the invite', () {
      expect(
        gate(signedOut, '/join/MABENA26'),
        '/sign-in?from=%2Fjoin%2FMABENA26',
      );
    });

    test('sign-in itself stays, with or without a remembered address', () {
      expect(gate(signedOut, '/sign-in'), isNull);
      expect(gate(signedOut, '/sign-in?from=%2Fjoin%2FMABENA26'), isNull);
    });

    test('an address the app does not have goes to sign-in, unremembered', () {
      expect(gate(signedOut, '/admin'), '/sign-in');
      expect(gate(signedOut, '/stokvels/a/b/c'), '/sign-in');
    });

    test('a deep link with the scheme and host still gates on the path', () {
      expect(
        gate(signedOut, 'ronditrack-dev://app/join/MABENA26'),
        '/sign-in?from=%2Fjoin%2FMABENA26',
      );
    });
  });

  group('sign-in while signed in', () {
    test('with nothing remembered, goes Home', () {
      expect(gate(lerato, '/sign-in'), '/');
    });

    test('with /join/:code remembered, lands on that invite', () {
      expect(
        gate(lerato, '/sign-in?from=%2Fjoin%2FMABENA26'),
        '/join/MABENA26',
      );
    });

    test('with a stokvel or cycle remembered, lands there', () {
      expect(gate(lerato, const SignInRoute(from: cycle).location), cycle);
      expect(gate(lerato, const SignInRoute(from: stokvel).location), stokvel);
    });
  });

  group('an address from outside the app is never remembered', () {
    for (final outside in [
      'https://evil.example/join/MABENA26',
      '//evil.example/join/MABENA26',
      'ronditrack-dev://app/join/MABENA26',
      'javascript:alert(1)',
      'join/MABENA26',
      '/admin',
      '/join/MABENA26?then=https://evil.example',
      '/sign-in',
      '/',
    ]) {
      test('"$outside" lands on Home after sign-in', () {
        final location = Uri(
          path: '/sign-in',
          queryParameters: {'from': outside},
        ).toString();
        expect(gate(lerato, location), '/');
      });

      test('"$outside" is dropped from sign-in while signed out', () {
        final location = Uri(
          path: '/sign-in',
          queryParameters: {'from': outside},
        ).toString();
        expect(gate(signedOut, location), '/sign-in');
      });
    }
  });

  group('signed in', () {
    test('every address in the Routes table stays', () {
      for (final address in [
        '/',
        '/stokvels',
        stokvel,
        cycle,
        '/activity',
        '/profile',
        '/join/MABENA26',
      ]) {
        expect(gate(lerato, address), isNull, reason: address);
      }
    });

    test('an address the app does not have goes Home', () {
      expect(gate(lerato, '/admin'), '/');
      expect(gate(lerato, '/stokvels/a/b/c'), '/');
    });
  });

  group('no loops', () {
    test('every redirect lands where the gate then lets it stay', () {
      for (final auth in [signedOut, lerato]) {
        for (final start in [
          '/',
          '/stokvels',
          cycle,
          '/join/MABENA26',
          '/sign-in',
          '/sign-in?from=%2Fjoin%2FMABENA26',
          '/sign-in?from=https%3A%2F%2Fevil.example',
          '/admin',
        ]) {
          final next = gate(auth, start);
          if (next != null) {
            expect(gate(auth, next), isNull, reason: '$auth: $start → $next');
          }
        }
      }
    });
  });

  test('the gate knows exactly the Routes table', () {
    for (final address in [
      const HomeRoute().location,
      const StokvelsRoute().location,
      const StokvelRoute(id: FakeSeed.mabenaFamilyId).location,
      const CycleRoute(
        id: FakeSeed.mabenaFamilyId,
        cycleId: FakeSeed.mabenaCycleId,
      ).location,
      const ActivityRoute().location,
      const ProfileRoute().location,
      const JoinRoute(code: 'MABENA26').location,
    ]) {
      expect(isAppAddress(address), isTrue, reason: address);
    }
    expect(isAppAddress(const SignInRoute().location), isFalse);
  });
}
