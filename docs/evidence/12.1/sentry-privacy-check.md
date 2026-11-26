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

**Status: not complete** until an event received after that rule shows no
`user.geo`. Sentry screenshots: to be added to the pull request.
