// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disclaimer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the current disclaimer was accepted (product rule 5). It gates the rescuer flow, never
/// victim mode. Bump [version] when the disclaimer text changes: everyone sees it again.

@ProviderFor(Disclaimer)
final disclaimerProvider = DisclaimerProvider._();

/// Whether the current disclaimer was accepted (product rule 5). It gates the rescuer flow, never
/// victim mode. Bump [version] when the disclaimer text changes: everyone sees it again.
final class DisclaimerProvider
    extends $AsyncNotifierProvider<Disclaimer, bool> {
  /// Whether the current disclaimer was accepted (product rule 5). It gates the rescuer flow, never
  /// victim mode. Bump [version] when the disclaimer text changes: everyone sees it again.
  DisclaimerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'disclaimerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$disclaimerHash();

  @$internal
  @override
  Disclaimer create() => Disclaimer();
}

String _$disclaimerHash() => r'209f1212c2ae8416a444e057cbe3ffdc8993c86c';

/// Whether the current disclaimer was accepted (product rule 5). It gates the rescuer flow, never
/// victim mode. Bump [version] when the disclaimer text changes: everyone sees it again.

abstract class _$Disclaimer extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
