import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ronditrack_app/core/config/firebase_config.dart';
import 'package:ronditrack_app/features/notifications/domain/push.dart';

/// The app's own channel. Private on the lock screen: a phone set to hide
/// sensitive content shows only the app's name (README "Notifications").
/// The API names it in every push, and the manifest makes it the default.
const stokvelChannel = AndroidNotificationChannel(
  'stokvel_updates',
  'Stokvel updates',
  description: 'When something changes on one of your stokvels.',
  importance: Importance.high,
);

/// The plugins, and nothing the app decides: everything else is tested
/// against a fake [PushClient]. Not covered by unit tests: it needs a
/// phone and a Firebase project (README "What isn't tested").
class FirebasePushClient implements PushClient {
  const new _(this._messaging, this._local, this._taps);

  /// Starts Firebase with this flavour's project, creates the channel, and
  /// shows foreground pushes on it.
  static Future<FirebasePushClient> start(FirebaseConfig config) async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: config.apiKey,
        appId: config.appId,
        messagingSenderId: config.messagingSenderId,
        projectId: config.projectId,
      ),
    );
    final local = FlutterLocalNotificationsPlugin();
    final taps = _LocalTaps();
    await local.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: taps.add,
    );
    await local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(stokvelChannel);
    return FirebasePushClient._(FirebaseMessaging.instance, local, taps);
  }

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _local;
  final _LocalTaps _taps;

  @override
  Future<void> register() => _messaging.register();

  @override
  Stream<String> get onRegistered => _messaging.onRegistered.map((id) {
    // Debug builds only, and never the id itself.
    if (kDebugMode) debugPrint('Push: Firebase gave this install an id.');
    return id;
  });

  /// In front, Android shows nothing: the app shows it itself, on the same
  /// channel, private on the lock screen, with the data as its payload.
  @override
  Stream<PushData> get onForeground => FirebaseMessaging.onMessage.map((m) {
    final data = m.data.map((k, v) => MapEntry(k, '$v'));
    final notification = m.notification;
    if (notification != null) {
      _local
          .show(
            id: m.hashCode,
            title: notification.title,
            body: notification.body,
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                stokvelChannel.id,
                stokvelChannel.name,
                channelDescription: stokvelChannel.description,
                importance: Importance.high,
                priority: Priority.high,
                visibility: NotificationVisibility.private,
              ),
            ),
            payload: Uri(queryParameters: data).query,
          )
          .ignore();
    }
    return data;
  });

  @override
  Stream<PushData> get onTapped => Stream.multi((out) {
    final remote = FirebaseMessaging.onMessageOpenedApp.listen(
      (m) => out.add(m.data.map((k, v) => MapEntry(k, '$v'))),
    );
    final local = _taps.stream.listen(out.add);
    out.onCancel = () async {
      await remote.cancel();
      await local.cancel();
    };
  });

  @override
  Future<PushData?> tappedToStart() async {
    final remote = await _messaging.getInitialMessage();
    if (remote != null) return remote.data.map((k, v) => MapEntry(k, '$v'));
    final launch = await _local.getNotificationAppLaunchDetails();
    final payload = launch?.notificationResponse?.payload;
    if (launch?.didNotificationLaunchApp != true || payload == null) {
      return null;
    }
    return Uri.splitQueryString(payload);
  }

  @override
  Future<PushPermission> permission() async =>
      _map((await _messaging.getNotificationSettings()).authorizationStatus);

  @override
  Future<PushPermission> requestPermission() async =>
      _map((await _messaging.requestPermission()).authorizationStatus);

  static PushPermission _map(AuthorizationStatus status) => switch (status) {
    AuthorizationStatus.authorized ||
    AuthorizationStatus.provisional => PushPermission.granted,
    AuthorizationStatus.denied ||
    AuthorizationStatus.deniedPermanently => PushPermission.denied,
    AuthorizationStatus.notDetermined => PushPermission.notAsked,
  };
}

/// Taps on the notifications the app showed itself, in front.
class _LocalTaps {
  final _controller = StreamController<PushData>.broadcast();

  Stream<PushData> get stream => _controller.stream;

  void add(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null) return;
    try {
      _controller.add(Uri.splitQueryString(payload));
    } on FormatException catch (e) {
      debugPrint('Ignored a notification payload: $e');
    }
  }
}
