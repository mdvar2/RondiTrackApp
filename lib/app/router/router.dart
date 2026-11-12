import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/app/router/not_found_screen.dart';
import 'package:ronditrack_app/app/router/redirect.dart';
import 'package:ronditrack_app/app/router/routes.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';
import 'package:ronditrack_app/features/auth/presentation/auth_controller.dart';

part 'router.g.dart';

/// The app's router.
///
/// Lifetime: keepAlive, and built once. It *listens* to the auth state
/// rather than watching it: rebuilding the router on sign-in would throw
/// away every tab's stack. Instead, each auth change is copied into a
/// [ValueNotifier] that is the router's `refreshListenable`, so the
/// redirect runs again the moment someone signs in or out, not only when
/// someone taps.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final auth = ValueNotifier<AuthState>(ref.read(authControllerProvider));
  ref.listen(authControllerProvider, (_, next) => auth.value = next);

  final router = GoRouter(
    routes: $appRoutes,
    refreshListenable: auth,
    redirect: (_, state) => redirectFor(auth: auth.value, location: state.uri),
    errorBuilder: (_, _) => const NotFoundScreen(),
  );
  ref.onDispose(() {
    router.dispose();
    auth.dispose();
  });
  return router;
}
