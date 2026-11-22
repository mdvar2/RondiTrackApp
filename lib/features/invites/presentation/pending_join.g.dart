// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_join.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The invite a signed-out person was joining when sign-in (or register)
/// took over: set as they submit the form, from the sign-in page's `from`
/// (`/join/:code`), and taken, once, by that invite's screen when the gate
/// lands them there. Taking it starts the join; nothing else does, so going
/// back, rotating the phone or a rebuild never joins again.
///
/// Lifetime: keepAlive. It has to outlive the sign-in screen that sets it.

@ProviderFor(PendingJoin)
final pendingJoinProvider = PendingJoinProvider._();

/// The invite a signed-out person was joining when sign-in (or register)
/// took over: set as they submit the form, from the sign-in page's `from`
/// (`/join/:code`), and taken, once, by that invite's screen when the gate
/// lands them there. Taking it starts the join; nothing else does, so going
/// back, rotating the phone or a rebuild never joins again.
///
/// Lifetime: keepAlive. It has to outlive the sign-in screen that sets it.
final class PendingJoinProvider
    extends $NotifierProvider<PendingJoin, String?> {
  /// The invite a signed-out person was joining when sign-in (or register)
  /// took over: set as they submit the form, from the sign-in page's `from`
  /// (`/join/:code`), and taken, once, by that invite's screen when the gate
  /// lands them there. Taking it starts the join; nothing else does, so going
  /// back, rotating the phone or a rebuild never joins again.
  ///
  /// Lifetime: keepAlive. It has to outlive the sign-in screen that sets it.
  PendingJoinProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingJoinProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingJoinHash();

  @$internal
  @override
  PendingJoin create() => PendingJoin();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$pendingJoinHash() => r'04b28371e0618427727f89337e248e641bbf438d';

/// The invite a signed-out person was joining when sign-in (or register)
/// took over: set as they submit the form, from the sign-in page's `from`
/// (`/join/:code`), and taken, once, by that invite's screen when the gate
/// lands them there. Taking it starts the join; nothing else does, so going
/// back, rotating the phone or a rebuild never joins again.
///
/// Lifetime: keepAlive. It has to outlive the sign-in screen that sets it.

abstract class _$PendingJoin extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
