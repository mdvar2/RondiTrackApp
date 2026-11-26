import 'dart:async';

import 'package:ronditrack_app/core/errors/result.dart';

/// What a push says when it arrives or is tapped: its data, and nothing
/// else (README "Notifications"). The title and body are never read: a
/// push is a nudge to fetch, never the news.
typedef PushData = Map<String, String>;

/// Whether this phone may show notifications.
enum PushPermission {
  /// Never asked (Android 13 and later).
  notAsked,

  /// Allowed.
  granted,

  /// Refused. After a second refusal Android stops asking.
  denied,
}

/// The Firebase Messaging plugin, behind an interface: the plugin stays in
/// a thin file (`FirebasePushClient`) and everything the app decides is
/// tested against a fake.
abstract interface class PushClient {
  /// Asks Firebase for this installation's id; it arrives on
  /// [onRegistered].
  Future<void> register();

  /// This installation's id, now and whenever Firebase makes a new one.
  Stream<String> get onRegistered;

  /// A push that arrived while the app was in front (Android shows
  /// nothing for it).
  Stream<PushData> get onForeground;

  /// A notification tapped while the app was in the background.
  Stream<PushData> get onTapped;

  /// The notification whose tap started the app from closed, if any.
  Future<PushData?> tappedToStart();

  /// What the phone allows now.
  Future<PushPermission> permission();

  /// Shows Android's own dialog. Only ever after the member said yes in
  /// the app's own words.
  Future<PushPermission> requestPermission();
}

/// The API's record of this member's phones.
abstract interface class DeviceRegistry {
  /// `POST /me/devices`.
  Future<Result<void>> register(String installationId);

  /// `DELETE /me/devices/{installationId}`.
  Future<Result<void>> forget(String installationId);
}

/// The one push the API sends (README "Notifications", question 2).
const contributionUpdateType = 'contribution_update';

final _plainId = RegExp(r'^[0-9a-fA-F-]{1,64}$');

/// Turns a push into an address, checked like a deep link: a known type
/// and plain ids only. Anything else goes nowhere (`null`).
String? pushToLocation(Map<String, Object?> data) {
  if (data['type'] != contributionUpdateType) return null;
  final stokvelId = data['stokvelId'];
  final cycleId = data['cycleId'];
  if (stokvelId is! String || cycleId is! String) return null;
  if (!_plainId.hasMatch(stokvelId) || !_plainId.hasMatch(cycleId)) {
    return null;
  }
  return '/stokvels/$stokvelId/cycles/$cycleId';
}

/// Keeps the API's record of this phone in step with who is signed in.
///
/// Called by the auth controller, one way only: when someone becomes
/// signed in (sign-in, a restored session, an offline launch) and, before
/// the session ends, at sign-out. It never reads the auth state itself.
/// No network, or a Firebase failure, never blocks either: each call
/// waits [timeout] at most and fails quietly.
class PushRegistration {
  /// [client] is `null` when push is off (no Firebase file).
  new({
    required this.client,
    required this.devices,
    this.timeout = const Duration(seconds: 3),
    this.onSkipped,
  });

  /// Told about every step skipped quietly (the debug log; never the
  /// member). Optional: skipping never depends on it.
  final void Function(Object error)? onSkipped;

  /// The plugin, or `null` with push off.
  final PushClient? client;

  /// The API.
  final DeviceRegistry devices;

  /// The longest any step waits.
  final Duration timeout;

  StreamSubscription<String>? _registered;
  String? _installationId;
  String? _sent;
  bool _signedIn = false;

  /// This phone's installation id, once Firebase has given one.
  String? get installationId => _installationId;

  /// Someone is signed in now: register this phone for them. A new id from
  /// [PushClient.onRegistered] is sent again, for as long as they are.
  Future<void> signedIn() async {
    final client = this.client;
    _signedIn = true;
    if (client == null) return;
    _registered ??= client.onRegistered.listen((id) {
      _installationId = id;
      if (_signedIn) unawaited(_send(id));
    });
    final known = _installationId;
    if (known != null) await _send(known);
    await _quietly(() async {
      await client.register();
      return const Ok(null);
    });
  }

  /// Before the session ends: the API forgets this phone while the session
  /// can still prove who is asking. At most [timeout].
  Future<void> signingOut() async {
    _signedIn = false;
    _sent = null;
    final id = _installationId;
    if (client == null || id == null) return;
    await _quietly(() => devices.forget(id));
  }

  /// Sends [id] once per sign-in: Firebase may announce the same id again.
  Future<void> _send(String id) async {
    if (_sent == id) return;
    _sent = id;
    await _quietly(() => devices.register(id));
  }

  /// Stops listening (tests, and the provider's disposal).
  Future<void> dispose() async => await _registered?.cancel();

  Future<void> _quietly(Future<Result<void>> Function() step) async {
    try {
      final result = await step().timeout(timeout);
      if (result case Err(:final failure)) onSkipped?.call(failure);
    } on Object catch (error) {
      // No network, Firebase down, a slow API: skipped, never blocking.
      onSkipped?.call(error);
    }
  }
}
