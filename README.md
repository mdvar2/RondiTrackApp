# RondiTrack Mobile

The RondiTrack phone app (Flutter, Android and iOS). It shows each person their stokvels, what they've paid and owe, and what they can do in each stokvel, given their role there.

This is Week 10: Assignment 10.1 (foundations and state) and Assignment 10.2 (every screen has an address). **Nothing calls the API yet.** Fake repositories hold three seed personas. Week 11 swaps them for the real API in [`lib/app/providers.dart`](lib/app/providers.dart), and no widget changes.

- API repository: [mdvar2/RondiTrack](https://github.com/mdvar2/RondiTrack)
- API contract copy: [`contract/openapi/v1.json`](contract/openapi/v1.json), from API commit [`3d04a52`](https://github.com/mdvar2/RondiTrack/commit/3d04a5238c72b0b3e1742a1067170a20ae13e97a) (byte-identical to `openapi/v1.json` at that commit; SHA-256 `7292b744…4a0dc3`)

## Contents

- [At a glance](#at-a-glance)
- [How to read this README](#how-to-read-this-readme) (with a [glossary](#glossary))
- [Part 1: Navigation, every screen has an address](#part-1-navigation-every-screen-has-an-address)
  - [Routes](#routes)
  - [The gate](#the-gate)
  - [Deep links](#deep-links)
- [Part 2: Getting started](#part-2-getting-started)
  - [Running it](#running-it)
    - [Flavours and config files](#flavours-and-config-files)
    - [Dependencies](#dependencies)
- [Part 3: How the code is organised](#part-3-how-the-code-is-organised)
  - [Architecture](#architecture)
  - [Generated code](#generated-code)
  - [Lints, and why `flutter analyze` isn't enough](#lints-and-why-flutter-analyze-isnt-enough)
- [Part 4: State and provider lifetimes](#part-4-state-and-provider-lifetimes)
  - [State with Riverpod](#state-with-riverpod)
  - [Provider lifetimes](#provider-lifetimes)
- [Part 5: Look and layout](#part-5-look-and-layout)
  - [Theme](#theme)
  - [Layouts](#layouts)
- [Part 6: Domain rules](#part-6-domain-rules)
  - [Money](#money)
  - [What can I do here?](#what-can-i-do-here)
  - [When the API adds a status](#when-the-api-adds-a-status)
- [Part 7: The API contract](#part-7-the-api-contract)
  - [Contract notes](#contract-notes)
    - [1. How the API spells statuses and roles](#1-how-the-api-spells-statuses-and-roles)
    - [2. Which endpoints return the caller's role, and where](#2-which-endpoints-return-the-callers-role-and-where)
    - [3. What `/me/home` returns per stokvel](#3-what-mehome-returns-per-stokvel)
    - [4. Due dates: date-only or instants?](#4-due-dates-date-only-or-instants)
    - [5. The three seed personas](#5-the-three-seed-personas)
    - [Gaps found, and backend pull requests](#gaps-found-and-backend-pull-requests)
- [Part 8: Tests, CI and evidence](#part-8-tests-ci-and-evidence)
  - [Tests and CI](#tests-and-ci)
  - [Verification](#verification)
    - [Emulator evidence](#emulator-evidence)
    - [Assignment 10.2: verification](#assignment-102-verification)
    - [Assignment 10.2: emulator evidence](#assignment-102-emulator-evidence)
- [Part 9: Still open](#part-9-still-open)
  - [Still open](#still-open)

---

## At a glance

| | What it delivered | Where to read about it |
|---|---|---|
| **Assignment 10.1**: foundations and state | Three flavours with validated config; the domain (money in cents, date-only due dates, statuses with an `unknown` fallback, roles per stokvel); three seed personas on fake repositories; Riverpod state with deliberate lifetimes; strict lints and CI | [Part 2](#part-2-getting-started), [Part 3](#part-3-how-the-code-is-organised), [Part 4](#part-4-state-and-provider-lifetimes), [Part 6](#part-6-domain-rules), [Part 7](#part-7-the-api-contract) |
| **Assignment 10.2**: every screen has an address | Four tabs that keep their place; typed routes for every screen; a fake sign-in and one testable gate; deep links per flavour; a Material 3 light and dark design system with measured contrast; phone and tablet layouts | [Part 1](#part-1-navigation-every-screen-has-an-address), [Part 5](#part-5-look-and-layout) |
| **Checks** | 268 tests passing (139 of them from 10.1); `dart analyze --fatal-infos` clean; CI green on `main` | [Part 8](#part-8-tests-ci-and-evidence) |

---

## How to read this README

- **Reviewing the app?** Start with [Routes](#routes), the map the app is checked against, then [The gate](#the-gate) and [Deep links](#deep-links).
- **Running it?** Go to [Running it](#running-it).
- **Learning how it's built?** Read the parts in order. Each section opens with a short note marked as a quote, **In plain words** or **Why**, that explains the idea for someone new to it. The text after that note is the detailed record: exact rules, commands, file links, test results and evidence.
- Links to files (like [`redirect.dart`](lib/app/router/redirect.dart)) open the code being described.

### Glossary

| Term | Meaning here |
|---|---|
| **Stokvel** | A savings club, common in South Africa: members pay in an agreed amount each period, and the pot is paid out to members in turn or at an agreed time |
| **Cycle** | One period of a stokvel (here a month, such as `2026-11`), with a status: `Open`, `Closed` or `PaidOut` |
| **Contribution** | One member's payment in a cycle, with a status: `Pending`, `Paid` or `Confirmed` |
| **Arrears** | Money a member still owes from an earlier cycle |
| **Role** | Member, Treasurer or Chairperson. It belongs to a person's membership of *one* stokvel, never to the person |
| **Persona** | One of the three made-up test people (Lerato, Sipho, Thabo) the fakes can sign in as |
| **Fake repository** | Code that answers like the real API, from data built into the app, so the app works before it calls a server |
| **Flavour** | One of three builds of the app (dev, staging, prod), each with its own id, name, settings and link scheme |
| **Provider** | A Riverpod object that holds some state and that screens subscribe to |
| **keepAlive / autoDispose** | Whether a provider lives for the whole session, or is disposed as soon as nothing uses it |
| **Route / address** | The path that identifies a screen, such as `/stokvels/:id` (`:id` is filled in with a real id) |
| **Typed route** | A route as a Dart class (`StokvelRoute(id: …)`), so a mistyped address is a compile error instead of a broken link |
| **Shell / branch** | The frame around the four tabs (the *shell*); each tab is a *branch* with its own stack of screens |
| **Redirect / gate** | Sending a navigation somewhere else (to sign-in, say); the gate is the one function that decides when |
| **Deep link** | A link that opens a particular screen in the app |
| **Cold start** | The app being started from nothing (not running before) |
| **dp** | Density-independent pixel, Flutter's unit of size |
| **WCAG contrast ratio** | The accessibility measure of how readable text is on its background (4.5:1 needed for normal text) |
| **CI** | Continuous integration: GitHub runs format, code generation, analysis and tests on every pull request |

---

## Part 1: Navigation, every screen has an address

*Assignment 10.2. How screens are addressed, who may open them, and how links from outside the app reach them.*

### Routes

> **In plain words.** In a phone app built this way, every screen has an *address*, like a web page's URL: `/stokvels/abc` means "the stokvel with id `abc`". Addresses let something outside the app (a link, a push notification) open one exact screen, and they make the back button predictable, because the screens underneath an address are always the same.
>
> **How to read the table.** Each row is one address. *Signed out* says what happens to someone who isn't signed in; *Not a member* says what a person sees for a stokvel they don't belong to; *Back goes to* says where Android's back gesture lands, including when the address opened the app from nothing (a *cold start*). A *stack* is the pile of screens in one tab: opening a screen puts it on top; back takes it off.
>
> **Why this table comes first.** The assignment asked for it to be written before any route existed, as the map a reviewer checks the app against. Each row's signed-out and not-a-member behaviour, and its back target, is tested in [`router_test.dart`](test/app/router/router_test.dart) or [`redirect_test.dart`](test/app/router/redirect_test.dart). The one exception is "Leaves the app" from Home, which a widget test can't observe; it was checked on the emulator instead.

Every screen has an address. Four tabs (**Home**, **Stokvels**, **Activity**, **Profile**) each keep their own stack. `:id` and `:cycleId` are API ids (UUIDs); `:code` is an invite code such as `MABENA26`.

| Address | Screen and tab | Signed out | Not a member | Back goes to |
|---|---|---|---|---|
| `/` | Home: one card per stokvel I'm in. **Home** tab | Sign-in, then Home | Not applicable: Home lists only my stokvels | Leaves the app |
| `/stokvels` | My stokvels, a list (840 dp or wider: the list beside an empty detail pane). **Stokvels** tab | Sign-in, then `/stokvels` | Not applicable: lists only my stokvels | Home tab (`/`) |
| `/stokvels/:id` | One stokvel: current cycle, what I can do there (from my role in *this* stokvel), contributions. 840 dp or wider: list and detail side by side. **Stokvels** tab | Sign-in, then this stokvel | **"We couldn't find that stokvel."**, word for word what an id that doesn't exist shows | `/stokvels`, also after a cold start |
| `/stokvels/:id/cycles/:cycleId` | One cycle: progress and its contributions. **Stokvels** tab | Sign-in, then this cycle | **"We couldn't find that cycle."**, the same for a cycle that doesn't exist, a cycle of another stokvel, and a cycle of a stokvel I'm not in | `/stokvels/:id`, then `/stokvels`, also after a cold start |
| `/activity` | Activity across my stokvels, newest first. **Activity** tab | Sign-in, then Activity | Not applicable: only my stokvels' activity | Home tab (`/`) |
| `/profile` | Who is signed in, and **Sign out**. **Profile** tab | Sign-in, then Profile | Not applicable | Home tab (`/`) |
| `/join/:code` | An invite's preview, then **Join**. **Home** tab | Sign-in, then **this invite's preview** (remembered across sign-in) | Not applicable: an invite is how a non-member joins. An unknown code shows "We couldn't find that invite." | Home (`/`), also after a cold start |
| `/sign-in` | Fake sign-in by email. No tabs | Shown | Not applicable | Leaves the app. Signing out empties the history, so back can't reach a signed-in screen |

- **Signed in, opening `/sign-in`:** goes to the remembered address if there is one, otherwise Home.
- **Any other address** (one this table doesn't list): Home when signed in; sign-in, then Home, when signed out. It is never remembered.
- **Tapping the tab you're on** takes that tab back to its first screen (`/stokvels` from a cycle, say). On the first screen it does nothing. A tab tap is "take me to the top of this section", as Android's own apps do; doing nothing would leave a deep stack hard to escape.
- **Leaving a tab and coming back** returns to the same screen, scrolled where you left it.
- **Home's cards** open `/stokvels/:id` on the Stokvels tab, so a stokvel has one address and back from it is the list. **Activity's items** open `/stokvels/:id/cycles/:cycleId`.
- **Switching stokvel** (the picker on a phone, the list on a tablet) changes the address to `/stokvels/:otherId`.

### The gate

> **In plain words.** The *gate* is the bouncer at the door of every screen. Before any screen opens, it looks at two things, *who is signed in* and *which address was asked for*, and either lets the navigation through or sends it somewhere else (a *redirect*).
>
> **Why one plain function.** Because `redirectFor` takes plain values and returns a plain answer, it can be tested in milliseconds without drawing a single widget, and there is exactly one place to read to know the rules. The router asks it on every navigation.
>
> **Why `ref.listen` and not `ref.watch`.** `watch` would rebuild the router whenever someone signs in or out, and a rebuilt router forgets every tab's history. `listen` only *notifies* the existing router ("auth changed, check again") through `refreshListenable`.
>
> **Why the remembered address is so strict.** Remembering "where you were going" across sign-in is convenient, but if any address were accepted, a crafted link could make the app send someone elsewhere after they sign in (an *open redirect*). So only the app's own addresses are ever remembered.

One function decides every navigation: [`redirectFor(auth, location)`](lib/app/router/redirect.dart), pure Dart, with no widget or `BuildContext`. The router calls it on every navigation. It also runs again whenever the auth state changes, without anyone tapping: [`routerProvider`](lib/app/router/router.dart) copies each [`AuthController`](lib/features/auth/presentation/auth_controller.dart) change into a `ValueNotifier` (via `ref.listen`, not `ref.watch`), and that notifier is the router's `refreshListenable`. The router itself is built once, so signing in never throws away the tabs' stacks.

The rules, in order:

| Who | Address | Goes to |
|---|---|---|
| Signed out | `/sign-in` | Stays. A `from` that isn't one of the app's own addresses is dropped |
| Signed out | any address in the Routes table | `/sign-in?from=<that address>`, except Home, which needs no remembering |
| Signed out | anything else | `/sign-in`, remembering nothing |
| Signed in | `/sign-in` | The remembered address, or Home |
| Signed in | an address the Routes table doesn't have | Home |
| Signed in | anything else | Stays |

**What is remembered across sign-in:** only a path that matches a row of the Routes table (`/join/MABENA26`, `/stokvels/<id>/cycles/<id>`, …): no scheme, no host, no query. `https://evil.example/…`, `//evil.example`, `ronditrack-dev://…`, `javascript:…`, `/admin` and `/sign-in` itself all land on Home. So `/join/:code` opened signed out survives sign-in and lands on the invite's preview, and a remembered address can never point outside the app. [`redirect_test.dart`](test/app/router/redirect_test.dart) tests every rule, plus a no-loop check: every redirect lands where the gate then lets it stay.

**Signing out** (Profile → Sign out) sets the state to signed out. The gate sends the current address to sign-in, and because sign-in is outside the tab shell, the shell and every tab's stack are disposed: back from sign-in leaves the app. Signing out from Profile remembers `/profile`, so the next person to sign in lands on *their* profile, never someone else's data.

**Week 11** replaces [`FakeAuthRepository`](lib/features/auth/data/fake_auth_repository.dart) with `POST /auth/login` behind the same [`AuthRepository`](lib/features/auth/domain/auth_repository.dart). The gate only reads `SignedIn` or `SignedOut`, so it doesn't change.

### Deep links

> **In plain words.** A *deep link* is a link that opens a particular screen inside an app rather than the app's first screen. A *custom scheme* is the part before `://`: just as `https://` belongs to browsers, `ronditrack-dev://` belongs to this app's dev build. Android reads the scheme, finds the app that declared it, and hands it the rest of the link.
>
> **Why one scheme per flavour.** The dev, staging and prod builds are three separate apps that can sit on one phone. If they shared a scheme, Android would ask which one to use, and a tester could land in the wrong build. Separate schemes make each link reach exactly one build.
>
> **Cold start vs running app.** A *cold start* means the app wasn't running at all, so the link has to build the whole screen history from scratch; a link reaching a *running* app only has to navigate. Both are tested below. `adb` is Android's command-line tool for talking to a phone or emulator from a computer.

**Scheme: a custom scheme, one per flavour**, set in [`build.gradle.kts`](android/app/build.gradle.kts) as the `deepLinkScheme` manifest placeholder and used by the VIEW intent filter in [`AndroidManifest.xml`](android/app/src/main/AndroidManifest.xml). The host is always `app`; go_router reads the path. A dev link can only open the dev build, because no other build declares `ronditrack-dev`.

| Flavour | Application id | Link |
|---|---|---|
| dev | `za.co.gwinya.ronditrack_app.dev` | `ronditrack-dev://app/<address>` |
| staging | `za.co.gwinya.ronditrack_app.staging` | `ronditrack-staging://app/<address>` |
| prod | `za.co.gwinya.ronditrack_app` | `ronditrack://app/<address>` |

Every command starts with `force-stop`, so it tests a **cold start**. Leave out the first line to test a link reaching a running app.

```powershell
# dev
adb shell am force-stop za.co.gwinya.ronditrack_app.dev
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack-dev://app/stokvels/5d0c9a4e-2b1f-4c8a-8e7d-3a6b9f2e0101" za.co.gwinya.ronditrack_app.dev
adb shell am force-stop za.co.gwinya.ronditrack_app.dev
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack-dev://app/stokvels/5d0c9a4e-2b1f-4c8a-8e7d-3a6b9f2e0101/cycles/9e8f7a6b-5c4d-4e3f-8a2b-1c0d9e8f0201" za.co.gwinya.ronditrack_app.dev
adb shell am force-stop za.co.gwinya.ronditrack_app.dev
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack-dev://app/join/MABENA26" za.co.gwinya.ronditrack_app.dev

# staging
adb shell am force-stop za.co.gwinya.ronditrack_app.staging
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack-staging://app/stokvels/5d0c9a4e-2b1f-4c8a-8e7d-3a6b9f2e0101" za.co.gwinya.ronditrack_app.staging
adb shell am force-stop za.co.gwinya.ronditrack_app.staging
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack-staging://app/stokvels/5d0c9a4e-2b1f-4c8a-8e7d-3a6b9f2e0101/cycles/9e8f7a6b-5c4d-4e3f-8a2b-1c0d9e8f0201" za.co.gwinya.ronditrack_app.staging
adb shell am force-stop za.co.gwinya.ronditrack_app.staging
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack-staging://app/join/MABENA26" za.co.gwinya.ronditrack_app.staging

# prod
adb shell am force-stop za.co.gwinya.ronditrack_app
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack://app/stokvels/5d0c9a4e-2b1f-4c8a-8e7d-3a6b9f2e0101" za.co.gwinya.ronditrack_app
adb shell am force-stop za.co.gwinya.ronditrack_app
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack://app/stokvels/5d0c9a4e-2b1f-4c8a-8e7d-3a6b9f2e0101/cycles/9e8f7a6b-5c4d-4e3f-8a2b-1c0d9e8f0201" za.co.gwinya.ronditrack_app
adb shell am force-stop za.co.gwinya.ronditrack_app
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack://app/join/MABENA26" za.co.gwinya.ronditrack_app
```

The ids are Mabena Family and its current cycle. Soweto Teachers is `5d0c9a4e-2b1f-4c8a-8e7d-3a6b9f2e0102` (cycle `9e8f7a6b-5c4d-4e3f-8a2b-1c0d9e8f0202`), and the other invite code is `SOWETO26`. The app starts signed out after a cold start, so each link goes through sign-in first, then lands on the linked screen.

**Checked on the emulator (2026-11-12), all three flavours installed side by side:**

- `pm query-activities -a android.intent.action.VIEW -d <scheme>://app/join/MABENA26` resolves `ronditrack-dev` only to `…ronditrack_app.dev`, `ronditrack-staging` only to `…ronditrack_app.staging`, and `ronditrack` only to `za.co.gwinya.ronditrack_app`.
- Cold start (`LaunchState: COLD`) in each flavour. Dev: a cycle link went through sign-in to the cycle, and back went to the stokvel, the list, then Home, with the app still open (recording 06 below). Dev: `/join/MABENA26` went through sign-in to the invite, then Join (recording 07). Staging and prod: `/join/MABENA26` opened sign-in, and in prod, signing in landed on the invite.

**What an App Link would add.** A verified Android App Link (`https://ronditrack.example/stokvels/…`) needs a domain I control serving `/.well-known/assetlinks.json`, listing each flavour's application id and its signing certificate's SHA-256 fingerprint, plus `android:autoVerify="true"` on an `https` intent filter. Android then opens those links straight in the app, with no chooser. No other app can claim them, as any app could declare `ronditrack://`. And on a phone without the app, the same link opens the website. The free-tools rule gives me no domain, so I haven't added one.

**What the adb test proves, and what it doesn't.** `adb shell am start -d …` proves that the intent filter matches, that each flavour receives only its own scheme, and that the app routes the link, from cold (`LaunchState: COLD`) and while running. It doesn't prove that a link tapped in a messaging app or browser reaches the app: those apps decide what is tappable, and many don't linkify custom schemes. It also proves nothing about App Link verification, which needs the hosted file.

---

## Part 2: Getting started

*What you need, how to run each build, and the exact package versions.*

### Running it

> **In plain words.** `flutter pub get` downloads the packages listed in `pubspec.yaml` at the exact versions in `pubspec.lock`. `build_runner` generates the boilerplate code (the `*.g.dart` and `*.freezed.dart` files) from annotations such as `@riverpod` and `@freezed`. Those files are already committed, so you only regenerate after changing an annotated file. `--flavor` picks which of the three builds to make, and `--dart-define-from-file` passes that build its settings.

| | |
|---|---|
| Flutter | **3.47.7** (Dart 3.13.5), on PATH and in Android Studio |
| API the dev flavour expects | [RondiTrack](https://github.com/mdvar2/RondiTrack), `dotnet run --project API --launch-profile http`, which listens on `http://localhost:5101` (setup: its README, "Getting Started") |

```powershell
flutter pub get
dart run build_runner build      # only after changing a @freezed or @riverpod file

flutter run --flavor dev     --dart-define-from-file=config/dev.json
flutter run --flavor staging --dart-define-from-file=config/staging.json
flutter run --flavor prod    --dart-define-from-file=config/prod.json

# Dev only: make the fakes fail. 1 = every call (the failure state stays on screen);
# 3 = the first call and every third after it (Riverpod's automatic retry recovers).
flutter run --flavor dev --dart-define-from-file=config/dev.json --dart-define=FAKE_FAIL_EVERY=1
```

The app opens on a fake sign-in. Sign in with a seed persona's email, or tap one under "Test accounts":

| Persona | Email | Stokvels |
|---|---|---|
| Lerato Mokoena | `lerato@ronditrack.example` | Treasurer of Mabena Family, Member of Soweto Teachers |
| Sipho Dlamini | `sipho@ronditrack.example` | Member of Mabena Family (in arrears), Chairperson of Soweto Teachers |
| Thabo Nkosi | `thabo@ronditrack.example` | None: Home's empty state, and the one who joins by invite |

10.1's `--dart-define=FAKE_PERSONA` is gone. A way to start signed in without the gate would be a bypass in every flavour, prod included.

#### Flavours and config files

> **In plain words.** A *flavour* is one variant of the same app: dev talks to a developer's laptop, staging to a test server, prod to the real one. Each has its own application id, so all three can be installed side by side, and its own config file. The app checks its config at start-up and refuses to run with a wrong or missing one, so a prod build can never quietly talk to a dev server.

| Flavour | Android application id | Launcher name | Config file | `API_BASE_URL` |
|---|---|---|---|---|
| dev | `za.co.gwinya.ronditrack_app.dev` | RondiTrack Dev | [`config/dev.json`](config/dev.json) | `http://10.0.2.2:5101`: the emulator's address for the host's `localhost:5101` |
| staging | `za.co.gwinya.ronditrack_app.staging` | RondiTrack Staging | [`config/staging.json`](config/staging.json) | `https://staging.api.ronditrack.example`, a placeholder: no staging API is deployed |
| prod | `za.co.gwinya.ronditrack_app` | RondiTrack | [`config/prod.json`](config/prod.json) | `https://api.ronditrack.example`, a placeholder: no production API is deployed (API repo: "plan only; nothing provisioned") |

Each file holds exactly `APP_ENV`, `APP_NAME` and `API_BASE_URL`. **Nothing secret.** The app refuses to start (`AppConfigException`) when:

- there is no config (`APP_ENV`, `APP_NAME` or `API_BASE_URL` is missing);
- the native flavour (`appFlavor`, from `--flavor`) doesn't match `APP_ENV`, such as a prod build given `config/dev.json`;
- the name doesn't match the flavour, the address isn't absolute http(s), or staging/prod isn't https.

[`app_config_test.dart`](test/core/config/app_config_test.dart) proves each refusal.

The project uses **AGP 9.1.0**, where `resValue` is off by default. So each flavour sets its launcher name with `manifestPlaceholders["appName"]`, and `AndroidManifest.xml` uses `${appName}`.

**Not yet done:** iOS flavours need Xcode schemes, which this Windows machine can't create; iOS currently has one scheme. Android cleartext `http` to `10.0.2.2` will need a dev-only network security config in Week 11, when the app first calls the API.

#### Dependencies

> **Why exact versions, at least two weeks old.** An exact version (`3.4.3`, not `^3.4.3`) means every clone, and CI, installs the very same code. The two-week rule, set by the course, avoids brand-new releases, which are the ones most likely to be broken, retracted or (rarely) malicious. The lockfile pins the *transitive* packages too: the packages that your packages depend on.

Every version is exact (no `^`) and was at least two weeks old when checked, transitive ones included: on 2026‑11‑11 for 10.1 (cutoff 2026‑10‑28), and on 2026‑11‑12 for the packages 10.2 added (cutoff 2026‑10‑29). Dates are from `https://pub.dev/api/packages/<name>`. `pubspec.lock` is committed, and CI installs with `flutter pub get --enforce-lockfile`.

| Package | Version | Published | Note |
|---|---|---|---|
| flutter_riverpod / riverpod_annotation | 3.4.3 / 4.0.7 | 2026‑09‑03 | 3.5.0 / 4.0.8 (2026‑11‑06) were too new |
| riverpod_generator / riverpod_lint | 4.0.9 / 3.1.9 | 2026‑09‑03 | 4.0.10 / 3.2.0 (2026‑11‑06) were too new |
| freezed / freezed_annotation | 4.0.3 / 3.1.0 | 2026‑10‑17 / 2025‑07‑02 | |
| build_runner | 2.16.2 | 2026‑10‑07 | 2.17.0 is retracted |
| very_good_analysis | 11.0.0 | 2026‑09‑03 | |
| analyzer | 14.6.0 | 2026‑10‑20 | Pinned as a dev dependency only to hold the analyser stack back: 14.7.0 (and `_fe_analyzer_shared` 111, `analyzer_plugin` 0.14.20, `analysis_server_plugin` 0.3.26) were published 2026‑10‑29 |
| cupertino_icons | 1.0.9 | 2026‑03‑25 | |
| go_router | 18.1.1 | 2026‑10‑20 | Added in 10.2. 18.1.4 (2026‑11‑09) is too new |
| go_router_builder | 4.5.2 | 2026‑10‑19 | Added in 10.2, a dev dependency. 4.5.3 (2026‑10‑30) is too new. Accepts the held-back analyzer 14.6.0 (`>=8.2.0 <15.0.0`) |
| material_ui / cupertino_ui | 1.8.0 / 1.1.4 | 2026‑10‑20 | Added in 10.2, not imported: go_router 18.1.1 depends on `^1.0.0` of each, and the newest (1.11.0 of 2026‑11‑09, 1.1.6 of 2026‑11‑03) are too new, so both are pinned |
| source_helper, intl (transitive) | 1.4.0, 0.20.3 | 2026‑10‑19, 2026‑06‑25 | Brought in by go_router_builder and material_ui |

`flutter_lints` was removed, because very_good_analysis replaces it.

---

## Part 3: How the code is organised

*The folder structure and the rules that keep it tidy, the generated code, and the lints.*

### Architecture

> **In plain words.** The code is split by *feature* (auth, home, stokvels, activity, invites), and each feature in three layers:
>
> - **domain**: plain Dart describing the business: the data shapes and the *interface* of each repository ("something that can fetch a stokvel"), with no Flutter and no networking;
> - **data**: an *implementation* of that interface; today a fake with seed data, from Week 11 the real API;
> - **presentation**: the screens and the providers that feed them.
>
> **Why.** Screens only know the interfaces, and exactly one file, [`providers.dart`](lib/app/providers.dart) (the *composition root*), decides which implementation is used. So Week 11 can swap every fake for the real API by editing that one file, without touching a screen.

```
lib/
  app/          composition root: app.dart (MaterialApp.router), providers.dart (names every implementation)
    router/     routes.dart (typed routes), redirect.dart (the gate), router.dart, app_shell.dart (bar or rail)
  core/         config/, money/, time/, state/ (sealed ViewState), logging/,
                theme/ (seed, StatusColors, StatusChip), layout/ (WindowSize), widgets/
  features/
    auth/       domain/ (AuthState, AuthRepository)  data/ (FakeAuthRepository)  presentation/ (sign-in, profile)
    home/       domain/ (HomeEntry, HomeRepository)  data/ (FakeHomeRepository)  presentation/
    stokvels/   domain/ (enums, Membership, StokvelDetail, CycleDetail, actions, StokvelRepository)
                data/ (fake_seed, FakeStokvelRepository)  presentation/ (list, detail, cycle)
    activity/   domain/  data/  presentation/
    invites/    domain/  data/  presentation/ (the /join/:code preview)
contract/openapi/v1.json   the API contract copy
```

- Repository **interfaces** live in each feature's `domain/`. **Fakes** live in `data/`. **One provider per repository** in [`lib/app/providers.dart`](lib/app/providers.dart) names the implementation; that file is the only one Week 11 changes.
- No widget imports a fake, a `data/` folder, Dio or Drift. [`architecture_test.dart`](test/architecture_test.dart) enforces it, and checks that only `providers.dart` names a fake.
- Widgets navigate only with the typed routes in [`routes.dart`](lib/app/router/routes.dart) (`StokvelRoute(id: id).go(context)`). The architecture test fails on a `Navigator.push`, a `MaterialPageRoute`, or a string path in a widget.
- Every screen renders the sealed [`ViewState`](lib/core/state/view_state.dart) (`ViewLoading`, `ViewEmpty`, `ViewData`, `ViewFailure`) with an exhaustive `switch`.

### Generated code

> **In plain words.** Some files are written by a program (*code generation*) rather than by hand, from short annotations. They could be left out of Git and generated on each machine; committing them is a trade-off, explained here.

**Committed.** `*.g.dart` and `*.freezed.dart` are in Git. Reasons:

- A fresh clone analyses and runs without first waiting about 100 seconds for build_runner's first compile.
- A reviewer sees in the pull request what the generators produced.
- CI still regenerates every file and fails on any difference (`git diff --exit-code`), so a committed file can't go stale silently.

The CI order works with this choice: format check (hand-written files only) → `build_runner build` → generated-code diff → `dart analyze --fatal-infos` → `flutter test`.

### Lints, and why `flutter analyze` isn't enough

> **In plain words.** A *lint* is an automatic code-review rule, such as "a Riverpod notifier must not have public fields". `riverpod_lint` is a *plugin* to Dart's analyser, and this section shows, with a real failing CI run, that only `dart analyze` runs plugins; `flutter analyze` silently skips them.

[`analysis_options.yaml`](analysis_options.yaml) includes `very_good_analysis` 11 and enables `riverpod_lint` 3.1.9 as an **analyser plugin** (`plugins:`). No lint is switched off.

`flutter analyze` doesn't run analyser plugins. Only `dart analyze` does. Verified locally by adding a public field to `HomeController` (`int refreshCount = 0;`):

```
$ dart analyze --fatal-infos
   info - lib\features\home\presentation\home_controller.dart:13:3 - Notifiers should not have public
          properties/getters. Instead, all their public API should be exposed through the `state`
          property. - avoid_public_notifier_properties
1 issue found.            (exit code 1)

$ flutter analyze
No issues found! (ran in 41.6s)
```

A CI step running `flutter analyze` would have passed that mistake. This CI runs `dart analyze --fatal-infos`.

**Proved in CI** on pull request [#2](https://github.com/mdvar2/RondiTrackApp/pull/2) (branch `ci/riverpod-lint-red`, never to be merged):

| Run | Commit | Result |
|---|---|---|
| [42964435528](https://github.com/mdvar2/RondiTrackApp/actions/runs/42964435528) | `baf27d0`: adds `int refreshCount = 0;` | ❌ at **Generated code is up to date**. Not the lint: riverpod_generator hashes each provider's source into its `.g.dart`, and the commit hadn't regenerated. Doesn't count as the red run |
| [42966299705](https://github.com/mdvar2/RondiTrackApp/actions/runs/42966299705) | `2adb2b0`: regenerates the hash | ❌ at **Analyse** (generated code now up to date) |
| [**42966980275**](https://github.com/mdvar2/RondiTrackApp/actions/runs/42966980275) | `be0ebd1`: same fault, with CI writing findings as annotations | ❌ **the red run**: format ✅, code generation ✅, generated code up to date ✅, **Analyse ❌**, Test skipped |
| [**42967452524**](https://github.com/mdvar2/RondiTrackApp/actions/runs/42967452524) | `a0e0ddd`: reverts the field | ✅ **the green run**: every step passes, Analyse and Test included |

The red run's annotation (public on the run's summary page):

```
lib/features/home/presentation/home_controller.dart line 13 · avoid_public_notifier_properties
Notifiers should not have public properties/getters. Instead, all their public API should be
exposed through the `state` property.
```

The Analyse step writes each finding as a GitHub annotation, so it shows on the pull request's diff without opening the log.

---

## Part 4: State and provider lifetimes

*Where the data on each screen lives, and how long it is kept.*

### State with Riverpod

> **In plain words.** *State* is the data a screen shows that can change: loading, loaded, failed. Riverpod keeps that data in *providers*, objects that screens subscribe to. A *notifier* is a provider with methods (like `refresh()`); a *family* is a provider with a parameter, so each stokvel id gets its own separate state.

- **Home** is an `AsyncNotifier` ([`HomeController`](lib/features/home/presentation/home_controller.dart)). Pull to refresh calls `refresh()`, which invalidates the notifier. Riverpod keeps the old value while it reloads, so the old cards stay on screen under a thin progress bar.
- **Stokvel detail** is a `family` provider keyed by stokvel id ([`stokvelDetailProvider`](lib/features/stokvels/presentation/stokvel_detail_provider.dart)). Its actions come from *this* stokvel's membership, so treasurer actions appear only where the persona is Treasurer or Chairperson.
- **Not yours = not found.** The fake throws the same `StokvelNotFoundException` for a stokvel you aren't in as for one that doesn't exist, matching the API's `404`. The screen says "We couldn't find that stokvel." in both cases.
- **Never the wrong stokvel, not for a frame.** Each id is its own family member, so switching ids starts from a fresh loading state, never the previous stokvel's value. As a second guard, `stokvelDetailViewState` treats a value whose id isn't the requested one as loading. [`stokvel_switch_test.dart`](test/features/stokvels/presentation/stokvel_switch_test.dart) loads Mabena Family, switches to a 5‑second‑slow Soweto Teachers, pumps **one** frame, and expects Soweto Teachers' loading state and none of Mabena Family's contributions.

### Provider lifetimes

> **In plain words.** Every provider either lives for the whole session (**keepAlive**) or is thrown away as soon as no screen is using it (**autoDispose**). Keeping data costs memory and can keep other people's details on a shared phone; throwing it away costs a reload. The table gives the reason for each choice.

| Provider | Holds | Lifetime | Cost of keeping it on an entry-level phone | Cost of disposing it |
|---|---|---|---|---|
| `authControllerProvider` | Who is signed in (`SignedOut` or `SignedIn`) | **keepAlive** | One small object | It *is* the session: disposing it would sign the person out |
| `signedInUserIdProvider` | The signed-in person's id, `null` when signed out (follows `authControllerProvider`) | **keepAlive** | One string | Everything that depends on it rebuilds. It must live for the whole session |
| `routerProvider` | The `GoRouter`, which owns every tab's stack | **keepAlive**, built once | One router | Every tab would lose its place. It *listens* to the auth state rather than watching it, so it is never rebuilt |
| `authRepositoryProvider`, `homeRepositoryProvider`, `stokvelRepositoryProvider`, `activityRepositoryProvider`, `inviteRepositoryProvider` | The repository objects (Week 11: an API client and its connection pool) | **keepAlive** | Small, and no personal data of its own | Rebuilding the client and its connections on every screen |
| `fakeStokvelsProvider`, `fakeDelayProvider`, `demoAccountsProvider` | The fakes' changeable seed copy (a join lands here), their delay, the sign-in page's test accounts. Week 11 deletes them | **keepAlive** | Kilobytes | A join would be forgotten: the fake "server" must outlive screens |
| `lifecycleLogProvider` | A logging function | **keepAlive** | Nothing | Nothing gained |
| `fakeFailEveryProvider` | One number from `FAKE_FAIL_EVERY` (dev only; Week 11 deletes it) | **keepAlive** | One int | The repositories watch it; rebuilding them would reset the flaky fakes' call count |
| `homeControllerProvider` | My stokvels, roles and amounts | **autoDispose** | Home is the root screen, so it is watched for the whole session anyway | Only when Home leaves the stack (sign-out), which is exactly when it should go |
| `stokvelDetailProvider(id)` | One stokvel's cycle and **other members'** names and contributions | **autoDispose** | Memory per stokvel opened; other people's data kept after you leave; it goes stale (a contribution recorded meanwhile wouldn't show) | A refetch and a spinner when the stokvel is reopened, which on a data bundle is a small, honest cost |
| `cycleDetailProvider(id, cycleId)` | One cycle and its contributions | **autoDispose** | As stokvel detail | As stokvel detail |
| `activityControllerProvider` | My activity feed | **autoDispose** | Watched while the Activity tab is in the shell's stack | Dropped at sign-out with the shell |
| `invitePreviewProvider(code)`, `inviteJoinerProvider(code)` | One invite's preview, and the join in progress | **autoDispose** | Tiny | Nothing worth keeping once the invite screen closes |

**Tabs and autoDispose.** The shell keeps each tab's navigator alive (an indexed stack), so a screen on a tab you've left is still mounted and still watching its provider. That is what keeps a cycle open, and scrolled where it was, when you come back. The data is disposed when the screen is popped, or when sign-out disposes the shell.

**Disposal is proven** in [`stokvel_detail_provider_test.dart`](test/features/stokvels/presentation/stokvel_detail_provider_test.dart). When the last listener closes, `container.exists(stokvelDetailProvider(id))` becomes false, and the log is exactly:

```
stokvelDetail created id=5d0c9a4e-2b1f-4c8a-8e7d-3a6b9f2e0101
stokvelDetail disposed id=5d0c9a4e-2b1f-4c8a-8e7d-3a6b9f2e0101
```

The log carries the id only, never a name or an amount (the test checks this). Reopening the stokvel refetches. The same `[lifecycle]` lines appear in the Run console in debug builds.

**Signing out, on a phone a family shares** (built in 10.2). Sign-out sets `authControllerProvider` to `SignedOut`, so `signedInUserIdProvider` becomes `null`, and every repository, which watches it, is rebuilt for nobody. The gate moves to `/sign-in`, which is outside the tab shell, so the shell and every screen in it are disposed, and with them every autoDispose provider holding the last person's data. [`router_test.dart`](test/app/router/router_test.dart) signs Lerato out and Thabo in, and checks that Home shows Thabo's empty state with none of Lerato's cards. 10.1 planned a backstop of re-keying the root `ProviderScope` at sign-out; it isn't built, because the test above shows nothing survives without it.

---

## Part 5: Look and layout

*Assignment 10.2. The design system, and how the app adapts from a 360 dp phone to a tablet.*

### Theme

> **In plain words.** A *theme* is the app's whole colour and type style in one place. Material 3 can derive a complete, harmonious palette from one *seed* colour, for both light and dark mode, so the app picks one colour and lets Material do the rest.
>
> **Why a theme extension.** Material has colours for "primary" or "error" but not for "paid out" or "arrears". A `ThemeExtension` adds those, with a light and a dark value each. Widgets ask the theme for the *meaning* ("arrears"); the theme decides the colour. That is why dark mode works everywhere: no screen has its own hard-coded colour that the dark theme can't reach.
>
> **Why words as well as colour.** About one man in twelve has some colour blindness, and screen readers don't read colours, so every status chip says what it means in words.
>
> **What a contrast ratio is.** It measures how far apart two colours are in brightness, from 1:1 (identical) to 21:1 (black on white). The WCAG accessibility guideline asks for at least 4.5:1 for normal text and 3:1 for large text and the outlines of controls.

**Seed: `#0B6E4F`**, a deep savings green ([`app_theme.dart`](lib/core/theme/app_theme.dart)). Material 3 derives both themes from it with `ColorScheme.fromSeed`, so the dark theme is Material's dark tonal palette, not the light one inverted. The app follows the phone's light or dark setting (`ThemeMode.system`, the default).

**Tokens Material doesn't have** live in [`StatusColors`](lib/core/theme/status_colors.dart), a `ThemeExtension` with a light and a dark tone per token. Widgets ask for a token ("arrears"), never for a colour. [`StatusChip`](lib/core/theme/status_chip.dart) always shows the status in **words**; the colour only helps. [`architecture_test.dart`](test/architecture_test.dart) fails if a `Color(0x…)`, `Colors.…` or `Color.fromARGB/RGBO` appears in any presentation folder or in `lib/app/`.

**Measured, not eyeballed.** Contrast is the WCAG 2.2 ratio, computed by [`contrast_test.dart`](test/core/theme/contrast_test.dart) with Flutter's `Color.computeLuminance` (WCAG relative luminance). The test fails CI if a pair drops below its threshold, and prints this table (`flutter test test/core/theme/contrast_test.dart --plain-name "token table"`). I cross-checked six pairs with an independent Python implementation of the WCAG formula, and they matched to two decimals. Status chips are text on a fill, so they need 4.5:1. The control outline needs 3:1.

| Token | Needs | Light: text / fill | Light ratio | Dark: text / fill | Dark ratio |
|---|---|---|---|---|---|
| `cycleOpen` | 4.5:1 | `#001C38` / `#D3E4FF` | 13.33:1 | `#D3E4FF` / `#1F4876` | 7.26:1 |
| `cycleClosed` | 4.5:1 | `#2E3130` / `#E1E3E1` | 10.18:1 | `#E1E3E1` / `#444746` | 7.28:1 |
| `cyclePaidOut` | 4.5:1 | `#21005D` / `#EADDFF` | 13.32:1 | `#EADDFF` / `#4F378B` | 7.23:1 |
| `contributionPending` | 4.5:1 | `#271900` / `#FFDEA8` | 13.27:1 | `#FFDEA8` / `#5B4300` | 7.24:1 |
| `contributionPaid` | 4.5:1 | `#001E2C` / `#C2E8FF` | 13.32:1 | `#C2E8FF` / `#004C69` | 7.28:1 |
| `contributionConfirmed` | 4.5:1 | `#00210D` / `#B4F1C0` | 13.31:1 | `#B4F1C0` / `#155234` | 7.12:1 |
| `arrears` | 4.5:1 | `#410002` / `#FFDAD6` | 13.26:1 | `#FFDAD6` / `#93000A` | 7.24:1 |
| `unknown` | 4.5:1 | `#1D1A22` / `#E7E0EB` | 13.29:1 | `#E7E0EB` / `#4A4550` | 7.20:1 |
| `text (onSurface on surface)` | 4.5:1 | `#171D1A` / `#F5FBF5` | 16.30:1 | `#DEE4DE` / `#0F1512` | 14.31:1 |
| `secondary text (onSurfaceVariant on card)` | 4.5:1 | `#404944` / `#EFF5EF` | 8.42:1 | `#BFC9C2` / `#171D1A` | 10.06:1 |
| `link text (primary on card)` | 4.5:1 | `#1E6A4F` / `#EFF5EF` | 5.88:1 | `#8CD5B3` / `#171D1A` | 10.01:1 |
| `selected list row (onSecondaryContainer)` | 4.5:1 | `#354B40` / `#CFE9D9` | 7.31:1 | `#CFE9D9` / `#354B40` | 7.31:1 |
| `control outline (outline on surface)` | 3.0:1 | `#707973` / `#F5FBF5` | 4.28:1 | `#8A938D` / `#0F1512` | 5.84:1 |

### Layouts

> **In plain words.** A *dp* (density-independent pixel) is Flutter's unit of size: about the same physical size on every screen, whatever its pixel density. A typical phone held upright is 360 to 410 dp wide; a tablet on its side is well over 840 dp.
>
> **Why ask the window, not the device.** The same tablet can show the app full-screen, in split screen, or turned upright, and a phone on its side is wider than many tablets upright. Asking "how much room does this window have?" gives the right layout in every one of those cases; asking "is this a tablet?" gets several of them wrong.
>
> **Why 200% text matters.** Many people set a large font size on their phone. At 360 dp with text doubled, a row that fits normally can run off the screen, which Flutter shows as yellow-and-black *overflow stripes* in debug builds. The layouts here wrap instead, and tests fail if anything overflows.

Breakpoints come from the **window's** width, never the device. They are written once, in [`core/layout/window_size.dart`](lib/core/layout/window_size.dart), and nothing asks "is this a tablet?".

| Window width | Class | Navigation | Stokvels tab |
|---|---|---|---|
| under 600 dp | compact | Bottom bar, four labelled tabs | One pane: the list at `/stokvels`, the stokvel at `/stokvels/:id` |
| 600 to 839 dp | medium | Side rail, four labelled tabs (it scrolls if the window is short, as a phone on its side with large text is) | One pane, as compact |
| 840 dp or wider | expanded | Side rail | **List and detail side by side**, on the same address `/stokvels/:id`; at `/stokvels` the detail pane says "Choose a stokvel" |

The selected stokvel is the one in the address. So turning a tablet upright (expanded to medium) keeps it, and back from it returns to the list. At 360 dp with text at 200%, figures and labels wrap instead of overflowing: the role chip drops under the stokvel's name, an amount and its status chip stack, and every action stays reachable by scrolling. [`layout_test.dart`](test/app/layout_test.dart) fails on any overflow.

---

## Part 6: Domain rules

*Assignment 10.1. Money, who may do what in a stokvel, and what happens when the API sends something new.*

### Money

> **Why whole cents.** Computers store decimal fractions like 0.1 only approximately, so with `double`s, 0.1 + 0.2 is not exactly 0.3, and money adds up wrong by fractions of a cent. Storing every amount as a whole number of cents (`int`) makes all money arithmetic exact. The formatting and parsing rules below follow the South African style: `R 1 500,00`, with a comma for decimals.

Amounts are whole cents end to end: [`Cents`](lib/core/money/cents.dart) is an extension type over `int`. The API's cents fields map straight in, and its `double` fields are never read. There is no `double` in any money code.

**Formatter** ([`rand_format.dart`](lib/core/money/rand_format.dart)). It uses integer arithmetic only (`~/`, `%`). Examples: `R 0,10`, `R 150,50`, `R 1 500,00`, `R 1 000 000,00`, and a negative `-R 150,50`. Every space is a no-break space (U+00A0). The API sends no negative amounts today (`amountOwed` is clamped at 0), but the formatter handles them.

**Parser** ([`rand_parser.dart`](lib/core/money/rand_parser.dart)) for typed rands. It returns `RandParsed(cents)` or `RandRefused(reason)`, with integer arithmetic only. The rules:

1. Surrounding spaces are ignored. An optional leading `R`, with or without a space after it, is allowed.
2. Rands are digits, optionally grouped in threes by **single** spaces, either ordinary or no-break (`1 500`, `1 000 000`). A space anywhere else is refused (`1 50`).
3. After the rands there may be **one** decimal separator and **one or two** digits (`150,5` is R 150,50).
4. **Full-stop decision: a full stop is accepted as the decimal separator.** Many Android numeric keyboards show only `.`, and a person whose keyboard has no comma must still be able to pay R 150,50. This is safe because three digits after any separator are always refused. So `1.500` (a European thousands mark) and `1,500.50` (an English thousands mark plus a decimal) are refused rather than misread as R 1,50 or R 1 500,50.
5. Refused: empty input or a bare `R`; a separator with no digits (`150.`, `150,`); three or more decimals (`150,505`); two separators; letters, signs and currency codes; more than 10 rand digits.

R 0 parses; whether zero is a valid payment is the pay form's rule (11.4), not the parser's. Tests: [`rand_format_test.dart`](test/core/money/rand_format_test.dart) and [`rand_parser_test.dart`](test/core/money/rand_parser_test.dart). Every no-break space in the tests is written as ` `.

### What can I do here?

> **In plain words.** A person's role belongs to each stokvel, not to the person: Lerato is Treasurer in one stokvel and an ordinary Member in another. So "which buttons do I see?" is decided per stokvel, from that stokvel's membership, the cycle's status and my own contribution.
>
> **What "exhaustive switch with no wildcard" means.** Dart can check that a `switch` handles every possible value. Without a catch-all (`_`), adding a new role or status makes this code fail to compile until someone decides what it allows; nothing new is ever allowed by accident.

[`allowedActions`](lib/features/stokvels/domain/stokvel_actions.dart) takes the record `(role, cycle, mine)` and returns a `Set<StokvelAction>`. It is **one exhaustive switch with no wildcard and no catch-all variable**, so every role and status is listed in every row. The rules follow the API at `3d04a52`:

| Cycle | Role | My contribution | Allowed |
|---|---|---|---|
| `Closed`, `PaidOut`, unknown | any | any | nothing (the API refuses contributions, proof, close and payout unless `Open`) |
| `Open` | unknown | any | nothing |
| `Open` | Member | none yet | Pay |
| `Open` | Member | `Pending`, `Paid` | Pay, Upload proof (the API adds partial payments together) |
| `Open` | Member | `Confirmed`, unknown | nothing |
| `Open` | Treasurer, Chairperson | none yet | Pay, Confirm, Close, Record payout |
| `Open` | Treasurer, Chairperson | `Pending`, `Paid` | Pay, Upload proof, Confirm, Close, Record payout |
| `Open` | Treasurer, Chairperson | `Confirmed`, unknown | Confirm, Close, Record payout |

Treasurer and Chairperson are equal, because both pass the API's `StokvelManage` check. Each row has a test in [`stokvel_actions_test.dart`](test/features/stokvels/domain/stokvel_actions_test.dart), plus a sweep over every combination. Every status also has a label in words (one exhaustive switch each, in [`status_labels.dart`](lib/features/stokvels/domain/status_labels.dart)), and colour never stands alone.

### When the API adds a status

> **In plain words.** This is the safety net for the future: what happens if the server starts sending a status this version of the app has never heard of. At *build* time the exhaustive switches force a developer to handle it; at *run* time, on phones still running the old app, the unknown value is shown as "Status not recognised" and allows nothing.

Verified by adding `suspended('Suspended')` to `CycleStatus` and running `dart analyze`. The change was reverted afterwards:

```
$ dart analyze
  error - lib\features\stokvels\domain\status_labels.dart:8:48 - The type 'CycleStatus' isn't
          exhaustively matched by the switch cases since it doesn't match the pattern
          'CycleStatus.suspended'. Try adding a wildcard pattern or cases that match
          'CycleStatus.suspended'. - non_exhaustive_switch_expression
  error - lib\features\stokvels\domain\stokvel_actions.dart:53:61 - The type 'ActionContext' isn't
          exhaustively matched by the switch cases since it doesn't match the pattern
          '(cycle: CycleStatus.suspended, mine: _, role: _)'. Try adding a wildcard pattern or cases
          that match '(cycle: CycleStatus.suspended, mine: _, role: _)'. - non_exhaustive_switch_expression
2 issues found.
```

So nothing builds until someone writes the new status's words and decides what it allows.

**At run time, on a phone with an old install**, when the API starts sending `"Suspended"`:

- `CycleStatus.fromApi` returns `CycleStatus.unknown`. It never throws, so the screen still loads.
- The card reads **"Status not recognised"**.
- `allowedActions` gives **no actions** for an unknown cycle status, so nobody can pay into, close or pay out a cycle the app doesn't understand.

The same holds for an unknown contribution status or role. An unknown role grants nothing.

---

## Part 7: The API contract

*What the API promises, where it is vague, and the gaps found.*

### Contract notes

> **In plain words.** The *contract* is the API's own description of its endpoints and data (an OpenAPI document). The app was built against a fixed copy of it, so these notes record what the contract says, where it is vague, and the gaps found, with what was done about each.

Read from the API's `README.md`, `openapi/v1.json` and, where the document types a field only as `string`, the C# source. All of it is at API commit **`3d04a5238c72b0b3e1742a1067170a20ae13e97a`**.

#### 1. How the API spells statuses and roles

The OpenAPI document types all three as plain `string`. The spellings come from the domain code:

| Kind | Exact strings (case matters) | Source |
|---|---|---|
| Cycle status | `Open`, `Closed`, `PaidOut` | `Domain/Entities/ContributionCycle.cs` |
| Contribution status | `Pending`, `Paid`, `Confirmed` | `Domain/Entities/Contribution.cs` (`UpdateStatus` allows exactly these) |
| Stokvel role | `Member`, `Treasurer`, `Chairperson` | `Domain/Entities/Roles.cs` |

`Roles.cs` also has the platform roles `User` and `PlatformAdmin`. They are never a stokvel role, so the app maps them to `unknown`. Any other string, or a wrong case, also becomes `unknown`: see [`statuses.dart`](lib/features/stokvels/domain/statuses.dart).

#### 2. Which endpoints return the caller's role, and where

The role comes from the stokvel membership, checked live on every request (`StokvelAccessHandler`). `GET /api/v1/me` deliberately has no role. The controller's comment says: *"No role: roles belong to each stokvel, not to the person."*

| Endpoint | Where |
|---|---|
| `GET /api/v1/me/home` | `stokvels[].role` (`HomeStokvelResponse.role`), one per stokvel |
| `GET /api/v1/stokvels/{id}` | `role` at the top level (`StokvelDetailResponse.role`) |
| `GET /api/v1/stokvels/{stokvelId}/members` | `items[].role` for every member, the caller included |
| `GET …/cycles/{cycleId}/contributions` | `items[].memberRole`: each *contributor's* role, not the caller's |

`GET /api/v1/stokvels` (the list) has no role. The fakes return the role in the same places: on each Home entry and on the stokvel detail, both as a [`Membership`](lib/features/stokvels/domain/membership.dart).

#### 3. What `/me/home` returns per stokvel

`HomeResponse { stokvels: HomeStokvelResponse[] }`, ordered by stokvel name. An empty array means the person is in no stokvel.

| Field | Type | Can be null? | Notes |
|---|---|---|---|
| `stokvelId`, `stokvelName`, `role` | uuid, string, string | No | |
| `currentCycle` | `HomeCycleResponse` | **Yes**, when the stokvel has no cycle for the current Johannesburg month | `{ period, status, dueDate }`; `dueDate` is nullable |
| `amountPaid` | int64 **cents** | No | Mine, in the current cycle. It is cents despite having no `Cents` suffix |
| `amountOwed` | int64 **cents** | No | `max(0, contribution − paid)`; `0` with no cycle |
| `arrearsCents` | int64 cents | Not nullable, but **not in `required`** (`default: 0`) | My recorded shortfalls in this stokvel. The app treats a missing value as 0 |
| `nextPayoutDate` | date-time | **Yes, and always `null` today** | No payout schedule exists (API README "Known Limitations"). The app shows "No payout scheduled" |

The app shows these numbers and never computes them.

#### 4. Due dates: date-only or instants?

**Date-only.** `dueDate` (and `endDate`) are `format: date` (`2026-10-31`), from a C# `DateOnly` on Johannesburg calendar days. The app models them as [`CalendarDate`](lib/core/time/calendar_date.dart), never `DateTime`. Converting one to `DateTime` would attach a time zone, and the date could shift to the day before. The **instants** are `nextPayoutDate`, `recordedAtUtc`, `joinedAtUtc` and `paidAtUtc` (`date-time`); those are `DateTime`.

#### 5. The three seed personas

**The API has none.** Its README says: *"There's no seed data. Create an account with `POST /api/v1/auth/register`…"*. So the personas are defined here, in [`fake_seed.dart`](lib/features/stokvels/data/fake_seed.dart). To keep Week 11's switch invisible on screen, the same people have to exist in the API (see the gaps below).

| Persona | Mabena Family (R 500,00 a month) | Soweto Teachers (R 1 500,00 a month) | What Home shows |
|---|---|---|---|
| **Lerato Mokoena**, Treasurer-in-one | **Treasurer**; paid R 500,00 (`Paid`) | **Member**; paid R 750,00 of R 1 500,00 (`Paid`) | Two cards: Treasurer and Member |
| **Sipho Dlamini** | **Member**; paid nothing; **R 250,00 arrears** | **Chairperson**; paid nothing | Two cards, one with arrears |
| **Thabo Nkosi** | not a member | not a member | The empty state |

Also present, as other members only: Nomsa Mabena (Chairperson of Mabena Family, `Confirmed`) and Kagiso Molefe (Treasurer of Soweto Teachers, `Confirmed`). Both cycles are `2026-11`, `Open`, due 30 Nov and 25 Nov.

#### Gaps found, and backend pull requests

**Backend branch:** [`fix/mobile-contract-gaps`](https://github.com/mdvar2/RondiTrack/compare/assignment-9.3...fix/mobile-contract-gaps) in the API repo, commit `0bb7f92`, based on the contract commit `3d04a52` (branch `assignment-9.3`). **Pull request:** not yet opened; open it at <https://github.com/mdvar2/RondiTrack/pull/new/fix/mobile-contract-gaps> with base `assignment-9.3`, and put its link here.

| # | Gap | Why it matters to the app | Status |
|---|---|---|---|
| 3 | `StokvelDetailResponse.currentCycle` had no cycle id | Contributions need `cycleId`, so detail cost a second call (`GET …/cycles`) | **Fixed on the backend branch**: `StokvelCycleSummaryResponse.id` (uuid, required) |
| 5 | `arrearsCents` wasn't in `required` (it had `default: 0`) | A generated client makes it optional | **Fixed on the backend branch**: required, no default |
| 1 | No seed data | The fakes' personas don't exist in the real API | Not fixed in 10.1. The app doesn't call the API until Week 11; a dev-only seed of the three personas belongs with that switch. Open |
| 2 | No endpoint confirms a contribution | `Confirm contributions` has nothing to call | Not fixed in 10.1: the button only shows "coming soon". A new endpoint with its own rules is a feature, not a contract fix. Open |
| 4 | Statuses and roles are untyped `string` in OpenAPI | Week 11's generated client can't produce enums | Not fixed in 10.1. The app already maps strings to enums with `unknown`, so nothing breaks; declaring enums changes the web client's types too. Open |
| 6 | Some money is `double` (`contributionAmount`, `targetAmount`, …) | Doubles near money | No change needed: every amount the app reads has a `…Cents` integer twin, and the app reads only those |
| 7 | No activity feed endpoint (10.2) | The Activity tab has nothing to call | Open. The fake builds the feed from my stokvels' current-cycle contributions; Week 11 needs `GET /me/activity`, or the app calls each stokvel's contributions |
| 8 | `InvitePreviewResponse` doesn't say whether I'm already a member (10.2) | The preview must not offer "Join" to a member | Open. The app checks the stokvel against Home's list instead, and the fake's join is idempotent |

What the backend branch changes, with its tests:

- `API/DTOs/Stokvels/StokvelDetailResponse.cs` and `API/Services/StokvelDetailService.cs`: the cycle summary carries the cycle's `Id`.
- `API/DTOs/Home/HomeResponse.cs`: `ArrearsCents` has no default, so it is required.
- `openapi/v1.json` regenerated; `web-next/src/lib/schema.d.ts` regenerated, and one web test fixture given the new `id`.
- Tests: `StokvelDetailTests` asserts the id; a new `OpenApiContractTests.ServedDocument_MarksFieldRequired` theory checks both fields are required in the served document.
- Run locally (Docker running): `dotnet test` **167 passed, 0 failed**; web `tsc --noEmit` clean, `eslint` clean, Vitest **228 passed**. The API repo's CI runs on pull requests only, so it will run when the PR is opened.

---

## Part 8: Tests, CI and evidence

*How the work is checked, and the record of what was run and seen.*

### Tests and CI

> **The kinds of test used.** *Unit tests* check one function with plain values (the redirect rules, the money parser). *Widget tests* draw a screen in a simulated window and tap it. *Router-level tests* start the whole real app, with routes, gate and theme, on instant fakes, and drive it like a person would. *CI* (continuous integration) runs all of it on GitHub for every pull request and every push to `main`, so a pull request shows whether every check passes before anyone merges it.

```powershell
dart format --output=none --set-exit-if-changed lib test
dart run build_runner build
dart analyze --fatal-infos
flutter test
```

| Area | File |
|---|---|
| Config refusals | `test/core/config/app_config_test.dart` |
| Money (formatter, parser, `Cents`) | `test/core/money/` |
| Date-only values | `test/core/time/calendar_date_test.dart` |
| Status mapping and labels | `test/features/stokvels/domain/statuses_test.dart` |
| `Membership` (Lerato: Treasurer and Member, one login) and not-yours = 404 | `test/features/stokvels/domain/membership_test.dart` |
| The actions match, one test per row | `test/features/stokvels/domain/stokvel_actions_test.dart` |
| Notifier state → sealed view state (no stokvels = empty) | `test/core/state/view_state_test.dart` |
| Home's four states and pull-to-refresh | `test/features/home/presentation/home_screen_test.dart` |
| Detail's states, Treasurer vs Member actions, not found | `test/features/stokvels/presentation/stokvel_detail_screen_test.dart` |
| Family: separate state per id, one shared fetch, disposal | `test/features/stokvels/presentation/stokvel_detail_provider_test.dart` |
| Part 5 frame test | `test/features/stokvels/presentation/stokvel_switch_test.dart` |
| Architecture boundary | `test/architecture_test.dart` |
| Flaky fakes: which calls fail, dev-only switch, wrapping in the composition root | `test/core/fakes/fail_every_test.dart`, `test/app/flaky_fakes_test.dart` |
| **10.2** The gate as a pure function: signed out, signed in, the remembered `/join/:code`, addresses from outside the app, sign-in while signed in, no loops | `test/app/router/redirect_test.dart` |
| **10.2** Router-level: each twist (non-member "not found" for a stokvel and a cycle; Lerato's treasurer actions by address; `/join/:code` through sign-in), a tab keeping its stack and scroll position, tapping the current tab, back after a cold start, sign-out, the redirect re-running on an auth change | `test/app/router/router_test.dart` |
| **10.2** Layouts: every screen at 360 by 640 dp with text at 200%, list and detail side by side at 1280 by 800, rotation, rail or bar at each breakpoint edge, dark mode | `test/app/layout_test.dart` |
| **10.2** Every token's contrast in both themes, and the README table | `test/core/theme/contrast_test.dart` |
| **10.2** Breakpoints | `test/core/layout/window_size_test.dart` |
| **10.2** Fake sign-in, invites (join is isolated per session), activity, cycle by id | `test/features/fakes_10_2_test.dart` |
| **10.2** No `Navigator.push`, string path or typed colour in a widget | `test/architecture_test.dart` |

Router-level tests pump the real app ([`app_harness.dart`](test/helpers/app_harness.dart)): router, gate, theme and shell, on fakes with no delay. A cold start is simulated with the platform's initial route, which is where a deep link arrives when it starts the app.

The **10.1 one-frame test** now runs through the router. The picker changes the address, and one frame later Soweto Teachers is loading, with none of Mabena Family's contributions. The 10.1 widget tests that pumped a screen on its own still do. The app smoke test signs Lerato in first, because the app now opens behind the gate.

Widget tests swap repositories with `overrideWithValue`, never by editing a provider. Each test puts its `ProviderScope` directly inside `tester.pumpWidget(…)`. Failure tests pass `retry: (retryCount, error) => null`.

[CI](.github/workflows/ci.yml) runs on every pull request and on pushes to `main`, using Flutter 3.47.7.

### Verification

> **What this section is.** The record of what was actually run and seen: the commands and their results, CI runs, and screenshots and recordings from an Android emulator. The tests prove the rules; the emulator evidence shows the real app on a real (emulated) phone doing what the tests claim.

Run locally on 2026‑11‑11 (Windows, Flutter 3.47.7, Dart 3.13.5):

| Check | Result |
|---|---|
| `flutter pub get --enforce-lockfile` | Resolved; every package pinned exactly and at least two weeks old |
| `dart format --output=none --set-exit-if-changed lib test` | 0 changed |
| `dart run build_runner build` | Built; `git diff` on generated files empty |
| `dart analyze --fatal-infos` | No issues found |
| `flutter test` | **139 passed**, 0 failed |
| `flutter build apk --debug --flavor dev / staging / prod` | All three built and installed side by side (AGP 9 manifest-placeholder flavours work) |

**CI on GitHub:** the red run and the green run are in "Lints" above. The app itself (commit `ed72cbf`, pushed to `main`) passed on its own: run [42972190662](https://github.com/mdvar2/RondiTrackApp/actions/runs/42972190662), every step green.

#### Emulator evidence

Android emulator (Pixel 7 profile, Android 37.1, debug builds), in [`docs/evidence/`](docs/evidence/):

| What | File |
|---|---|
| Launcher with all three flavours installed (RondiTrack, RondiTrack Dev, RondiTrack Staging; the launcher shortens long labels) | [`01-launcher-flavours.png`](docs/evidence/01-launcher-flavours.png), plus [`01-installed-packages.txt`](docs/evidence/01-installed-packages.txt) |
| Home as Lerato (Treasurer of one stokvel, Member of the other) | [`02-home-lerato.png`](docs/evidence/02-home-lerato.png) |
| Home as Thabo (no stokvels): the empty state | [`03-home-thabo-empty.png`](docs/evidence/03-home-thabo-empty.png) |
| Mabena Family, where Lerato is Treasurer: treasurer actions shown | [`04-stokvel-treasurer.png`](docs/evidence/04-stokvel-treasurer.png) |
| Soweto Teachers, where Lerato is Member: no treasurer actions | [`05-stokvel-member.png`](docs/evidence/05-stokvel-member.png) |
| A failure state, with Try again (`FAKE_FAIL_EVERY=1`) | [`06-failure-home.png`](docs/evidence/06-failure-home.png) |
| Mid-switch: "Loading Soweto Teachers…", none of Mabena's data under Soweto's name | [`06a-switch-loading-soweto.png`](docs/evidence/06a-switch-loading-soweto.png) |
| Screen recording of the Part 5 switch (Mabena Family → slow Soweto Teachers) | [`07-stokvel-switch.mp4`](docs/evidence/07-stokvel-switch.mp4) |
| Disposal on the device: Mabena's provider is disposed when the switch leaves it | [`08-disposal-logcat.txt`](docs/evidence/08-disposal-logcat.txt) |

The device log of that switch (ids only, no names or amounts):

```
I flutter : [lifecycle] stokvelDetail created id=5d0c9a4e-2b1f-4c8a-8e7d-3a6b9f2e0101
I flutter : [lifecycle] stokvelDetail created id=5d0c9a4e-2b1f-4c8a-8e7d-3a6b9f2e0102
I flutter : [lifecycle] stokvelDetail disposed id=5d0c9a4e-2b1f-4c8a-8e7d-3a6b9f2e0101
```

What the phone showed that the tests don't: with `FAKE_FAIL_EVERY=3`, Home never showed its failure state. The first call failed, and Riverpod 3's automatic retry (call 2) succeeded within a moment. The failure screenshot therefore uses `1`.

#### Assignment 10.2: verification

Run locally on 2026‑11‑12 (Windows, Flutter 3.47.7, Dart 3.13.5):

| Check | Result |
|---|---|
| `flutter pub get --enforce-lockfile` | Resolved; go_router 18.1.1, go_router_builder 4.5.2 and every new transitive package at least two weeks old |
| `dart format --output=none --set-exit-if-changed .` | 0 changed |
| `dart run build_runner build` | Built; `git diff` on generated files empty |
| `dart analyze --fatal-infos` | No issues found |
| `flutter test` | **268 passed**, 0 failed (139 from 10.1 still green) |
| `flutter build apk --debug --flavor dev / staging / prod` | All three built and installed side by side; each opens only its own scheme |

#### Assignment 10.2: emulator evidence

Same emulator, debug builds, in [`docs/evidence/10.2/`](docs/evidence/10.2/). The 360 dp screenshots set the display density to 480 (1080 px / 3 = 360 dp) and the font scale to 2.0. The tablet ones set the display to 2560×1600 px at density 320, which is 1280×800 dp (`adb shell wm size` and `wm density`): a window size, which is exactly what the breakpoints read.

| What | File |
|---|---|
| Home, light and dark | [`01-home-light.png`](docs/evidence/10.2/01-home-light.png), [`03-home-dark.png`](docs/evidence/10.2/03-home-dark.png) |
| A stokvel (Mabena Family, Lerato as Treasurer), light and dark | [`02-stokvel-light.png`](docs/evidence/10.2/02-stokvel-light.png), [`04-stokvel-dark.png`](docs/evidence/10.2/04-stokvel-dark.png) |
| The non-member's "not found": Thabo opens a link to Mabena Family | [`05-non-member-not-found.png`](docs/evidence/10.2/05-non-member-not-found.png) |
| Recording: cold-start link to a cycle, through sign-in, then back to the stokvel, the list and Home, with the app still open | [`06-cold-start-cycle-link-then-back.mp4`](docs/evidence/10.2/06-cold-start-cycle-link-then-back.mp4) |
| Recording: `/join/MABENA26` opened signed out, through sign-in, to the invite, then Join | [`07-join-link-signed-out-to-invite.mp4`](docs/evidence/10.2/07-join-link-signed-out-to-invite.mp4), with the result in [`07a-joined-mabena-as-member.png`](docs/evidence/10.2/07a-joined-mabena-as-member.png) (Thabo, Member: Pay only) |
| 360 dp, text at 200%: Home, the stokvel list, a stokvel (top and scrolled to its actions) | [`08-home-360dp-200pct.png`](docs/evidence/10.2/08-home-360dp-200pct.png), [`09-stokvel-list-360dp-200pct.png`](docs/evidence/10.2/09-stokvel-list-360dp-200pct.png), [`10-stokvel-360dp-200pct.png`](docs/evidence/10.2/10-stokvel-360dp-200pct.png), [`10b-stokvel-360dp-200pct-scrolled.png`](docs/evidence/10.2/10b-stokvel-360dp-200pct-scrolled.png) |
| Tablet on its side: list and detail side by side | [`11-tablet-landscape-list-detail.png`](docs/evidence/10.2/11-tablet-landscape-list-detail.png) |
| Tablet upright: the same stokvel, one pane | [`12-tablet-portrait-same-stokvel.png`](docs/evidence/10.2/12-tablet-portrait-same-stokvel.png) |

What the phone showed that the tests don't: go_router receives the whole link (`ronditrack-dev://app/stokvels/…`) as the cold-start route and matches on its path, so the custom scheme and `app` host need no handling in the app. The gate reads only the path, too (`redirect_test.dart` covers a full link). The bottom bar's labels stay smaller than the rest at 200% because Flutter's `NavigationBar` caps their text scaling itself; all four labels stay visible.

---

## Part 9: Still open

*What is not done yet.*

### Still open

> **What this section is.** The honest list of what isn't done yet, so nothing missing is hidden.

- [ ] Open the backend pull request (link above) and link it here and in the app PR.
- [x] Open the "Assignment 10.1: Foundations and State" pull request and wait for its green run: [#3](https://github.com/mdvar2/RondiTrackApp/pull/3), merged into `main`.
- [ ] Gaps 1, 2, 4, 7 and 8 in "Contract notes" are open, with reasons.
- [ ] iOS flavours and iOS deep links (need Xcode on a Mac).
- [ ] Stretch goals not attempted: every route as every persona in one test, a dev-only theme gallery, predictive back, a real App Link.
