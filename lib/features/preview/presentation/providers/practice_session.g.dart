// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_session.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Records the preview journey as a practice search; the state is its session id (null before
/// "Start"). Steps run one after the other in call order, so screens need not wait for them; a
/// failed write is logged and never blocks the preview.

@ProviderFor(PracticeSession)
final practiceSessionProvider = PracticeSessionProvider._();

/// Records the preview journey as a practice search; the state is its session id (null before
/// "Start"). Steps run one after the other in call order, so screens need not wait for them; a
/// failed write is logged and never blocks the preview.
final class PracticeSessionProvider
    extends $NotifierProvider<PracticeSession, SessionId?> {
  /// Records the preview journey as a practice search; the state is its session id (null before
  /// "Start"). Steps run one after the other in call order, so screens need not wait for them; a
  /// failed write is logged and never blocks the preview.
  PracticeSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'practiceSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$practiceSessionHash();

  @$internal
  @override
  PracticeSession create() => PracticeSession();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionId? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionId?>(value),
    );
  }
}

String _$practiceSessionHash() => r'9a18e9e0070f71001c69fb79898d2cd1fea99d1f';

/// Records the preview journey as a practice search; the state is its session id (null before
/// "Start"). Steps run one after the other in call order, so screens need not wait for them; a
/// failed write is logged and never blocks the preview.

abstract class _$PracticeSession extends $Notifier<SessionId?> {
  SessionId? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SessionId?, SessionId?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SessionId?, SessionId?>,
              SessionId?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
