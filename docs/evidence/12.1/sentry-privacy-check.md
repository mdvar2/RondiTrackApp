# Sentry privacy check, 2026-11-26 (Huawei MAO-LX9, dev build, sentry_flutter 10.3.0)

A local proxy answered `GET /api/v1/me/home` with a synthetic 500 ProblemDetails
(synthetic correlation id, no personal data). Signed in as the seed persona
Sipho Dlamini (synthetic seed data). The app showed the failure in words with its
reference, and the app's own observer reported it through the scrubber.

## Event 1: correlationId synthetic-sentry-check-20261126T025941

- Arrived in Sentry with tag `correlationId` and environment `dev`.
- Sentry showed *User Geography* and a device ID.
- The same build, its DSN pointed at a local capture server, showed the bytes
  that left the phone: no `user`, no `ip_address`, no `{{auto}}`, no `geo`, no
  name or email; but `contexts.device.id` (a persistent install id, the same as
  the session's `did`) and `contexts.device.boot_time`.

## The fix (12.1 PR #11)

The scrubber also removes `contexts.device.id`, `contexts.device.boot_time` and
`contexts.app.device_app_hash`, and keeps the model, OS and app version.
Regression tests: `sentry_event_scrubber_test.dart` ("drops the device
identifiers the native SDK adds…") and `sentry_end_to_end_test.dart` (the real
SDK, with the install id on the scope). Both go red without the fix:
`seen-fail-scrubber-device-id.txt`.

Captured again from the fixed build: no device id, no boot time, no device
hash, no user, no IP, no location; model `MAO-LX9` and the correlation id kept.

## Event 2: correlationId synthetic-sentry-check-20261126T032932 (Sentry event 88630aec)

Checked in Sentry, including breadcrumbs and raw JSON: no names, emails,
financial information, IP address, device ID or boot time. Model kept.

Still present: `user.geo` (city, subdivision, country_code, region). This is
**Sentry-side enrichment**: Sentry derives it on arrival from the connection's
IP address, which the app never sends. Sentry's documentation: geographic
information "is extracted from the user's IP address. This occurs even if the
setting to stop storing IP addresses is turned on." Removing it needs the
server-side Advanced Data Scrubbing rule `[Remove] [Anything] from
[$user.geo.**]` (Project Settings → Security & Privacy), which applies to new
events only.

## Event 3: correlationId synthetic-sentry-check-20261126T041012 (Sentry event a2d980a9)

Sent after the `[Remove] [Anything] from [$user.geo.**]` rule was saved (Project
Settings → Security & Privacy → Advanced Data Scrubbing), from the same fixed
build. In Sentry: **no User Geography**, no device ID, no boot time; the
`correlationId` tag, the device model (MAO-LX9) and the OS (Android 12) kept.

## Before and after

| | Event 1 (`…T025941`) | Event 2 (`…T032932`, `88630aec`) | Event 3 (`…T041012`, `a2d980a9`) |
|---|---|---|---|
| `correlationId` tag | yes | yes | yes |
| Name, email, amount, token, proof file | none | none | none |
| `user.ip_address` | none | none | none |
| Device ID (`contexts.device.id`) | **present** | removed (app fix) | removed |
| Boot time | **present** | removed (app fix) | removed |
| `user.geo` (city, region) | **present** (Sentry-side) | **present** (Sentry-side) | removed (Sentry rule) |
| Device model, OS | kept | kept | kept |

## Screenshots (redacted where they showed what is being kept out)

- `sentry-a-issue-received.png`: the issue in Sentry (browser bar cropped off)
- `sentry-b-server-failure.png`: the ServerFailure, release `1.0.0 (2001)`, `dev`
- `sentry-c-event1-before-redacted.png`: event 1; its geography, boot time and
  device id values are **blacked out** here, so this repository doesn't carry them
- `sentry-d-event2-after-device-fix-redacted.png`: event 2; no device id or boot
  time; its geography value blacked out
- `sentry-e-event2-breadcrumbs.png`: breadcrumbs: app lifecycle and a battery
  event only
- `sentry-f-event3-final-no-geo.png`: event 3: tags and contexts, no geography,
  no device id, no boot time
- Event 2's raw JSON was inspected by the owner (its `user.geo` is what led to
  the Sentry rule). The screenshot isn't committed: it shows the DSN's public key.

## Status

- [x] The app sends no user, IP, location, name, email, amount, token, proof
      file name, device id or boot time (captured bytes, tests, events 2 and 3)
- [x] `correlationId` kept; model and OS kept
- [x] Sentry-side location removed by the server rule (event 3, in the UI)
- [ ] **Event 3's raw JSON checked for `user` / `geo`**: pending. The checklist
      is complete only when that is ticked.
