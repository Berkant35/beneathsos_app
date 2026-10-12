import 'package:rubble_core/rubble_core.dart';

/// The sample data the preview screens show, recorded as a practice search.
abstract final class PracticeSample {
  /// Engine profile of the practice site.
  static const engineProfile = 'voided_pancake@1';

  /// The 18.2 × 12.4 m outline drawn on the site screen.
  static final outline = RubblePolygon(const [
    SitePoint(Meters.zero, Meters.zero),
    SitePoint(Meters(18.2), Meters.zero),
    SitePoint(Meters(18.2), Meters(12.4)),
    SitePoint(Meters.zero, Meters(12.4)),
  ]);

  /// Phones heard on the surface during the ambient scan.
  static const surfacePhones = ['practice-surface-1', 'practice-surface-2'];

  /// Length of the ambient scan.
  static const ambientScan = Duration(seconds: 30);

  /// The tracked phone.
  static const target = TargetId('practice-target');

  /// Its Bluetooth identity.
  static const targetKey = 'practice-apple-1';

  /// Its label on the target screen.
  static const targetLabel = 'Apple · Find My';

  /// One point measurement.
  static const measurement = Duration(seconds: 15);

  /// The reading shown on the measure screen.
  static final reading = SignalHeard(
    target,
    median: const Dbm(-71),
    samples: 30,
  );

  /// Where the [index]-th practice point lies (inside the outline).
  static SitePoint pointAt(int index) =>
      SitePoint(Meters(2 + (index * 5) % 15), Meters(2 + (index * 3) % 9));
}
