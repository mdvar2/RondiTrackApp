import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/app/dev/persona_switcher.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/auth/domain/auth_repository.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/domain/auth_user.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';
import 'package:ronditrack_app/features/auth/presentation/sign_in_notice.dart';
import 'package:ronditrack_app/features/auth/presentation/sign_in_screen.dart';
import 'package:ronditrack_app/features/home/presentation/home_screen.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

import '../helpers/app_harness.dart';
import '../helpers/test_repositories.dart';

const _reference = '9f21773e18af553124148fb4140b5bc4';

// What the person sees for each answer, as README "Failures" (and the
// brief's Part 3 table) says, through the whole app.
void main() {
  Future<ProviderContainer> homeFailing(
    WidgetTester tester,
    Failure failure,
  ) async {
    final app = await pumpApp(
      tester,
      as: FakeSeed.lerato,
      size: phone,
      overrides: [
        homeRepositoryProvider.overrideWithValue(
          ScriptedHomeRepository([failure]),
        ),
      ],
    );
    // Long enough for any retry the policy allows (1 + 2 + 4 s).
    await tester.pump(const Duration(seconds: 8));
    await tester.pumpAndSettle();
    return app;
  }

  testWidgets('a stokvel or cycle the person isn\'t in: "not found", at '
      'once, never "no access"', (tester) async {
    await pumpApp(
      tester,
      as: FakeSeed.thabo,
      size: phone,
      coldStart: '/stokvels/${FakeSeed.mabenaFamilyId}',
      settle: false,
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text("We couldn't find that stokvel."), findsOneWidget);
    expect(find.textContaining('access'), findsNothing);
    expect(find.textContaining('permission'), findsNothing);
  });

  testWidgets('a treasurer action opened by a Member: the message, and they '
      'stay signed in', (tester) async {
    final app = await pumpApp(
      tester,
      as: FakeSeed.sipho,
      size: phone,
      coldStart:
          '/stokvels/${FakeSeed.mabenaFamilyId}/cycles/'
          '${FakeSeed.mabenaCycleId}/close',
    );

    expect(
      find.text(
        "Your role in this stokvel doesn't allow that. Only its treasurer or "
        'chairperson can do it.',
      ),
      findsOneWidget,
    );
    expect(app.read(authControllerProvider), isA<SignedIn>());
    expect(find.byType(SignInScreen), findsNothing);
  });

  testWidgets('rate limited: how long to wait, from the API', (tester) async {
    await homeFailing(
      tester,
      const RateLimitedFailure(wait: Duration(seconds: 42)),
    );

    expect(
      find.text('Too many attempts. Wait 42 seconds, then try again.'),
      findsOneWidget,
    );
  });

  testWidgets('a server failure: an apology and the reference, copyable, '
      "never the API's message", (tester) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map<Object?, Object?>)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    await homeFailing(tester, const ServerFailure(correlationId: _reference));

    expect(find.textContaining('Sorry, something went wrong'), findsOneWidget);
    expect(find.text(_reference), findsOneWidget);
    expect(find.textContaining('unexpected error'), findsNothing);

    await tester.tap(find.byKey(const Key('copy-reference')));
    await tester.pump();
    expect(copied, _reference);
    expect(find.text('Reference copied'), findsOneWidget);

    // It stays until the person does something about it.
    await tester.pump(const Duration(seconds: 30));
    expect(find.text(_reference), findsOneWidget);
  });

  testWidgets('no answer: offline or unreachable, with Try again, after the '
      'retries', (tester) async {
    final repository = ScriptedHomeRepository([
      const NoAnswerFailure(),
      const NoAnswerFailure(),
      const NoAnswerFailure(),
      const NoAnswerFailure(),
      const <Never>[],
    ]);
    await pumpApp(
      tester,
      as: FakeSeed.lerato,
      size: phone,
      overrides: [homeRepositoryProvider.overrideWithValue(repository)],
    );
    await tester.pump(const Duration(seconds: 8));
    await tester.pumpAndSettle();

    expect(
      find.text("You're offline, or we couldn't reach the server."),
      findsOneWidget,
    );
    expect(repository.calls, 4, reason: 'the first call and three retries');
    expect(find.byKey(const Key('failure-reference')), findsNothing);

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home-empty')), findsOneWidget);
  });

  testWidgets('a session the API ended (401): sign-in says so', (tester) async {
    final app = await pumpApp(tester, as: FakeSeed.lerato, size: phone);
    expect(find.byType(HomeScreen), findsOneWidget);

    app.read(authControllerProvider.notifier).sessionEnded();
    await tester.pumpAndSettle();

    expect(find.byType(SignInScreen), findsOneWidget);
    expect(find.text('Your session ended. Sign in again.'), findsOneWidget);
  });

  testWidgets('a persona switch refused for too many sign-ins says how long '
      'to wait', (tester) async {
    final app = await pumpApp(
      tester,
      as: FakeSeed.lerato,
      size: phone,
      overrides: [authRepositoryProvider.overrideWithValue(_RateLimitedAuth())],
    );

    await switchPersona(
      app.read(authControllerProvider.notifier),
      app.read(signInNoticeProvider.notifier),
      FakeSeed.sipho.email,
    );
    await tester.pumpAndSettle();

    expect(find.byType(SignInScreen), findsOneWidget);
    expect(
      find.text('Too many attempts. Wait 60 seconds, then try again.'),
      findsOneWidget,
    );
  });
}

/// Signs out fine; every sign-in is the API's login rate limit.
class _RateLimitedAuth implements AuthRepository {
  @override
  Future<Result<AuthUser>> signIn({required String email}) async =>
      const Err(RateLimitedFailure(wait: Duration(seconds: 60)));

  @override
  Future<Result<void>> signOut() async => const Ok(null);
}
