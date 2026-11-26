import 'dart:async';

import 'package:ronditrack_app/features/notifications/domain/push.dart';

/// A [PushClient] a test drives: it decides the installation id, delivers
/// pushes and taps, and plays Android's permission dialog.
class FakePushClient implements PushClient {
  /// [id] is what Firebase hands out on [register].
  new({this.id = 'fid-1', this.startTap, this.answer = PushPermission.granted});

  /// The installation id [register] produces.
  String id;

  /// What started the app from closed, if a tap did.
  PushData? startTap;

  /// What Android's dialog answers.
  PushPermission answer;

  /// What the phone allows now.
  PushPermission current = PushPermission.notAsked;

  /// When true, [register] throws, as Firebase down would.
  bool failRegister = false;

  /// How many times Android's dialog was shown.
  int dialogs = 0;

  /// How many times [register] was called.
  int registers = 0;

  final _registered = StreamController<String>.broadcast(sync: true);
  final _foreground = StreamController<PushData>.broadcast(sync: true);
  final _tapped = StreamController<PushData>.broadcast(sync: true);

  /// Firebase makes a new id, as it can at any time.
  void rotate(String newId) {
    id = newId;
    _registered.add(newId);
  }

  /// A push arrives while the app is in front.
  void arrive(PushData data) => _foreground.add(data);

  /// A notification is tapped while the app is in the background.
  void tap(PushData data) => _tapped.add(data);

  @override
  Future<void> register() async {
    registers++;
    if (failRegister) throw StateError('Firebase is down');
    _registered.add(id);
  }

  @override
  Stream<String> get onRegistered => _registered.stream;

  @override
  Stream<PushData> get onForeground => _foreground.stream;

  @override
  Stream<PushData> get onTapped => _tapped.stream;

  @override
  Future<PushData?> tappedToStart() async => startTap;

  @override
  Future<PushPermission> permission() async => current;

  @override
  Future<PushPermission> requestPermission() async {
    dialogs++;
    return current = answer;
  }
}
