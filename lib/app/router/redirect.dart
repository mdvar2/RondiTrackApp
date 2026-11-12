import 'package:ronditrack_app/app/router/routes.dart';
import 'package:ronditrack_app/features/auth/domain/auth_state.dart';

// The gate. One pure function decides every navigation from who is signed
// in and the address asked for. It needs no widget, so
// `test/app/router/redirect_test.dart` tests it directly. The router calls
// it on every navigation, and again whenever the auth state changes.

/// The app's addresses, other than sign-in: one per row of README
/// "Routes". An id or code is letters, digits, `_` or `-`.
final List<RegExp> _appAddresses = [
  RegExp(r'^/$'),
  RegExp(r'^/stokvels$'),
  RegExp(r'^/stokvels/[\w-]+$'),
  RegExp(r'^/stokvels/[\w-]+/cycles/[\w-]+$'),
  RegExp(r'^/activity$'),
  RegExp(r'^/profile$'),
  RegExp(r'^/join/[\w-]+$'),
];

/// Whether [path] is one of the app's own addresses (sign-in excluded).
bool isAppAddress(String path) =>
    _appAddresses.any((address) => address.hasMatch(path));

/// [from] if it is worth returning to after sign-in, otherwise `null`.
///
/// Only an address inside the app qualifies: a path, with no scheme and no
/// host, that matches a row of the Routes table. Home isn't remembered
/// (it's where sign-in lands anyway), and neither is sign-in itself.
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
/// Signed out:
/// * at sign-in, stay (dropping a `from` that isn't an app address);
/// * anywhere else, go to sign-in, remembering the address if it is one
///   of the app's own (so `/join/:code` survives sign-in).
///
/// Signed in:
/// * at sign-in, go to the remembered address, or Home;
/// * at an address the app doesn't have, go Home;
/// * anywhere else, stay.
String? redirectFor({required AuthState auth, required Uri location}) {
  final path = location.path.isEmpty ? '/' : location.path;
  final atSignIn = path == const SignInRoute().location;
  final from = atSignIn ? location.queryParameters['from'] : null;

  switch (auth) {
    case SignedOut():
      if (atSignIn) {
        return from == null || returnAddress(from) != null
            ? null
            : const SignInRoute().location;
      }
      return SignInRoute(from: returnAddress(path)).location;
    case SignedIn():
      if (atSignIn) return returnAddress(from) ?? const HomeRoute().location;
      if (!isAppAddress(path)) return const HomeRoute().location;
      return null;
  }
}
