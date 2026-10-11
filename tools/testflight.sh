#!/usr/bin/env bash
# Builds a signed release IPA and uploads it to App Store Connect (TestFlight).
#
# Signing uses the App Store Connect API key (no Xcode account login), so the same script
# works on a developer Mac and in CI.
#
# Requirements
#   - FVM with the Flutter version in .fvmrc, Xcode
#   - App Store Connect API key (Admin or App Manager role):
#     ~/.private_keys/AuthKey_<ASC_KEY_ID>.p8   — never commit it
#   - Environment: ASC_KEY_ID, ASC_ISSUER_ID
#
# Usage
#   ASC_KEY_ID=XXXX ASC_ISSUER_ID=yyyy tools/testflight.sh               # build + upload
#   ASC_KEY_ID=XXXX ASC_ISSUER_ID=yyyy tools/testflight.sh --build-only  # signed IPA only
#
# The build number is the git commit count, so every upload from a new commit is unique.
set -euo pipefail

cd "$(dirname "$0")/.."

build_only=false
[ "${1:-}" = "--build-only" ] && build_only=true

fail() { echo "error: $*" >&2; exit 1; }

command -v fvm >/dev/null || fail "fvm not found (https://fvm.app)"
command -v xcodebuild >/dev/null || fail "Xcode not found"
[ -n "${ASC_KEY_ID:-}" ] || fail "ASC_KEY_ID is not set"
[ -n "${ASC_ISSUER_ID:-}" ] || fail "ASC_ISSUER_ID is not set"
key_file="$HOME/.private_keys/AuthKey_${ASC_KEY_ID}.p8"
[ -f "$key_file" ] || fail "API key not found: $key_file"

if [ -n "$(git status --porcelain)" ]; then
  echo "warning: uncommitted changes — the build number will not identify this exact source" >&2
fi

build_number="$(git rev-list --count HEAD)"
version="$(grep -E '^version:' pubspec.yaml | sed -E 's/version: *([0-9.]+).*/\1/')"
archive="build/ios/archive/Runner.xcarchive"
ipa_dir="build/ios/ipa"
auth=(-allowProvisioningUpdates
      -authenticationKeyPath "$key_file"
      -authenticationKeyID "$ASC_KEY_ID"
      -authenticationKeyIssuerID "$ASC_ISSUER_ID")

echo "==> BeneathSOS $version ($build_number)"

echo "==> Dart: dependencies and code generation"
fvm flutter pub get
fvm dart run build_runner build

echo "==> Flutter: release configuration"
fvm flutter build ios --release --config-only --build-number="$build_number"

echo "==> Xcode: archive"
rm -rf "$archive"
xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -configuration Release \
  -destination "generic/platform=iOS" -archivePath "$archive" \
  "${auth[@]}" archive -quiet

echo "==> Xcode: export signed IPA"
rm -rf "$ipa_dir"
xcodebuild -exportArchive -archivePath "$archive" -exportPath "$ipa_dir" \
  -exportOptionsPlist ios/ExportOptions.plist "${auth[@]}" -quiet

ipa="$(ls "$ipa_dir"/*.ipa 2>/dev/null | head -1)"
[ -n "$ipa" ] || fail "IPA not produced"
echo "IPA: $ipa"

if $build_only; then
  exit 0
fi

echo "==> Upload to App Store Connect"
xcrun altool --upload-app --type ios \
  --file "$ipa" \
  --apiKey "$ASC_KEY_ID" \
  --apiIssuer "$ASC_ISSUER_ID"

echo "Uploaded $version ($build_number). Processing on App Store Connect usually takes 10–30 minutes."
