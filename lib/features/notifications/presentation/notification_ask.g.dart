// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_ask.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// What the phone allows now, for the status on Profile: `null` with push
/// off (no Firebase file in this build).

@ProviderFor(notificationStatus)
final notificationStatusProvider = NotificationStatusProvider._();

/// What the phone allows now, for the status on Profile: `null` with push
/// off (no Firebase file in this build).

final class NotificationStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<PushPermission?>,
          PushPermission?,
          FutureOr<PushPermission?>
        >
    with $FutureModifier<PushPermission?>, $FutureProvider<PushPermission?> {
  /// What the phone allows now, for the status on Profile: `null` with push
  /// off (no Firebase file in this build).
  NotificationStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationStatusHash();

  @$internal
  @override
  $FutureProviderElement<PushPermission?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PushPermission?> create(Ref ref) {
    return notificationStatus(ref);
  }
}

String _$notificationStatusHash() =>
    r'ba05381d1703f8c63badcc0261a99de8df074bd9';
