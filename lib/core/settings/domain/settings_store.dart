/// Small key–value settings that survive restarts (disclaimer accepted, units, …).
abstract interface class SettingsStore {
  /// The value of [key] (null when never written), updated after every write.
  Stream<String?> watch(String key);

  /// Stores [value] under [key], replacing an earlier value.
  Future<void> write(String key, String value);
}
