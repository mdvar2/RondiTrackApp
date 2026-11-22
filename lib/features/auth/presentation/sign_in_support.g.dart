// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_support.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The email the dev build's persona switcher chose, waiting for the
/// sign-in form to fill it in. Only the email: the password is typed.
///
/// Lifetime: keepAlive. It is written as the signed-in screens go away and
/// read by the sign-in screen that replaces them.

@ProviderFor(SignInEmailDraft)
final signInEmailDraftProvider = SignInEmailDraftProvider._();

/// The email the dev build's persona switcher chose, waiting for the
/// sign-in form to fill it in. Only the email: the password is typed.
///
/// Lifetime: keepAlive. It is written as the signed-in screens go away and
/// read by the sign-in screen that replaces them.
final class SignInEmailDraftProvider
    extends $NotifierProvider<SignInEmailDraft, String?> {
  /// The email the dev build's persona switcher chose, waiting for the
  /// sign-in form to fill it in. Only the email: the password is typed.
  ///
  /// Lifetime: keepAlive. It is written as the signed-in screens go away and
  /// read by the sign-in screen that replaces them.
  SignInEmailDraftProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInEmailDraftProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInEmailDraftHash();

  @$internal
  @override
  SignInEmailDraft create() => SignInEmailDraft();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$signInEmailDraftHash() => r'8872f3bec0739abcd7d5ee1bd9c83367dcf49600';

/// The email the dev build's persona switcher chose, waiting for the
/// sign-in form to fill it in. Only the email: the password is typed.
///
/// Lifetime: keepAlive. It is written as the signed-in screens go away and
/// read by the sign-in screen that replaces them.

abstract class _$SignInEmailDraft extends $Notifier<String?> {
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

/// How many seconds sign-in and register must wait, after the API's `429`
/// said how long (`Retry-After`); 0 when they may be tried. Both forms
/// read it, because the API counts them together, per address.
///
/// Lifetime: keepAlive, so leaving the form doesn't forget the wait. It
/// counts down once a second.

@ProviderFor(SignInCooldown)
final signInCooldownProvider = SignInCooldownProvider._();

/// How many seconds sign-in and register must wait, after the API's `429`
/// said how long (`Retry-After`); 0 when they may be tried. Both forms
/// read it, because the API counts them together, per address.
///
/// Lifetime: keepAlive, so leaving the form doesn't forget the wait. It
/// counts down once a second.
final class SignInCooldownProvider
    extends $NotifierProvider<SignInCooldown, int> {
  /// How many seconds sign-in and register must wait, after the API's `429`
  /// said how long (`Retry-After`); 0 when they may be tried. Both forms
  /// read it, because the API counts them together, per address.
  ///
  /// Lifetime: keepAlive, so leaving the form doesn't forget the wait. It
  /// counts down once a second.
  SignInCooldownProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInCooldownProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInCooldownHash();

  @$internal
  @override
  SignInCooldown create() => SignInCooldown();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$signInCooldownHash() => r'12c1813021ca9dd99ce6aa976f5b75438e648f46';

/// How many seconds sign-in and register must wait, after the API's `429`
/// said how long (`Retry-After`); 0 when they may be tried. Both forms
/// read it, because the API counts them together, per address.
///
/// Lifetime: keepAlive, so leaving the form doesn't forget the wait. It
/// counts down once a second.

abstract class _$SignInCooldown extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
