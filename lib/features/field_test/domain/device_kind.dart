import 'package:beneathsos_app/core/models/ble_sample.dart';

/// Coarse advertiser category derived from manufacturer data.
enum DeviceKind {
  /// Apple offline-finding beacon: an iPhone without internet, or an AirTag.
  appleFindMy,

  /// Apple Nearby Info (unlocked/locked iPhone, iPad, Mac nearby state).
  appleNearby,

  /// Any other Apple advertisement.
  appleOther,

  /// Samsung.
  samsung,

  /// Microsoft.
  microsoft,

  /// Google.
  google,

  /// Manufacturer data from another company.
  other,

  /// No manufacturer data.
  unknown;

  /// Whether this is any Apple advertisement.
  bool get isApple =>
      this == appleFindMy || this == appleNearby || this == appleOther;
}

/// Bluetooth SIG company identifiers used for classification.
abstract final class _Company {
  static const apple = 0x004C;
  static const microsoft = 0x0006;
  static const samsung = 0x0075;
  static const google = 0x00E0;
}

/// First payload byte of Apple Continuity message types.
abstract final class _AppleType {
  static const findMy = 0x12;
  static const nearbyInfo = 0x10;
}

/// Classifies a sample by its manufacturer data. Pure function.
DeviceKind classify(BleSample sample) {
  final payload = sample.payload;
  return switch (sample.companyId) {
    null => DeviceKind.unknown,
    _Company.apple when payload != null && payload.isNotEmpty =>
      switch (payload.first) {
        _AppleType.findMy => DeviceKind.appleFindMy,
        _AppleType.nearbyInfo => DeviceKind.appleNearby,
        _ => DeviceKind.appleOther,
      },
    _Company.apple => DeviceKind.appleOther,
    _Company.samsung => DeviceKind.samsung,
    _Company.microsoft => DeviceKind.microsoft,
    _Company.google => DeviceKind.google,
    _ => DeviceKind.other,
  };
}
