#!/usr/bin/env bash
# Makes a release (README "Releases"), the same on CI and on a laptop:
#
#   BUILD_NUMBER=37 UPLOAD_CERT_SHA256=<fingerprint> tool/release.sh v1.4.0
#
# * The tag must be vX.Y.Z: it is the version name. The build number comes
#   from BUILD_NUMBER (CI: the run number). pubspec.yaml's version line is
#   never edited, and nobody types a version.
# * Builds a staging APK (for App Distribution) and a prod app bundle (for
#   the Play theory), obfuscated, with the symbols and the obfuscation map
#   kept outside the app, in $RELEASE_OUT/symbols.
# * Signed with the upload key, or nothing leaves: without
#   android/key.properties Gradle quietly signs with the debug key, so each
#   build's certificate is compared with UPLOAD_CERT_SHA256 (a setting: a
#   fingerprint is public). A build that doesn't match is moved to
#   $RELEASE_OUT/refused and the script fails.
#
# Optional: FIREBASE_STAGING_CONFIG / FIREBASE_PROD_CONFIG (paths to each
# flavour's config/firebase.<flavour>.json), API_BASE_URL (the staging API
# your reviewer can reach), SENTRY_DSN.
set -euo pipefail

tag="${1:-${GITHUB_REF_NAME:-}}"
if [[ ! "$tag" =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  echo "The tag must be vX.Y.Z (for example v1.4.0); got '${tag}'." >&2
  exit 2
fi
version="${tag#v}"
build="${BUILD_NUMBER:?Set BUILD_NUMBER: on CI, the run number.}"
if [[ ! "$build" =~ ^[1-9][0-9]*$ ]]; then
  echo "BUILD_NUMBER must be a whole number above 0; got '${build}'." >&2
  exit 2
fi
expected="${UPLOAD_CERT_SHA256:?Set UPLOAD_CERT_SHA256 to the SHA-256 fingerprint of the upload key.}"
expected="$(echo "$expected" | tr -d ':[:space:]' | tr '[:upper:]' '[:lower:]')"

out="${RELEASE_OUT:-build/release}"
symbols="$out/symbols"
rm -rf "$out"
mkdir -p "$out" "$symbols"

if [ ! -f android/key.properties ]; then
  echo "warning: no android/key.properties: Gradle will sign with the debug key, and the check below will refuse it." >&2
fi

defines_for() {
  local flavour="$1" firebase="$2"
  echo "--dart-define-from-file=config/$flavour.json"
  if [ -n "$firebase" ]; then echo "--dart-define-from-file=$firebase"; fi
  if [ -n "${API_BASE_URL:-}" ] && [ "$flavour" = staging ]; then
    echo "--dart-define=API_BASE_URL=$API_BASE_URL"
  fi
  if [ -n "${SENTRY_DSN:-}" ]; then echo "--dart-define=SENTRY_DSN=$SENTRY_DSN"; fi
}

common=(--release --build-name "$version" --build-number "$build" --obfuscate)

# shellcheck disable=SC2046
flutter build apk "${common[@]}" --flavor staging \
  $(defines_for staging "${FIREBASE_STAGING_CONFIG:-}") \
  --split-debug-info="$symbols/staging" \
  --extra-gen-snapshot-options=--save-obfuscation-map="$symbols/staging/obfuscation-map.json"

# shellcheck disable=SC2046
flutter build appbundle "${common[@]}" --flavor prod \
  $(defines_for prod "${FIREBASE_PROD_CONFIG:-}") \
  --split-debug-info="$symbols/prod" \
  --extra-gen-snapshot-options=--save-obfuscation-map="$symbols/prod/obfuscation-map.json"

apk="$out/ronditrack-staging-$version+$build.apk"
aab="$out/ronditrack-prod-$version+$build.aab"
cp build/app/outputs/flutter-apk/app-staging-release.apk "$apk"
cp build/app/outputs/bundle/prodRelease/app-prod-release.aab "$aab"

# The certificate each build is signed with.
sdk="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}}"
apksigner="$(ls -d "$sdk"/build-tools/*/ | sort -V | tail -1)apksigner"
[ -x "$apksigner" ] || apksigner="${apksigner}.bat"
apk_cert="$("$apksigner" verify --print-certs "$apk" \
  | sed -n 's/.*certificate SHA-256 digest: //p' | head -1)"
aab_cert="$(keytool -printcert -jarfile "$aab" \
  | sed -n 's/.*SHA256: //p' | head -1 | tr -d ':' | tr '[:upper:]' '[:lower:]')"

refused=0
for pair in "staging APK:$apk_cert:$apk" "prod bundle:$aab_cert:$aab"; do
  name="${pair%%:*}"; rest="${pair#*:}"; cert="${rest%%:*}"; file="${rest#*:}"
  if [ "$cert" != "$expected" ]; then
    echo "REFUSED: the $name is signed with ${cert:-no certificate}, not the upload key ($expected)." >&2
    mkdir -p "$out/refused"
    mv "$file" "$out/refused/"
    refused=1
  else
    echo "Signed with the upload key: $name ($cert)"
  fi
done
if [ "$refused" -ne 0 ]; then
  echo "Nothing leaves: no release was made." >&2
  exit 1
fi

echo "Release $version ($build): $apk, $aab; symbols in $symbols."
