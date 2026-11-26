# A real push from a real confirmation (2026-11-26, Huawei MAO-LX9, Android 12)

Dev build with `config/firebase.dev.json`, against the local API (Firebase
sender active: "Push: Firebase Cloud Messaging, key from
Push:ServiceAccountPath."). Seed personas only.

1. Sipho signed in. The app's log (debug):
   `Push: Firebase gave this install an id.` then
   `API POST /api/v1/me/devices 204`. The API's `DeviceInstallations` had one
   row, for Sipho.
2. App sent to the background (Home key).
3. Through the API: Sipho paid R 500,00 into Mabena Family 2026-11 → **201**;
   Lerato (treasurer) confirmed it → **204**.
4. The phone received an FCM notification (`dumpsys notification`):
   - title `RondiTrack`, text `There's an update on your stokvel.`
   - channel `stokvel_updates` (importance high), visibility `PRIVATE`
   - no name, amount, stokvel name or decision

Found on the way: firebase_messaging 17 refuses `register()` with "API
disabled" until the manifest opts in
(`firebase_messaging_installation_id_enabled`). The registration skipped it
quietly, as designed; a debug-only log of skipped steps (`onSkipped`) showed
why.

Still to add by hand: a screenshot of the notification in the shade, and on the
lock screen with "hide sensitive content" on.

## A tap from a closed app (04:23)

Sipho signed in again (registered: `POST /api/v1/me/devices 204`). Home key,
then `adb shell am kill za.co.gwinya.ronditrack_app.dev` (no process left; force
stop would also clear notifications). Lerato confirmed his payment through the
API (**204**). The notification arrived (`RondiTrack` / `There's an update on
your stokvel.`) while the app was closed. Tapped by hand in the shade: the app
opened straight on **Mabena Family, Cycle 2026-11**, fetched from the API
(`GET /api/v1/stokvels/…/cycles/…`), with Sipho's R 500,00 **Confirmed**
(`tap-from-closed-opens-the-cycle.png`). The details came from the API after
the tap, never from the push.

## The lock screen, the shade and the icons (04:28 to 04:35)

- `lock-screen-sensitive-content-shown.png`: Android's own switch
  `lock_screen_allow_private_notifications` was 1 (show sensitive content), so
  the private notification showed in full. Even shown in full it says only
  "RondiTrack / There's an update on your stokvel."
- `lock-screen-sensitive-content-hidden.png`: the switch set to 0 over USB
  (with the owner's agreement, and set back to 1 afterwards). The lock screen
  shows **only "RondiTrack Dev, 2 notifications"**: no text.
- `notification-in-the-shade.png`: the notifications in the shade, generic text
  only. The first ones showed their time as "1/01/03": the Admin SDK sent .NET's
  default date because the sender set no event time. Fixed in the API
  (`EventTimestamp`, with a test); the next push showed "Just now".
- `three-flavours-side-by-side.png`: RondiTrack Dev, RondiTrack and
  RondiTrack Staging installed together, each with its own icon.
