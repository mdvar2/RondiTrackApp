// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Home: one entry per stokvel the signed-in person belongs to.
///
/// Lifetime: autoDispose. See README "Provider lifetimes".

@ProviderFor(HomeController)
final homeControllerProvider = HomeControllerProvider._();

/// Home: one entry per stokvel the signed-in person belongs to.
///
/// Lifetime: autoDispose. See README "Provider lifetimes".
final class HomeControllerProvider
    extends $AsyncNotifierProvider<HomeController, List<HomeEntry>> {
  /// Home: one entry per stokvel the signed-in person belongs to.
  ///
  /// Lifetime: autoDispose. See README "Provider lifetimes".
  HomeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeControllerHash();

  @$internal
  @override
  HomeController create() => HomeController();
}

String _$homeControllerHash() => r'18b356c662c0345178306f6af1c692b6f0b0f3e8';

/// Home: one entry per stokvel the signed-in person belongs to.
///
/// Lifetime: autoDispose. See README "Provider lifetimes".

abstract class _$HomeController extends $AsyncNotifier<List<HomeEntry>> {
  FutureOr<List<HomeEntry>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<HomeEntry>>, List<HomeEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<HomeEntry>>, List<HomeEntry>>,
              AsyncValue<List<HomeEntry>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
