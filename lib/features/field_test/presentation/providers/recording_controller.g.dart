// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recording_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Records raw samples and markers to CSV for offline analysis.

@ProviderFor(RecordingController)
final recordingControllerProvider = RecordingControllerProvider._();

/// Records raw samples and markers to CSV for offline analysis.
final class RecordingControllerProvider
    extends $NotifierProvider<RecordingController, RecordingState> {
  /// Records raw samples and markers to CSV for offline analysis.
  RecordingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordingControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordingControllerHash();

  @$internal
  @override
  RecordingController create() => RecordingController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordingState>(value),
    );
  }
}

String _$recordingControllerHash() =>
    r'77fbffd186ddb84907db66e4756d831205b8da2f';

/// Records raw samples and markers to CSV for offline analysis.

abstract class _$RecordingController extends $Notifier<RecordingState> {
  RecordingState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RecordingState, RecordingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RecordingState, RecordingState>,
              RecordingState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
