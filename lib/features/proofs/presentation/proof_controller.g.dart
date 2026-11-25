// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proof_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One contribution's proof upload. On screen the button watches it; a
/// test listens to it (an autoDispose provider can be disposed halfway).

@ProviderFor(ProofUpload)
final proofUploadProvider = ProofUploadFamily._();

/// One contribution's proof upload. On screen the button watches it; a
/// test listens to it (an autoDispose provider can be disposed halfway).
final class ProofUploadProvider
    extends $NotifierProvider<ProofUpload, ProofState> {
  /// One contribution's proof upload. On screen the button watches it; a
  /// test listens to it (an autoDispose provider can be disposed halfway).
  ProofUploadProvider._({
    required ProofUploadFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'proofUploadProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$proofUploadHash();

  @override
  String toString() {
    return r'proofUploadProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProofUpload create() => ProofUpload();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProofState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProofState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProofUploadProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$proofUploadHash() => r'374e82ce9933b961f4ace7b64fc78c7e35fc6dcd';

/// One contribution's proof upload. On screen the button watches it; a
/// test listens to it (an autoDispose provider can be disposed halfway).

final class ProofUploadFamily extends $Family
    with
        $ClassFamilyOverride<
          ProofUpload,
          ProofState,
          ProofState,
          ProofState,
          String
        > {
  ProofUploadFamily._()
    : super(
        retry: null,
        name: r'proofUploadProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One contribution's proof upload. On screen the button watches it; a
  /// test listens to it (an autoDispose provider can be disposed halfway).

  ProofUploadProvider call(String contributionId) =>
      ProofUploadProvider._(argument: contributionId, from: this);

  @override
  String toString() => r'proofUploadProvider';
}

/// One contribution's proof upload. On screen the button watches it; a
/// test listens to it (an autoDispose provider can be disposed halfway).

abstract class _$ProofUpload extends $Notifier<ProofState> {
  late final _$args = ref.$arg as String;
  String get contributionId => _$args;

  ProofState build(String contributionId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ProofState, ProofState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProofState, ProofState>,
              ProofState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
