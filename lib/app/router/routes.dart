import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ronditrack_app/app/router/app_shell.dart';
import 'package:ronditrack_app/core/config/app_config_scope.dart';
import 'package:ronditrack_app/features/activity/presentation/activity_screen.dart';
import 'package:ronditrack_app/features/auth/presentation/profile_screen.dart';
import 'package:ronditrack_app/features/auth/presentation/sign_in_screen.dart';
import 'package:ronditrack_app/features/home/presentation/home_screen.dart';
import 'package:ronditrack_app/features/invites/presentation/join_screen.dart';
import 'package:ronditrack_app/features/stokvels/presentation/cycle_screen.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvels_screen.dart';

part 'routes.g.dart';

// Every address in the app, typed. One class per row of README "Routes".
// Widgets navigate with these (`StokvelRoute(id: id).go(context)`), never
// with a string path.

/// The four tabs, each with its own navigation stack.
@TypedStatefulShellRoute<AppShellRoute>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<HomeBranch>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<HomeRoute>(
          path: '/',
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<JoinRoute>(path: 'join/:code'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<StokvelsBranch>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<StokvelsRoute>(
          path: '/stokvels',
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<StokvelRoute>(
              path: ':id',
              routes: <TypedRoute<RouteData>>[
                TypedGoRoute<CycleRoute>(path: 'cycles/:cycleId'),
              ],
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<ActivityBranch>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ActivityRoute>(path: '/activity'),
      ],
    ),
    TypedStatefulShellBranch<ProfileBranch>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ProfileRoute>(path: '/profile'),
      ],
    ),
  ],
)
class AppShellRoute extends StatefulShellRouteData {
  /// The shell.
  const new();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) => AppShell(navigationShell: navigationShell);
}

/// The Home tab.
class HomeBranch extends StatefulShellBranchData {
  /// The Home tab.
  const new();
}

/// The Stokvels tab.
class StokvelsBranch extends StatefulShellBranchData {
  /// The Stokvels tab.
  const new();
}

/// The Activity tab.
class ActivityBranch extends StatefulShellBranchData {
  /// The Activity tab.
  const new();
}

/// The Profile tab.
class ProfileBranch extends StatefulShellBranchData {
  /// The Profile tab.
  const new();
}

/// `/`: Home.
class HomeRoute extends GoRouteData with $HomeRoute {
  /// Home.
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      HomeScreen(title: AppConfigScope.of(context).appName);
}

/// `/join/:code`: an invite's preview, on top of Home.
class JoinRoute extends GoRouteData with $JoinRoute {
  /// The invite with [code].
  const new({required this.code});

  /// The invite code.
  final String code;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      JoinScreen(code: code);
}

/// `/stokvels`: my stokvels.
class StokvelsRoute extends GoRouteData with $StokvelsRoute {
  /// My stokvels.
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const StokvelsScreen();
}

/// `/stokvels/:id`: one stokvel, on top of the list.
class StokvelRoute extends GoRouteData with $StokvelRoute {
  /// The stokvel with [id].
  const new({required this.id});

  /// The stokvel's id.
  final String id;

  /// Every stokvel's page has this key, so switching from one stokvel to
  /// another (the picker, or the tablet's list) updates the page in place
  /// instead of sliding a new page in. What keeps the previous stokvel's
  /// contributions off screen is the per-id provider, not this key; the
  /// key only spares the animation.
  static const pageKey = ValueKey<String>('stokvel-page');

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage<void>(
        key: pageKey,
        child: StokvelsScreen(selectedId: id),
      );
}

/// `/stokvels/:id/cycles/:cycleId`: one cycle, on top of its stokvel.
class CycleRoute extends GoRouteData with $CycleRoute {
  /// Cycle [cycleId] of stokvel [id].
  const new({required this.id, required this.cycleId});

  /// The stokvel's id.
  final String id;

  /// The cycle's id.
  final String cycleId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CycleScreen(stokvelId: id, cycleId: cycleId);
}

/// `/activity`: activity across my stokvels.
class ActivityRoute extends GoRouteData with $ActivityRoute {
  /// Activity.
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ActivityScreen();
}

/// `/profile`: who is signed in.
class ProfileRoute extends GoRouteData with $ProfileRoute {
  /// Profile.
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileScreen();
}

/// `/sign-in`, with the address to return to in `from`.
@TypedGoRoute<SignInRoute>(path: '/sign-in')
class SignInRoute extends GoRouteData with $SignInRoute {
  /// Sign-in, returning to [from] afterwards.
  const new({this.from});

  /// The address to go to after signing in. The gate only ever puts one of
  /// the app's own addresses here.
  final String? from;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SignInScreen();
}
