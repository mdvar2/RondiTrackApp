// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $appShellRoute,
  $signInRoute,
  $registerRoute,
  $splashRoute,
];

RouteBase get $appShellRoute => StatefulShellRouteData.$route(
  factory: $AppShellRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/',
          hasOverriddenOnExit: false,
          factory: $HomeRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'join/:code',
              hasOverriddenOnExit: false,
              factory: $JoinRoute._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/stokvels',
          hasOverriddenOnExit: false,
          factory: $StokvelsRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'new',
              hasOverriddenOnExit: false,
              factory: $CreateStokvelRoute._fromState,
            ),
            GoRouteData.$route(
              path: ':id',
              hasOverriddenOnExit: false,
              factory: $StokvelRoute._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'contributions',
                  hasOverriddenOnExit: false,
                  factory: $ContributionsRoute._fromState,
                ),
                GoRouteData.$route(
                  path: 'cycles/:cycleId',
                  hasOverriddenOnExit: false,
                  factory: $CycleRoute._fromState,
                  routes: [
                    GoRouteData.$route(
                      path: 'payouts',
                      hasOverriddenOnExit: false,
                      factory: $PayoutsRoute._fromState,
                    ),
                    GoRouteData.$route(
                      path: 'close',
                      hasOverriddenOnExit: false,
                      factory: $CloseCycleRoute._fromState,
                    ),
                    GoRouteData.$route(
                      path: 'pay',
                      hasOverriddenOnExit: false,
                      factory: $PayRoute._fromState,
                    ),
                    GoRouteData.$route(
                      path: 'edit',
                      hasOverriddenOnExit: false,
                      factory: $EditCycleRoute._fromState,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/activity',
          hasOverriddenOnExit: false,
          factory: $ActivityRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/profile',
          hasOverriddenOnExit: false,
          factory: $ProfileRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $AppShellRouteExtension on AppShellRoute {
  static AppShellRoute _fromState(GoRouterState state) => const AppShellRoute();
}

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $JoinRoute on GoRouteData {
  static JoinRoute _fromState(GoRouterState state) =>
      JoinRoute(code: state.pathParameters['code']!);

  JoinRoute get _self => this as JoinRoute;

  @override
  String get location =>
      GoRouteData.$location('/join/${Uri.encodeComponent(_self.code)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $StokvelsRoute on GoRouteData {
  static StokvelsRoute _fromState(GoRouterState state) => const StokvelsRoute();

  @override
  String get location => GoRouteData.$location('/stokvels');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CreateStokvelRoute on GoRouteData {
  static CreateStokvelRoute _fromState(GoRouterState state) =>
      const CreateStokvelRoute();

  @override
  String get location => GoRouteData.$location('/stokvels/new');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $StokvelRoute on GoRouteData {
  static StokvelRoute _fromState(GoRouterState state) =>
      StokvelRoute(id: state.pathParameters['id']!);

  StokvelRoute get _self => this as StokvelRoute;

  @override
  String get location =>
      GoRouteData.$location('/stokvels/${Uri.encodeComponent(_self.id)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ContributionsRoute on GoRouteData {
  static ContributionsRoute _fromState(GoRouterState state) =>
      ContributionsRoute(id: state.pathParameters['id']!);

  ContributionsRoute get _self => this as ContributionsRoute;

  @override
  String get location => GoRouteData.$location(
    '/stokvels/${Uri.encodeComponent(_self.id)}/contributions',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CycleRoute on GoRouteData {
  static CycleRoute _fromState(GoRouterState state) => CycleRoute(
    id: state.pathParameters['id']!,
    cycleId: state.pathParameters['cycleId']!,
  );

  CycleRoute get _self => this as CycleRoute;

  @override
  String get location => GoRouteData.$location(
    '/stokvels/${Uri.encodeComponent(_self.id)}/cycles/${Uri.encodeComponent(_self.cycleId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PayoutsRoute on GoRouteData {
  static PayoutsRoute _fromState(GoRouterState state) => PayoutsRoute(
    id: state.pathParameters['id']!,
    cycleId: state.pathParameters['cycleId']!,
  );

  PayoutsRoute get _self => this as PayoutsRoute;

  @override
  String get location => GoRouteData.$location(
    '/stokvels/${Uri.encodeComponent(_self.id)}/cycles/${Uri.encodeComponent(_self.cycleId)}/payouts',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CloseCycleRoute on GoRouteData {
  static CloseCycleRoute _fromState(GoRouterState state) => CloseCycleRoute(
    id: state.pathParameters['id']!,
    cycleId: state.pathParameters['cycleId']!,
  );

  CloseCycleRoute get _self => this as CloseCycleRoute;

  @override
  String get location => GoRouteData.$location(
    '/stokvels/${Uri.encodeComponent(_self.id)}/cycles/${Uri.encodeComponent(_self.cycleId)}/close',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PayRoute on GoRouteData {
  static PayRoute _fromState(GoRouterState state) => PayRoute(
    id: state.pathParameters['id']!,
    cycleId: state.pathParameters['cycleId']!,
  );

  PayRoute get _self => this as PayRoute;

  @override
  String get location => GoRouteData.$location(
    '/stokvels/${Uri.encodeComponent(_self.id)}/cycles/${Uri.encodeComponent(_self.cycleId)}/pay',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $EditCycleRoute on GoRouteData {
  static EditCycleRoute _fromState(GoRouterState state) => EditCycleRoute(
    id: state.pathParameters['id']!,
    cycleId: state.pathParameters['cycleId']!,
  );

  EditCycleRoute get _self => this as EditCycleRoute;

  @override
  String get location => GoRouteData.$location(
    '/stokvels/${Uri.encodeComponent(_self.id)}/cycles/${Uri.encodeComponent(_self.cycleId)}/edit',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ActivityRoute on GoRouteData {
  static ActivityRoute _fromState(GoRouterState state) => const ActivityRoute();

  @override
  String get location => GoRouteData.$location('/activity');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  @override
  String get location => GoRouteData.$location('/profile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signInRoute => GoRouteData.$route(
  path: '/sign-in',
  hasOverriddenOnExit: false,
  factory: $SignInRoute._fromState,
);

mixin $SignInRoute on GoRouteData {
  static SignInRoute _fromState(GoRouterState state) =>
      SignInRoute(from: state.uri.queryParameters['from']);

  SignInRoute get _self => this as SignInRoute;

  @override
  String get location => GoRouteData.$location(
    '/sign-in',
    queryParams: {if (_self.from != null) 'from': _self.from},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $registerRoute => GoRouteData.$route(
  path: '/register',
  hasOverriddenOnExit: false,
  factory: $RegisterRoute._fromState,
);

mixin $RegisterRoute on GoRouteData {
  static RegisterRoute _fromState(GoRouterState state) =>
      RegisterRoute(from: state.uri.queryParameters['from']);

  RegisterRoute get _self => this as RegisterRoute;

  @override
  String get location => GoRouteData.$location(
    '/register',
    queryParams: {if (_self.from != null) 'from': _self.from},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $splashRoute => GoRouteData.$route(
  path: '/splash',
  hasOverriddenOnExit: false,
  factory: $SplashRoute._fromState,
);

mixin $SplashRoute on GoRouteData {
  static SplashRoute _fromState(GoRouterState state) =>
      SplashRoute(from: state.uri.queryParameters['from']);

  SplashRoute get _self => this as SplashRoute;

  @override
  String get location => GoRouteData.$location(
    '/splash',
    queryParams: {if (_self.from != null) 'from': _self.from},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
