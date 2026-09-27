# BeneathSOS app

Flutter app of [BeneathSOS](https://github.com/Berkant35/beneathsos). Current milestone **M1**:
field test tool — device list, target marking, live RSSI chart, identity (address rotation) log,
CSV recording with markers.

## Run
```bash
fvm install
fvm flutter pub get          # resolves ble_scanner from GitHub
fvm dart run build_runner build
fvm flutter run
```
Working on `ble_scanner` at the same time: clone the hub and run `tools/link_local.sh`
(creates a git-ignored `pubspec_overrides.yaml` pointing to the local plugin).

iOS signing uses the maintainer's team (`5W2U3NK284`); change `DEVELOPMENT_TEAM` to your own.

Rules: see the hub's `CLAUDE.md`. Licence: Apache-2.0.
