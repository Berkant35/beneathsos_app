// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Settings on the app database.

@ProviderFor(settingsStore)
final settingsStoreProvider = SettingsStoreProvider._();

/// Settings on the app database.

final class SettingsStoreProvider
    extends $FunctionalProvider<SettingsStore, SettingsStore, SettingsStore>
    with $Provider<SettingsStore> {
  /// Settings on the app database.
  SettingsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsStoreHash();

  @$internal
  @override
  $ProviderElement<SettingsStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SettingsStore create(Ref ref) {
    return settingsStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsStore>(value),
    );
  }
}

String _$settingsStoreHash() => r'31e55abeb1acbec4fe641b0807d8916423085832';

/// One stored setting, following every write.

@ProviderFor(settingValue)
final settingValueProvider = SettingValueFamily._();

/// One stored setting, following every write.

final class SettingValueProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, Stream<String?>>
    with $FutureModifier<String?>, $StreamProvider<String?> {
  /// One stored setting, following every write.
  SettingValueProvider._({
    required SettingValueFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'settingValueProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$settingValueHash();

  @override
  String toString() {
    return r'settingValueProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<String?> create(Ref ref) {
    final argument = this.argument as String;
    return settingValue(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SettingValueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$settingValueHash() => r'5a76c321e2634f3d66ab19e737b65814941fa94d';

/// One stored setting, following every write.

final class SettingValueFamily extends $Family
    with $FunctionalFamilyOverride<Stream<String?>, String> {
  SettingValueFamily._()
    : super(
        retry: null,
        name: r'settingValueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// One stored setting, following every write.

  SettingValueProvider call(String key) =>
      SettingValueProvider._(argument: key, from: this);

  @override
  String toString() => r'settingValueProvider';
}

/// What the rescuer chose in Settings (the defaults until the stored values are read).

@ProviderFor(appSettings)
final appSettingsProvider = AppSettingsProvider._();

/// What the rescuer chose in Settings (the defaults until the stored values are read).

final class AppSettingsProvider
    extends $FunctionalProvider<AppSettings, AppSettings, AppSettings>
    with $Provider<AppSettings> {
  /// What the rescuer chose in Settings (the defaults until the stored values are read).
  AppSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appSettingsHash();

  @$internal
  @override
  $ProviderElement<AppSettings> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppSettings create(Ref ref) {
    return appSettings(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppSettings>(value),
    );
  }
}

String _$appSettingsHash() => r'8f2e66621cacf51482e49227d4ae64d1592f48a2';

/// Stores Settings.

@ProviderFor(updateSettings)
final updateSettingsProvider = UpdateSettingsProvider._();

/// Stores Settings.

final class UpdateSettingsProvider
    extends $FunctionalProvider<UpdateSettings, UpdateSettings, UpdateSettings>
    with $Provider<UpdateSettings> {
  /// Stores Settings.
  UpdateSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateSettingsHash();

  @$internal
  @override
  $ProviderElement<UpdateSettings> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateSettings create(Ref ref) {
    return updateSettings(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateSettings>(value),
    );
  }
}

String _$updateSettingsHash() => r'6a0cf143155190a9bf9ac070e1fa33156c191a02';
