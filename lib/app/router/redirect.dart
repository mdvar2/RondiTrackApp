import 'package:ronditrack_app/app/router/routes.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';

// The gate. One pure function decides every navigation from who is signed
// in and the address asked for. It needs no widget, so
// `test/app/router/redirect_test.dart` tests it directly. The router calls
// it on every navigation, and again whenever the auth state changes.

/// The app's addresses, other than sign-in, register and the splash: one
/// per row of README "Routes". An id or code is letters, digits, `_` or
/// `-`.
final List<RegExp> _appAddresses = [
  RegExp(r'^/$'),
  RegExp(r'^/stokvels$'),
  RegExp(r'^/stokvels/[\w-]+$'),
  RegExp(r'^/stokvels/[\w-]+/cycles/[\w-]+$'),
  RegExp(r'^/stokvels/[\w-]+/cycles/[\w-]+/payouts$'),
  RegExp(r'^/stokvels/[\w-]+/cycles/[\w-]+/close$'),
  RegExp(r'^/stokvels/[\w-]+/cycles/[\w-]+/pay$'),
  RegExp(r'^/stokvels/[\w-]+/cycles/[\w-]+/edit$'),
  RegExp(r'^/stokvels/[\w-]+/contributions$'),
  RegExp(r'^/activity$'),
  RegExp(r'^/profile$'),
  RegExp(r'^/join/[\w-]+$'),
];

/// Whether [path] is one of the app's own addresses (sign-in, register
/// and the splash excluded).
bool isAppAddress(String path) =>
    _appAddresses.any((address) => address.hasMatch(path));

/// [from] if it is worth returning to after sign-in, otherwise `null`.
///
/// Only an address inside the app qualifies: a path, with no scheme and no
/// host, that matches a row of the Routes table. Home isn't remembered
/// (it's where sign-in lands anyway), and neither are sign-in, register
/// or the splash.
String? returnAddress(String? from) {
  if (from == null) return null;
  final uri = Uri.tryParse(from);
  if (uri == null || uri.hasScheme || uri.hasAuthority) return null;
  if (uri.hasQuery || uri.hasFragment) return null;
  if (uri.path == const HomeRoute().location) return null;
  return isAppAddress(uri.path) ? uri.path : null;
}

/// Where to go instead of [location], given [auth]; `null` to stay.
///
/// Restoring (the one refresh on launch):
/// * at the splash, stay;
/// * anywhere else, go to the splash, remembering the address (or the
///   one sign-in or register was remembering), so a link survives.
///
/// Signed out:
/// * at sign-in or register, stay (dropping a `from` that isn't an app
///   address);
/// * at the splash, go to sign-in, passing on its remembered address;
/// * anywhere else, go to sign-in, remembering the address if it is one
///   of the app's own (so `/join/:code` survives sign-in).
///
/// Signed in:
/// * at sign-in, register or the splash, go to the remembered address, or
///   Home;
/// * at an address the app doesn't have, go Home;
/// * anywhere else, stay.
String? redirectFor({required AuthState auth, required Uri location}) {
  final path = location.path.isEmpty ? '/' : location.path;
  final atSignIn = path == const SignInRoute().location;
  final atRegister = path == const RegisterRoute().location;
  final atSplash = path == const SplashRoute().location;
  final from = atSignIn || atRegister || atSplash
      ? location.queryParameters['from']
      : null;

  // Register opened from a cold start waits on the splash too, and is
  // where a signed-out person goes after it.
  final register = const RegisterRoute().location;
  switch (auth) {
    case Restoring():
      if (atSplash) {
        return from == null || from == register || returnAddress(from) != null
            ? null
            : const SplashRoute().location;
      }
      if (atRegister && from == null) {
        return SplashRoute(from: register).location;
      }
      final goingTo = atSignIn || atRegister ? from : path;
      return SplashRoute(from: returnAddress(goingTo)).location;
    case SignedOut():
      if (atSignIn || atRegister) {
        if (from == null || returnAddress(from) != null) return null;
        return atSignIn ? const SignInRoute().location : register;
      }
      if (atSplash && from == register) return register;
      final goingTo = atSplash ? from : path;
      return SignInRoute(from: returnAddress(goingTo)).location;
    case SignedIn():
      if (atSignIn || atRegister || atSplash) {
        return returnAddress(from) ?? const HomeRoute().location;
      }
      if (!isAppAddress(path)) return const HomeRoute().location;
      return null;
  }
}
