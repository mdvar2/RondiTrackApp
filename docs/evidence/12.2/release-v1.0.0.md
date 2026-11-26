# Release v1.0.0 (2026-11-26)

Tag `v1.0.0` (annotated) on `984d84b` (main, CI green:
https://github.com/mdvar2/RondiTrackApp/actions/runs/45752612983), pushed
before the run; no tag existed before it.

**Release run:** https://github.com/mdvar2/RondiTrackApp/actions/runs/45754343369
(workflow `release.yml`, event `push` of `v1.0.0`, run number **1**, 9 min 19 s,
**success**). Every action pinned to a commit.

## Built and signed (`tool/release.sh`, from the run's log)

```
Signed with the upload key: staging APK (b98c03471f56f267669f1af7c534ba534991dbbcd3b118815512590bd88534ca)
Signed with the upload key: prod bundle (b98c03471f56f267669f1af7c534ba534991dbbcd3b118815512590bd88534ca)
Release 1.0.0 (1): build/release/ronditrack-staging-1.0.0+1.apk, build/release/ronditrack-prod-1.0.0+1.aab; symbols in build/release/symbols.
```

## The artifact `release-v1.0.0-1`, downloaded and checked

| | |
|---|---|
| `ronditrack-staging-1.0.0+1.apk` | 70 671 413 bytes; `apksigner`: verified (v2), 1 signer, certificate SHA-256 **b98c0347…34ca** (the upload key) |
| Badging (`aapt2`) | package `za.co.gwinya.ronditrack_app.staging`, **versionName 1.0.0, versionCode 1**, label *RondiTrack Staging*, targetSdk 36, compileSdk 37 |
| Staging API | the HTTPS tunnel address (`STAGING_API_BASE_URL`) is compiled in |
| `ronditrack-prod-1.0.0+1.aab` | 67 050 715 bytes; `keytool`: `CN=RondiTrack upload key`, SHA-256 **B9:8C:03:47:…:34:CA** |
| `symbols/staging`, `symbols/prod` | split debug info and `obfuscation-map.json` for each, kept outside the app |

The version name came from the tag and the build number from the run; nobody
typed either. `pubspec.yaml` still says `1.0.0+1`, untouched.

## Symbols to Sentry (EU organisation `nelisiwe-gwinya`, project `flutter`)

```
Uploaded 17 missing debug information files      (Flutter .so.sym, every ABI)
Uploaded 51 missing debug information files      (native libraries)
Created release za.co.gwinya.ronditrack_app.staging@1.0.0+1
Success! Set commits for release za.co.gwinya.ronditrack_app.staging@1.0.0+1
Finalized release za.co.gwinya.ronditrack_app.staging@1.0.0+1
```

The release name is the one the app reports (`<application id>@<version>+<build>`,
dist `1`). Not uploaded: the **Dart obfuscation map**
(`Skipping Dart symbol map uploads: no 'dart_symbol_map_path' provided`), so
obfuscated Dart names in a crash aren't translated back in Sentry yet; the map
is in the artifact. Fix for the next release:
`--sentry-define=dart_symbol_map_path=build/release/symbols/staging/obfuscation-map.json`.
sentry-cli also warned that the token's embedded `https://sentry.io` was used
instead of `SENTRY_URL` (`https://de.sentry.io`); the uploads, release and
commits all succeeded.

## Firebase App Distribution

From the run:

```
✔ uploaded new release 1.0.0 (1) successfully!
✔ added release notes successfully
✔ distributed to testers/groups successfully
```

Confirmed through the App Distribution API (read-only, with the distribution
service account): release **1.0.0 (1)**, created 2026-11-26T04:27:21Z, notes
"RondiTrack staging v1.0.0 (build 1)"; group **Testers** (`testers`), 2 testers.

Still to add: the reviewer's confirmation that they installed it from the email
and signed in.
