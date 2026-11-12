// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The activity feed across my stokvels.
///
/// Lifetime: autoDispose. While the Activity tab is in the shell's stack it
/// stays watched; it goes at sign-out, with the shell.

@ProviderFor(ActivityController)
final activityControllerProvider = ActivityControllerProvider._();

/// The activity feed across my stokvels.
///
/// Lifetime: autoDispose. While the Activity tab is in the shell's stack it
/// stays watched; it goes at sign-out, with the shell.
final class ActivityControllerProvider
    extends $AsyncNotifierProvider<ActivityController, List<ActivityItem>> {
  /// The activity feed across my stokvels.
  ///
  /// Lifetime: autoDispose. While the Activity tab is in the shell's stack it
  /// stays watched; it goes at sign-out, with the shell.
  ActivityControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityControllerHash();

  @$internal
  @override
  ActivityController create() => ActivityController();
}

String _$activityControllerHash() =>
    r'9c33a35328f5d241b43c830b0ea21fa3df5afc2a';

/// The activity feed across my stokvels.
///
/// Lifetime: autoDispose. While the Activity tab is in the shell's stack it
/// stays watched; it goes at sign-out, with the shell.

abstract class _$ActivityController extends $AsyncNotifier<List<ActivityItem>> {
  FutureOr<List<ActivityItem>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ActivityItem>>, List<ActivityItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ActivityItem>>, List<ActivityItem>>,
              AsyncValue<List<ActivityItem>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
