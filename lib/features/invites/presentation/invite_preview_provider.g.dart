// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_preview_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One invite's preview, keyed by its code. Lifetime: autoDispose.

@ProviderFor(invitePreview)
final invitePreviewProvider = InvitePreviewFamily._();

/// One invite's preview, keyed by its code. Lifetime: autoDispose.

final class InvitePreviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<InvitePreview>,
          InvitePreview,
          FutureOr<InvitePreview>
        >
    with $FutureModifier<InvitePreview>, $FutureProvider<InvitePreview> {
  /// One invite's preview, keyed by its code. Lifetime: autoDispose.
  InvitePreviewProvider._({
    required InvitePreviewFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'invitePreviewProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$invitePreviewHash();

  @override
  String toString() {
    return r'invitePreviewProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<InvitePreview> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<InvitePreview> create(Ref ref) {
    final argument = this.argument as String;
    return invitePreview(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is InvitePreviewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$invitePreviewHash() => r'98e3bd35b027b8fc88c42f757d797f376b54d9e8';

/// One invite's preview, keyed by its code. Lifetime: autoDispose.

final class InvitePreviewFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<InvitePreview>, String> {
  InvitePreviewFamily._()
    : super(
        retry: null,
        name: r'invitePreviewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One invite's preview, keyed by its code. Lifetime: autoDispose.

  InvitePreviewProvider call(String code) =>
      InvitePreviewProvider._(argument: code, from: this);

  @override
  String toString() => r'invitePreviewProvider';
}

/// Joining one invite: `null` until joined, then the stokvel's id.
///
/// Lifetime: autoDispose, keyed by code, like the preview it sits beside.

@ProviderFor(InviteJoiner)
final inviteJoinerProvider = InviteJoinerFamily._();

/// Joining one invite: `null` until joined, then the stokvel's id.
///
/// Lifetime: autoDispose, keyed by code, like the preview it sits beside.
final class InviteJoinerProvider
    extends $NotifierProvider<InviteJoiner, AsyncValue<String?>> {
  /// Joining one invite: `null` until joined, then the stokvel's id.
  ///
  /// Lifetime: autoDispose, keyed by code, like the preview it sits beside.
  InviteJoinerProvider._({
    required InviteJoinerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'inviteJoinerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$inviteJoinerHash();

  @override
  String toString() {
    return r'inviteJoinerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  InviteJoiner create() => InviteJoiner();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<String?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<String?>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is InviteJoinerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$inviteJoinerHash() => r'd570e89bb0d0e91dc0e163ea97357ac08e8b8e54';

/// Joining one invite: `null` until joined, then the stokvel's id.
///
/// Lifetime: autoDispose, keyed by code, like the preview it sits beside.

final class InviteJoinerFamily extends $Family
    with
        $ClassFamilyOverride<
          InviteJoiner,
          AsyncValue<String?>,
          AsyncValue<String?>,
          AsyncValue<String?>,
          String
        > {
  InviteJoinerFamily._()
    : super(
        retry: null,
        name: r'inviteJoinerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Joining one invite: `null` until joined, then the stokvel's id.
  ///
  /// Lifetime: autoDispose, keyed by code, like the preview it sits beside.

  InviteJoinerProvider call(String code) =>
      InviteJoinerProvider._(argument: code, from: this);

  @override
  String toString() => r'inviteJoinerProvider';
}

/// Joining one invite: `null` until joined, then the stokvel's id.
///
/// Lifetime: autoDispose, keyed by code, like the preview it sits beside.

abstract class _$InviteJoiner extends $Notifier<AsyncValue<String?>> {
  late final _$args = ref.$arg as String;
  String get code => _$args;

  AsyncValue<String?> build(String code);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String?>, AsyncValue<String?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, AsyncValue<String?>>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
