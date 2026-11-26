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
