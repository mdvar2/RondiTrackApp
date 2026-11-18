// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_notice.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Why the person is looking at sign-in when they didn't ask to be: their
/// session ended (the API's `401`), or a persona switch was refused (too
/// many sign-ins: the wait, from `Retry-After`). `null` when there is
/// nothing to say.
///
/// Lifetime: keepAlive. It is written as the signed-in screens go away and
/// read by the sign-in screen that replaces them.

@ProviderFor(SignInNotice)
final signInNoticeProvider = SignInNoticeProvider._();

/// Why the person is looking at sign-in when they didn't ask to be: their
/// session ended (the API's `401`), or a persona switch was refused (too
/// many sign-ins: the wait, from `Retry-After`). `null` when there is
/// nothing to say.
///
/// Lifetime: keepAlive. It is written as the signed-in screens go away and
/// read by the sign-in screen that replaces them.
final class SignInNoticeProvider
    extends $NotifierProvider<SignInNotice, String?> {
  /// Why the person is looking at sign-in when they didn't ask to be: their
  /// session ended (the API's `401`), or a persona switch was refused (too
  /// many sign-ins: the wait, from `Retry-After`). `null` when there is
  /// nothing to say.
  ///
  /// Lifetime: keepAlive. It is written as the signed-in screens go away and
  /// read by the sign-in screen that replaces them.
  SignInNoticeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInNoticeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInNoticeHash();

  @$internal
  @override
  SignInNotice create() => SignInNotice();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$signInNoticeHash() => r'abd18c612b59b9337448579f66a18ab79745404d';

/// Why the person is looking at sign-in when they didn't ask to be: their
/// session ended (the API's `401`), or a persona switch was refused (too
/// many sign-ins: the wait, from `Retry-After`). `null` when there is
/// nothing to say.
///
/// Lifetime: keepAlive. It is written as the signed-in screens go away and
/// read by the sign-in screen that replaces them.

abstract class _$SignInNotice extends $Notifier<String?> {
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
