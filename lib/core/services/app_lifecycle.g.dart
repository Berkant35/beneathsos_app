// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_lifecycle.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// App lifecycle changes (resumed, paused, …) as a stream.
///
/// Consumers listen to this in their own `build()`; `app.dart` never calls into features.

@ProviderFor(appLifecycle)
final appLifecycleProvider = AppLifecycleProvider._();

/// App lifecycle changes (resumed, paused, …) as a stream.
///
/// Consumers listen to this in their own `build()`; `app.dart` never calls into features.

final class AppLifecycleProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppLifecycleState>,
          AppLifecycleState,
          Stream<AppLifecycleState>
        >
    with
        $FutureModifier<AppLifecycleState>,
        $StreamProvider<AppLifecycleState> {
  /// App lifecycle changes (resumed, paused, …) as a stream.
  ///
  /// Consumers listen to this in their own `build()`; `app.dart` never calls into features.
  AppLifecycleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLifecycleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLifecycleHash();

  @$internal
  @override
  $StreamProviderElement<AppLifecycleState> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<AppLifecycleState> create(Ref ref) {
    return appLifecycle(ref);
  }
}

String _$appLifecycleHash() => r'310fbb90621fa8d2f792ce12b257d763d649b890';
