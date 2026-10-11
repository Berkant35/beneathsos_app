# Changelog

All notable changes to the BeneathSOS app. Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/);
versions follow [Semantic Versioning](https://semver.org/). Build numbers are the git commit count
and appear only in TestFlight.

## [Unreleased]

## [0.1.0] - 2026-10-11

Foundations release. The app shows a placeholder home screen; the rescuer and victim flows follow
the [roadmap](https://github.com/Berkant35/beneathsos/blob/main/docs/roadmap.md).
TestFlight builds: 0.1.0 (4), 0.1.0 (6).

### Added
- App shell: Riverpod 3, typed go_router routes, English and Turkish localisation, high-contrast
  theme, `AppScaffold`, placeholder home screen.
- Bluetooth scanning through the `ble_scanner` plugin (v0.1.0): `BleService`, permission and
  keep-awake services, app-lifecycle stream.
- Scanning domain: `StartScan` / `StopScan` use cases with ordered preconditions (permission,
  Bluetooth), ports for scanner, permissions and screen, and an adapter-availability policy.
  `ScanController` exposes a sealed scan state and retries after the user returns from Settings or
  turns Bluetooth back on.
- Target tracking domain: `DeviceTracker` with `TrackerPolicy` (warm-up 5 s, "gone" after 15 s,
  dropped from the list after 30 s, presence log capped at 500), device classification (Apple Find
  My, Apple Nearby, …), relink suggestions after identity rotation; `TrackedDevices` provider.
- Release pipeline: `tools/testflight.sh` signs with an App Store Connect API key and uploads to
  TestFlight. Bundle / application id `org.beneathsos.app`.
- 52 unit, provider and widget tests; CI on every push and pull request.

### Changed
- Notifiers are thin: rules moved to pure Dart domain classes (`ScanController` 156 → 85 lines,
  `DeviceTable` replaced by `TrackedDevices`).
- App lifecycle is handled by the providers that need it; `app.dart` no longer calls into features.
- `permission_handler` pinned to 12.x (13.x needs Android SDK 37, which the current Android Gradle
  Plugin cannot resolve).

### Removed
- The M1 field-test screens and CSV recorder (their domain logic was kept). This also removed
  `path_provider` and `share_plus`, and with them the native `jni` build that required the NDK.

[Unreleased]: https://github.com/Berkant35/beneathsos_app/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/Berkant35/beneathsos_app/releases/tag/v0.1.0
