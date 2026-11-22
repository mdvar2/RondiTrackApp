# RondiTrack Mobile

The RondiTrack phone app (Flutter, Android and iOS). It shows each person their stokvels, what they've paid and owe, and what they can do in each stokvel, given their role there.

This is Week 10: Assignment 10.1 (foundations and state), Assignment 10.2 (every screen has an address) and Assignment 10.3 (the foundations capstone: rotation and payouts through every layer, and three people on one phone). **Nothing calls the API yet.** Fake repositories hold three seed personas. Week 11 swaps them for the real API in [`lib/app/providers.dart`](lib/app/providers.dart), and no widget changes.

**Since Assignment 11.1 it does:** every repository runs on the RondiTrack API through a client generated from the contract copy, with every failure turned into one `Failure`. The swap changed no widget. The fakes stay, for the tests, behind one switch. See [Part 10](#part-10-real-data-assignment-111).

**Since Assignment 11.2 it signs people in for real:** register, sign in, stay signed in across a restart, one refresh however many requests need it, and sign-out that leaves nothing of the last person on a shared phone. No password is built into any flavour. See [Part 11](#part-11-sign-in-assignment-112).

- API repository: [mdvar2/RondiTrack](https://github.com/mdvar2/RondiTrack)
- API contract copy: [`contract/openapi/v1.json`](contract/openapi/v1.json), from API commit [`da39b16`](https://github.com/mdvar2/RondiTrack/commit/da39b168f78d521fe0fecff751c85862cb64ce40) (byte-identical to `openapi/v1.json` at that commit; SHA-256 `1111c20c…16321`). That commit adds the payout order endpoint ([API PR #15](https://github.com/mdvar2/RondiTrack/pull/15)) on top of the 10.1 contract fixes ([API PR #14](https://github.com/mdvar2/RondiTrack/pull/14)). 10.1 and 10.2 read the contract at `3d04a52` (SHA-256 `7292b744…4a0dc3`).

## Contents

- [At a glance](#at-a-glance)
- [How to read this README](#how-to-read-this-readme) (with a [glossary](#glossary))
- [Part 1: Navigation, every screen has an address](#part-1-navigation-every-screen-has-an-address)
  - [Routes](#routes)
  - [The gate](#the-gate)
  - [Deep links](#deep-links)
  - [Personas: three people, one phone](#personas-three-people-one-phone)
- [Part 2: Getting started](#part-2-getting-started)
  - [Running it](#running-it)
    - [Flavours and config files](#flavours-and-config-files)
    - [Dependencies](#dependencies)
- [Part 3: How the code is organised](#part-3-how-the-code-is-organised)
  - [Architecture](#architecture)
  - [Architecture rules](#architecture-rules)
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
    - [Payouts: the five answers (Assignment 10.3)](#payouts-the-five-answers-assignment-103)
    - [Real data: the seven answers (Assignment 11.1)](#real-data-the-seven-answers-assignment-111)
    - [Auth: the seven answers (Assignment 11.2)](#auth-the-seven-answers-assignment-112)
    - [Gaps found, and backend pull requests](#gaps-found-and-backend-pull-requests)
- [Part 8: Tests, CI and evidence](#part-8-tests-ci-and-evidence)
  - [Tests and CI](#tests-and-ci)
  - [Verification](#verification)
    - [Emulator evidence](#emulator-evidence)
    - [Assignment 10.2: verification](#assignment-102-verification)
    - [Assignment 10.2: emulator evidence](#assignment-102-emulator-evidence)
    - [Assignment 10.3: verification](#assignment-103-verification)
- [Part 9: Still open](#part-9-still-open)
  - [Still open](#still-open)
- [Part 10: Real data (Assignment 11.1)](#part-10-real-data-assignment-111)
  - [Running against the API](#running-against-the-api)
  - [The API client](#the-api-client)
  - [Failures](#failures)
  - [Decisions](#decisions)
  - [Assignment 11.1: verification](#assignment-111-verification)
- [Part 11: Sign-in (Assignment 11.2)](#part-11-sign-in-assignment-112)
  - [The session](#the-session)
  - [Running against the API: what changed in 11.2](#running-against-the-api-what-changed-in-112)
  - [Decisions (11.2)](#decisions-112)
  - [Assignment 11.2: verification](#assignment-112-verification)

---

## At a glance

| | What it delivered | Where to read about it |
|---|---|---|
| **Assignment 10.1**: foundations and state | Three flavours with validated config;<br>the domain (money in cents, date-only due dates, statuses with an `unknown` fallback, roles per stokvel);<br>three seed personas on fake repositories;<br>Riverpod state with deliberate lifetimes;<br>strict lints and CI | [Part 2](#part-2-getting-started),<br>[Part 3](#part-3-how-the-code-is-organised),<br>[Part 4](#part-4-state-and-provider-lifetimes),<br>[Part 6](#part-6-domain-rules),<br>[Part 7](#part-7-the-api-contract) |
| **Assignment 10.2**: every screen has an address | Four tabs that keep their place;<br>typed routes for every screen;<br>a fake sign-in and one testable gate;<br>deep links per flavour;<br>a Material 3 light and dark design system with measured contrast;<br>phone and tablet layouts | [Part 1](#part-1-navigation-every-screen-has-an-address),<br>[Part 5](#part-5-look-and-layout) |
| **Assignment 10.3**: the foundations capstone | The rotation and payouts view, built layer by layer (domain, fake, provider, theme, route, screen), each with its tests;<br>a backend fix so the API says who is next;<br>three personas, each seeing exactly their own world;<br>a persona switcher in the dev build only;<br>"not found" never retried;<br>architecture rules and the Routes table checked by CI;<br>one Dart 3 refactor | [Personas](#personas-three-people-one-phone),<br>[Architecture rules](#architecture-rules),<br>[Payouts contract](#payouts-the-five-answers-assignment-103),<br>[10.3 verification](#assignment-103-verification) |
| **Checks** | 415 tests passing (268 of them from 10.1 and 10.2);<br>`dart analyze --fatal-infos` clean;<br>CI green on `main` | [Part 8](#part-8-tests-ci-and-evidence) |

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
| `/stokvels/:id/cycles/:cycleId/payouts` | The cycle's payout order, exactly as the API sends it: each member's position, amount in rands and status in words and colour, the next member highlighted, and **Record payout** only where my role in *this* stokvel allows it. Opened from the cycle's **Payout order** button. **Stokvels** tab (10.3) | Sign-in, then this payout order | **"We couldn't find that cycle."**, at once, with no spinner: the same for a cycle that doesn't exist, a cycle of another stokvel, and a cycle of a stokvel I'm not in | `/stokvels/:id/cycles/:cycleId`, then `/stokvels/:id`, then `/stokvels`, also after a cold start |
| `/stokvels/:id/cycles/:cycleId/close` | Closing the cycle, a treasurer action: what closing would record (each member's shortfall and the total, as the API works them out), and **Close cycle**. Opened from the stokvel's **Close cycle** action. **Stokvels** tab (11.1) | Sign-in, then this preview | **"We couldn't find that cycle."**, at once. A *member* of the stokvel without the role (opening the link) is told **"Your role in this stokvel doesn't allow that. Only its treasurer or chairperson can do it."** (the API's `403`), and stays signed in | `/stokvels/:id/cycles/:cycleId`, then `/stokvels/:id`, then `/stokvels`, also after a cold start |
| `/stokvels/:id/cycles/:cycleId/pay` | Paying my own contribution to the cycle: the amount in rands, and **Pay**. The payment goes into the phone's outbox at once and is sent from there; while it waits, **Pay** is disabled. **Stokvels** tab (11.3) | Sign-in, then this form | **"We couldn't find that cycle."**, as for the cycle | `/stokvels/:id/cycles/:cycleId`, also after a cold start |
| `/stokvels/:id/cycles/:cycleId/edit` | Editing the cycle's target and due date, a treasurer action; someone else's newer save rolls the edit back to the latest. **Stokvels** tab (11.3) | Sign-in, then this form | **"We couldn't find that cycle."**, as for the cycle | `/stokvels/:id/cycles/:cycleId`, also after a cold start |
| `/stokvels/:id/contributions` | Every contribution to one of the stokvel's cycles, newest first, a page at a time, filtered by cycle, status, member and South African days. **Stokvels** tab (11.3) | Sign-in, then this list | **"We couldn't load the contributions."** with the reason (not found) | `/stokvels/:id`, also after a cold start |
| `/stokvels/new` | Creating a stokvel: its name, its contribution in rands and its first due date; I become its chairperson. **Stokvels** tab (11.3) | Sign-in, then this form | Not applicable | `/stokvels`, also after a cold start |
| `/activity` | Activity across my stokvels, newest first. **Activity** tab | Sign-in, then Activity | Not applicable: only my stokvels' activity | Home tab (`/`) |
| `/profile` | Who is signed in, and **Sign out**. **Profile** tab | Sign-in, then Profile | Not applicable | Home tab (`/`) |
| `/join/:code` | An invite's preview, then **Join**. **Home** tab | Sign-in, then **this invite's preview** (remembered across sign-in) | Not applicable: an invite is how a non-member joins. An unknown code shows "We couldn't find that invite." | Home (`/`), also after a cold start |
| `/sign-in` | Fake sign-in by email. No tabs | Shown | Not applicable | Leaves the app. Signing out empties the history, so back can't reach a signed-in screen |
| `/register` | Create an account: name, email, password; the API's field errors under their fields. Then signed in, and on to the remembered address. No tabs (11.2) | Shown | Not applicable | Leaves the app |
| `/splash` | The one refresh on launch; if it can't reach the API, **Try again** and **Sign out**. Every address waits here while the app is restoring, and is remembered. No tabs (11.2) | Not shown: signed out goes to sign-in, passing the remembered address on | Not applicable | Leaves the app |

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
| Restoring (11.2) | `/splash` | Stays, offline included |
| Restoring (11.2) | anything else | `/splash?from=<that address>` (sign-in and register pass on their own `from`), so a link survives the splash |
| Signed out (11.2) | `/splash?from=…` | `/sign-in?from=…`, still remembering (`/register` if that was the address) |
| Signed in (11.2) | `/splash?from=…` or `/register` | The remembered address, or Home |

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

### Personas: three people, one phone

> **In plain words.** A family shares one phone. Lerato is Treasurer of one stokvel and an ordinary Member of another; Sipho is a Member only; Thabo is in no stokvel. Whoever is signed in must see exactly their own stokvels, their own buttons and their own empty states, and when the phone changes hands, nothing of the last person may be left on screen, not even for a frame.

What each persona sees (Assignment 10.3). Every cell is checked by [`personas_test.dart`](test/app/personas_test.dart), one table-driven test per screen:

| Persona | Home | Mabena Family | Soweto Teachers | Payouts view: Mabena Family | Payouts view: Soweto Teachers |
|---|---|---|---|---|---|
| **Lerato Mokoena** | Two cards: Mabena Family (**Treasurer**), Soweto Teachers (Member) | Your role: Treasurer.<br>Pay, Upload proof, **Confirm contributions, Close cycle, Record payout** | Your role: Member.<br>Pay, Upload proof | Nomsa **Paid**, Lerato **Next to be paid** (highlighted), Sipho **Waiting**.<br>**Record payout** | Kagiso **Next to be paid**, Sipho and Lerato **Waiting**.<br>No action |
| **Sipho Dlamini** | Two cards, both Member; Mabena Family **In arrears** (R 250,00) | Your role: Member.<br>Pay | Your role: Member.<br>Pay | The same order.<br>No action | The same order.<br>No action |
| **Thabo Nkosi** | "You're not in a stokvel yet", how to join (ask for an invite link and open it on this phone) and **Refresh** | "We couldn't find that stokvel." | "We couldn't find that stokvel." | "We couldn't find that cycle." | "We couldn't find that cycle." |

- **Treasurer actions come from that stokvel's membership**, through the 10.1 actions match, never from the person or a token. Sipho sees no treasurer action on any address (the test opens ten).
- **The order is the stokvel's, not the viewer's.** Lerato and Sipho see the same Mabena Family order; only the buttons differ.

**How to switch, in the dev build.** Tap the round **switch account** button at the bottom right of any tab, then a persona. The switcher signs out and in again through the same [`AuthController`](lib/features/auth/presentation/auth_controller.dart) a person uses, so the gate, the shell and every provider react as to a real sign-in, and you land back on the same address as the new person: Lerato with Mabena Family open becomes Sipho with Mabena Family open, as a Member. On the sign-in page, the dev build also lists the three personas under "Test accounts".

**Only in the dev build: absent, not hidden.** [`AppConfig.hasDevTools`](lib/core/config/app_config.dart) is true for dev only, and the shell checks it where it builds its buttons. Staging and prod build no switcher (no `FloatingActionButton` at all) and list no test accounts. The switcher has no address in any flavour: `/dev/personas` lands on Home, like any address the Routes table doesn't have. [`persona_switcher_test.dart`](test/app/dev/persona_switcher_test.dart) builds the app with the staging and prod configs and looks for the switcher on every address.

**Nothing of the last person survives a switch.** [`personas_test.dart`](test/app/personas_test.dart) switches from Lerato to Sipho with Mabena Family open, with real fake delays, and checks every 16 ms frame. From the frame after Lerato's sign-out completes, none of her treasurer actions, her Upload proof, "Your role: Treasurer" or her email (not even offstage on the Profile tab) appears, and sign-in never shows over the old shell: the shell and every screen in it are already gone. That is the 10.1 sign-out plan, now tested; no change to the app was needed. (The frame in which her sign-out completes is still hers: the state changes during that frame and the gate redirects on the next one, as a frame-by-frame trace showed.)

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
| Sipho Dlamini | `sipho@ronditrack.example` | Member of Mabena Family (in arrears) and Member of Soweto Teachers: a Member only (until 10.3 he was Chairperson of Soweto Teachers) |
| Thabo Nkosi | `thabo@ronditrack.example` | None: Home's empty state, and the one who joins by invite |

Since 10.3 the "Test accounts" are listed in the **dev** build only; in staging and prod, type the email. The dev build also has the persona switcher ([Personas](#personas-three-people-one-phone)).

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

```text
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
    payouts/    domain/ (PayoutOrder, PayoutStatus, PayoutRepository)  data/ (FakePayoutRepository)
                presentation/ (payoutOrderProvider, PayoutsScreen, PayoutStatusChip)   (10.3)
  app/dev/      persona_switcher.dart: the dev-only persona switcher (10.3)
  app/retry.dart  appRetry: never retry "not found" (10.3)
contract/openapi/v1.json   the API contract copy
```

- Repository **interfaces** live in each feature's `domain/`. **Fakes** live in `data/`. **One provider per repository** in [`lib/app/providers.dart`](lib/app/providers.dart) names the implementation; that file is the only one Week 11 changes.
- No widget imports a fake, a `data/` folder, Dio or Drift. [`architecture_test.dart`](test/architecture_test.dart) enforces it, and checks that only `providers.dart` names a fake.
- Widgets navigate only with the typed routes in [`routes.dart`](lib/app/router/routes.dart) (`StokvelRoute(id: id).go(context)`). The architecture test fails on a `Navigator.push`, a `MaterialPageRoute`, or a string path in a widget.
- Every screen renders the sealed [`ViewState`](lib/core/state/view_state.dart) (`ViewLoading`, `ViewEmpty`, `ViewData`, `ViewFailure`) with an exhaustive `switch`.

### Architecture rules

> **In plain words.** Two things a reviewer used to send back, "a colour typed into a widget" and "a screen that imports a `data/` folder", are now CI checks. [`architecture_test.dart`](test/architecture_test.dart) reads every hand-written Dart file and fails on a break. A rule may have an exception, but only one written into the test with its reason and the week it ends.

What the test enforces (Assignment 10.3), one test per rule:

| Rule | Files it reads | Fails on |
|---|---|---|
| No colour typed outside the theme | Everything under `lib/features/` (every layer) and `lib/app/` | `Color(0x…)`, `Colors.…`, `Color.fromARGB`, `Color.fromRGBO`. Only `lib/core/theme/` names colours |
| No screen imports `data/`, a fake, Dio or Drift | Every `presentation/` file | An import of a `data/` folder, a `fake_…` file, `package:dio` or `package:drift` |
| No screen imports the composition root | Every `presentation/` file that builds widgets | An import of `app/providers.dart`, which imports every `data/` folder |
| Only `app/providers.dart` names a repository | Everything under `lib/` outside `data/` | `Fake…Repository(` or `Flaky…Repository(` |
| No `Navigator.push` | Everything under `lib/` | `Navigator.push`, `Navigator.of(…).push`, `MaterialPageRoute` (10.2's rule, now enforced) |
| No string path in a widget | Screens, and `lib/app/` | `context.go(…)`, `GoRouter.of(…)`, `.go('/…')`: screens navigate with typed routes |

**Exceptions**, each in the test with its reason and end:

| Rule | File | Reason | Ends |
|---|---|---|---|
| No screen imports the composition root | [`stokvel_detail_screen.dart`](lib/features/stokvels/presentation/stokvel_detail_screen.dart) | Reads `signedInUserIdProvider` (whose contribution is mine, for the actions match). It lives in the composition root until the session has a home of its own | Week 11 |
| No screen imports the composition root | [`payouts_screen.dart`](lib/features/payouts/presentation/payouts_screen.dart) | Reads `signedInUserIdProvider` for the actions match, as the stokvel screen does | Week 11 |
| No screen imports the composition root | [`sign_in_screen.dart`](lib/features/auth/presentation/sign_in_screen.dart) | Reads `demoAccountsProvider`, the dev build's test accounts, which name the fakes' personas | Week 11 |

The test checks the exceptions too. Each needs a reason and a week, and an exception fails once it no longer matches anything, so a fixed file can't keep its excuse. Two self-checks prove the rules really look: a known screen is recognised as one, and the patterns match the imports and colours they forbid.

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

```text
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

```text
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

- **"Not found" is never retried (10.3).** Riverpod 3 retries every failed provider, up to ten times with growing waits. For a 404 that is pointless: asking again can't change the answer. Every not-found error implements [`NotFoundException`](lib/core/errors/not_found.dart), and [`appRetry`](lib/app/retry.dart), the root `ProviderScope`'s `retry` in `main`, returns `null` for it and Riverpod's default otherwise. The whole-app test harness uses the same function. [`retry_test.dart`](test/app/retry_test.dart) opens Thabo's link to Mabena Family's payouts and checks "not found" with no spinner in every frame, and that the repository is asked **once**; with Riverpod's default retry, the same link was asked again and again. (What this app showed: its view state puts an error before loading, so the retries didn't show a spinner here. They were still repeated requests, which against the real API would be about ten 404s per link.)

### Provider lifetimes

> **In plain words.** Every provider either lives for the whole session (**keepAlive**) or is thrown away as soon as no screen is using it (**autoDispose**). Keeping data costs memory and can keep other people's details on a shared phone; throwing it away costs a reload. The table gives the reason for each choice.

| Provider | Holds | Lifetime | Cost of keeping it on an entry-level phone | Cost of disposing it |
|---|---|---|---|---|
| `authControllerProvider` | Who is signed in (`SignedOut` or `SignedIn`) | **keepAlive** | One small object | It *is* the session: disposing it would sign the person out |
| `signedInUserIdProvider` | The signed-in person's id, `null` when signed out (follows `authControllerProvider`) | **keepAlive** | One string | Everything that depends on it rebuilds. It must live for the whole session |
| `routerProvider` | The `GoRouter`, which owns every tab's stack | **keepAlive**, built once | One router | Every tab would lose its place. It *listens* to the auth state rather than watching it, so it is never rebuilt |
| `authRepositoryProvider`,<br>`homeRepositoryProvider`,<br>`stokvelRepositoryProvider`,<br>`activityRepositoryProvider`,<br>`inviteRepositoryProvider`,<br>`payoutRepositoryProvider` (10.3) | The repository objects (Week 11: an API client and its connection pool) | **keepAlive** | Small, and no personal data of its own | Rebuilding the client and its connections on every screen |
| `fakeStokvelsProvider`,<br>`fakeDelayProvider`,<br>`demoAccountsProvider` | The fakes' changeable seed copy (a join lands here), their delay, the sign-in page's test accounts. Week 11 deletes them | **keepAlive** | Kilobytes | A join would be forgotten: the fake "server" must outlive screens |
| `lifecycleLogProvider` | A logging function | **keepAlive** | Nothing | Nothing gained |
| `fakeFailEveryProvider` | One number from `FAKE_FAIL_EVERY` (dev only; Week 11 deletes it) | **keepAlive** | One int | The repositories watch it; rebuilding them would reset the flaky fakes' call count |
| `homeControllerProvider` | My stokvels, roles and amounts | **autoDispose** | Home is the root screen, so it is watched for the whole session anyway | Only when Home leaves the stack (sign-out), which is exactly when it should go |
| `stokvelDetailProvider(id)` | One stokvel's cycle and **other members'** names and contributions | **autoDispose** | Memory per stokvel opened; other people's data kept after you leave; it goes stale (a contribution recorded meanwhile wouldn't show) | A refetch and a spinner when the stokvel is reopened, which on a data bundle is a small, honest cost |
| `cycleDetailProvider(id, cycleId)` | One cycle and its contributions | **autoDispose** | As stokvel detail | As stokvel detail |
| `payoutOrderProvider((stokvelId:, cycleId:))` (10.3) | One cycle's payout order: **other members'** names, amounts and when they were paid | **autoDispose**, a family keyed by a record of both ids (equal by value, so a rebuild finds the same member) | Other people's money kept after you leave, and stale once a payout is recorded | A refetch when the payouts view is reopened |
| `activityControllerProvider` | My activity feed | **autoDispose** | Watched while the Activity tab is in the shell's stack | Dropped at sign-out with the shell |
| `invitePreviewProvider(code)`, `inviteJoinerProvider(code)` | One invite's preview, and the join in progress | **autoDispose** | Tiny | Nothing worth keeping once the invite screen closes |

**Tabs and autoDispose.** The shell keeps each tab's navigator alive (an indexed stack), so a screen on a tab you've left is still mounted and still watching its provider. That is what keeps a cycle open, and scrolled where it was, when you come back. The data is disposed when the screen is popped, or when sign-out disposes the shell.

**Disposal is proven** in [`stokvel_detail_provider_test.dart`](test/features/stokvels/presentation/stokvel_detail_provider_test.dart). When the last listener closes, `container.exists(stokvelDetailProvider(id))` becomes false, and the log is exactly:

```text
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
| `payoutPaid` (10.3) | 4.5:1 | `#21005D` / `#EADDFF` | 13.32:1 | `#EADDFF` / `#4F378B` | 7.23:1 |
| `payoutNext` (10.3) | 4.5:1 | `#002020` / `#9CF1F0` | 13.24:1 | `#9CF1F0` / `#004F4F` | 7.28:1 |
| `payoutWaiting` (10.3) | 4.5:1 | `#1A1B23` / `#E2E2EC` | 13.33:1 | `#E2E2EC` / `#45464F` | 7.28:1 |
| `unknown` | 4.5:1 | `#1D1A22` / `#E7E0EB` | 13.29:1 | `#E7E0EB` / `#4A4550` | 7.20:1 |
| `text (onSurface on surface)` | 4.5:1 | `#171D1A` / `#F5FBF5` | 16.30:1 | `#DEE4DE` / `#0F1512` | 14.31:1 |
| `secondary text (onSurfaceVariant on card)` | 4.5:1 | `#404944` / `#EFF5EF` | 8.42:1 | `#BFC9C2` / `#171D1A` | 10.06:1 |
| `link text (primary on card)` | 4.5:1 | `#1E6A4F` / `#EFF5EF` | 5.88:1 | `#8CD5B3` / `#171D1A` | 10.01:1 |
| `selected list row (onSecondaryContainer)` | 4.5:1 | `#354B40` / `#CFE9D9` | 7.31:1 | `#CFE9D9` / `#354B40` | 7.31:1 |
| `control outline (outline on surface)` | 3.0:1 | `#707973` / `#F5FBF5` | 4.28:1 | `#8A938D` / `#0F1512` | 5.84:1 |

**Payout statuses (10.3).** `payoutPaid` **reuses the `cyclePaidOut` pair**, because the meaning is the same: the pot was paid out. In [`status_colors.dart`](lib/core/theme/status_colors.dart) both tokens point at one `StatusTone` constant, so the pair is measured once and can't drift, and [`payout_status_chip_test.dart`](test/features/payouts/presentation/payout_status_chip_test.dart) checks they are the same object. `payoutNext` (teal, the one row to look at) and `payoutWaiting` (neutral) are new pairs, measured by the same test as the rest. A payout status the app doesn't know uses `unknown`. [`payoutStatusToken`](lib/features/payouts/presentation/payout_status_chip.dart) is an exhaustive switch with no wildcard, and the chip always says the status in words ("Paid", "Next to be paid", "Waiting").

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

```text
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
| **Sipho Dlamini**, a Member only | **Member**; paid nothing; **R 250,00 arrears** | **Member**; paid nothing (Chairperson until 10.3) | Two cards, both Member, one with arrears |
| **Thabo Nkosi** | not a member | not a member | The empty state |

Also present, as other members only: Nomsa Mabena (Chairperson of Mabena Family, `Confirmed`) and Kagiso Molefe (Treasurer of Soweto Teachers, `Confirmed`). Both cycles are `2026-11`, `Open`, due 30 Nov and 25 Nov.

#### Payouts: the five answers (Assignment 10.3)

Read before any payout type was written, from the API's `README.md`, `openapi/v1.json` and its C# source at **`3d04a52`**, then again at **`da39b16`**, the commit with the backend fix (gap 9 below). The app's contract copy is from `da39b16`.

**1. Which endpoint returns a cycle's payout order, and what does each entry hold?** At `3d04a52`, **none**. The only payout endpoint was `POST /api/v1/stokvels/{stokvelId}/cycles/{cycleId}/payouts`, which records one. Since `da39b16`: `GET /api/v1/stokvels/{stokvelId}/cycles/{cycleId}/payouts` returns `PayoutOrderResponse { stokvelId, cycleId, items[] }`, items in rotation order (members by `JoinedAtUtc`):

| Field | Type | Can be null? | App type |
|---|---|---|---|
| `position` | int32, 1-based | No | `int` (shown, never used to sort) |
| `userId`, `memberName` | uuid, string | No | `String`, `String` |
| `amountCents` | int64 cents: the payout for `Paid`, the cycle's target pot for the rest | No | `Cents` |
| `paidAtUtc` | date-time, an instant | **Yes**: set only for `Paid` | `DateTime?` |
| `status` | string | No | `PayoutStatus`, with `unknown` |

An empty `items` means the cycle has no payout order: it isn't `Open` and had no payout. The app shows that as its own empty state, never as an empty list.

**2. How does the API spell each payout status?** Exactly `Paid`, `Next`, `Waiting` (case matters; `PayoutStatuses` in `API/DTOs/Payouts/PayoutOrderResponse.cs`). OpenAPI types it as plain `string`, as with gap 4, so anything else becomes `PayoutStatus.unknown`, shown as "Status not recognised".

**3. Does the API say who is next?** At `3d04a52`, **no**: `PayoutService.CreatePayoutAsync` picked "the first member by `JoinedAtUtc` with no payout yet" only at the moment of paying, so an app showing who is next would have had to copy that rule. That is the backend fix: the order marks exactly one item `Next`, and `GET` and `POST` share one rotation query (`InRotationOrder`), so `Next` is the member the next payout pays (tested in `PayoutOrderTests.Next_IsExactlyWhomTheNextPayoutPays`). The app doesn't sort the items, count who has been paid, add up the pot or pick the next member: it shows `status` as sent.

**4. What does a non-member get?** **`404`**, a `ProblemDetails`, exactly as for `GET /stokvels/{id}`: `StokvelAuthorization` throws "Stokvel not found." when the caller has no membership. An unknown cycle, or a cycle of another stokvel, is also `404`. The app's fake throws `CycleNotFoundException` for all of them, and the screen says "We couldn't find that cycle." at once, with no retry spinner.

**5. Which role may record a payout, and what does the API answer anyone else?** `POST …/payouts` needs `StokvelManage`: **Treasurer or Chairperson** of *that* stokvel. A Member gets **`403`**, a non-member **`404`** (the API's `AuthorizationMatrixTests` cover both). Any member may *read* the order. In the app, "Record payout" appears on the payouts view only where the 10.1 actions match ([`allowedActions`](lib/features/stokvels/domain/stokvel_actions.dart)) allows it, from that stokvel's membership and its cycle being `Open`. Recording itself arrives in Week 11; the request body is `{ amount }` as a `decimal` in rands (gap 10).

#### Real data: the seven answers (Assignment 11.1)

> **Why these come first.** The app now calls the API, so every rule below is one the app's code follows exactly. Each answer was read from the API's `README.md`, its `openapi/v1.json` and its C# source, then checked with real requests against a freshly seeded API before any networking code was written. Where the API and this list ever disagree, the API is right and this list is a bug.

**Read at:** API commit [`6c52a0e`](https://github.com/mdvar2/RondiTrack/commit/6c52a0e710e350a3333a8d38a2ef51ded2f4afa9) (branch `fix/mobile-contract-gaps`: API PRs #14 and #15 merged), whose `openapi/v1.json` is byte-identical to [`contract/openapi/v1.json`](contract/openapi/v1.json). **Checked with requests at:** [`29c9556`](https://github.com/mdvar2/RondiTrack/commit/29c9556) (branch `feat/mobile-dev-seed`, [API PR #16](https://github.com/mdvar2/RondiTrack/pull/16)), which adds the seed and one fix found while answering question 1. Neither changes the contract document. The bodies the requests returned are kept as the API repository tests' fixtures in [`test/fixtures/api/`](test/fixtures/api/).

| # | Question | The API's answer | What the app does |
|---|---|---|---|
| 1 | How does a page end? A token reused with other filters? | `nextPageToken` is **required and never `null`**: the last page sends **`""`** (and `hasMore: false`). A token used with a different `sortBy`, `sortDirection` or filter is **`400`**, *"Page token does not match the current sort or filter."* **Found:** every second page sorted by a date was a **`500`**; fixed in API PR #16 | The mapper turns `""`, `null` or a missing token into one meaning, "no more pages" (`PageCursor.end`). The app never sends a token with other filters: a repository follows a token only with the query that made it |
| 2 | How is a stale write guarded? | **ETag**, not a body field: `GET /stokvels/{id}` and `GET …/cycles/{cycleId}` send `ETag: "2324"` (the row's `xmin`, quoted). `PUT` needs `If-Match` with it: missing is **`400`**, stale is **`412`**. Closing a cycle is the exception: its preview sends `version` (a 64-hex string, also as the ETag) and the `POST` body carries it back; stale is **`409`** | The ETag is kept exactly as sent, quotes included, as a `ConcurrencyToken` on the stokvel, the cycle and the close preview. `412` is `ConflictFailure` ("changed elsewhere"); a `409` is a `RuleFailure`, with the API's words |
| 3 | How is every status spelled? | Cycle `Open`, `Closed`, `PaidOut`; contribution `Pending`, `Paid`, `Confirmed`; role `Member`, `Treasurer`, `Chairperson`; payout `Paid`, `Next`, `Waiting`. Case matters; OpenAPI types every one as plain `string` | Unchanged from 10.1 and 10.3: each maps to its enum, anything else to `unknown` ("Status not recognised"), never a crash |
| 4 | Refresh cookie, access token lifetime, reuse grace? | Cookie **`__Secure-ronditrack_refresh`**: `HttpOnly`, `Secure`, `SameSite=Strict`, `Path=/api/v1/auth`, 7 days. The access token lasts **5 minutes** (`Jwt:AccessTokenMinutes`, 30 s clock skew). **No reuse grace window**: presenting a used refresh token revokes the whole family at once (`EfRefreshTokenRepository.RotateAsync`) | Today's stand-in keeps the access token **in memory only** and keeps no cookie. After 5 minutes the next call is a `401`, and the person is signed out with "Your session ended. Sign in again." Tomorrow's sign-in reads the cookie by name |
| 5 | Does every error carry `correlationId`, and does the schema say so? | **Every error does**: exception handler, status-code pages, rate limiter, model validation and the `401`/`403` challenges all add it, a 32-hex W3C trace id. **The schema doesn't**: `ProblemDetails` lists only `type`, `title`, `status`, `detail`, `instance`. Validation adds `errors` (field to messages), also unlisted | The error body is read **raw**, never through a generated model: `correlationId`, `detail`, `errors` and `Retry-After` come from the JSON map and the headers |
| 6 | A non-member, and a member without the role? | Non-member, on a stokvel route **or** a treasurer action: **`404`** *"Stokvel not found."*, the same as a stokvel that doesn't exist. Member without the role on a treasurer action (`GET …/close/preview`, any write needing `StokvelManage`): **`403`** *"You do not have permission for this operation."* | `404` is `NotFoundFailure`: "not found" at once, never retried. `403` is `ForbiddenFailure`: a message, and the person stays signed in |
| 7 | Which endpoints are rate limited; does `429` carry `Retry-After`? | `POST /auth/login`: 5 a minute **per IP**, fixed window. Per account, token buckets: recording contributions (30/min), recording payouts (5/min), invite preview and join (10/min). `GET /invites/{code}/status`: 60/min per IP. Every `429` has **`Retry-After` in whole seconds** and a problem body. The login window answers `Retry-After: 60` (its whole window) | `RateLimitedFailure` carries the wait from `Retry-After`, and the person is told it: "Too many attempts. Wait 60 seconds, then try again." No number is typed into the app |

**Measured, for the timeouts and retry policy** (the API with its database unreachable, `GET /me/home`): a closed database port answered **`500` after 19.5 to 21.0 s** (three tries), because EF Core's `EnableRetryOnFailure` tries four times; a database host that never answers took **64.2 s** (four 15 s connection timeouts). Both bodies carried a `correlationId`. See [Decisions](#decisions).

**Other things the requests showed:**

- `POST /invites/{code}/join` answers **`204` with no body**, and a second join is **`409`** *"You are already a member of this stokvel."* The 10.2 fake returned the stokvel's id and changed nothing on a second join. The API repository reads the id from the preview, and a second join is a `RuleFailure` with the API's words (the join screen only offers Join to a non-member, gap 8).
- An unknown path is `404` with *"The requested endpoint was not found."*: the same status as a stokvel the person isn't in, so the app never shows the detail, only "not found".
- `GET /invites/{code}` sends a fixed `schedule` ("Monthly") and `rules` text for every stokvel, not the fakes' per-stokvel words.

**Gaps found in 11.1:**

| # | Gap | Why it matters to the app | Status |
|---|---|---|---|
| 1 | No seed data (from 10.1) | The personas didn't exist in the API | **Fixed** in [API PR #16](https://github.com/mdvar2/RondiTrack/pull/16): a Development-only seed of the fakes' world, run only with `DevSeed:Password` passed at run time, with `DevSeedTests` |
| 11 | Following a date-sorted page token was a `500` | Every cycle's contributions past the first page, and Day 4's infinite scroll | **Fixed** in [API PR #16](https://github.com/mdvar2/RondiTrack/pull/16), with `PageTokenTests` (seen to fail without the fix) |
| 12 | `correlationId` and `errors` aren't in the `ProblemDetails` schema | A generated error model would drop them | Open. The app reads error bodies raw, so nothing is lost; declaring them changes the web client's types too |
| 13 | Join answers `204` with no stokvel id, and `409` for a member | The 10.2 interface promised the id and a harmless second join | Open; handled in the app as described above |
| 14 | `GET …/cycles/{cycleId}` has no `membersPaid`, and its target only as rands (`targetAmount`, a `double`) | The cycle screen shows both | Open. The app takes them from the stokvel's current-cycle summary (`StokvelCycleSummaryResponse`, in cents), which covers every cycle the app links to. For any other cycle it follows the API's own definitions (members with a contribution; collected plus `amountDueCents`). Adding them to the response changes both web clients' types, so it waits for its own pull request |

#### Auth: the seven answers (Assignment 11.2)

> **Why these come first.** Written before any session code, from the API's C# (`AuthController`, `AuthService`, `EfRefreshTokenRepository`, `TokenService`, `RateLimitPolicies`, `InvitesController`, `GlobalExceptionHandler`) and, where those were silent, from `curl -i` against the seeded API on port 8081. The app's auth calls follow this API, not Matric Compass's.

**Read at:** API commit [`6249c4b`](https://github.com/mdvar2/RondiTrack/commit/6249c4b) (branch `fix/mobile-contract-gaps`, after API PR #16). **Gaps fixed in:** [API PR #17](https://github.com/mdvar2/RondiTrack/pull/17) (`1977a2c`, branch `fix/auth-contract-for-mobile`); [`contract/openapi/v1.json`](contract/openapi/v1.json) is that commit's `openapi/v1.json`, byte for byte.

| # | Question | The API's answer | What the app does |
|---|---|---|---|
| 1 | What do register, login, refresh and logout take and return? Does register sign in? | `POST /auth/register` `{name, email, password}` → **`201`** `UserResponse` `{id, name, email, version}`, **no token and no cookie**: register does not sign in. `POST /auth/login` `{email, password}` → `200` `{accessToken, expiresAtUtc}` and the refresh cookie. `POST /auth/refresh` (cookie only, no body) → `200`, the same body and a **new** cookie. `POST /auth/logout` (cookie) → `204` and the cookie cleared | Register, then sign in with the same details at once, so the person lands where sign-in would have taken them |
| 2 | The exact `Set-Cookie`, and the access token's lifetime | `Set-Cookie: __Secure-ronditrack_refresh=<64 random bytes, base64>; expires=<now + 7 days>; path=/api/v1/auth; secure; samesite=strict; httponly`. The access token lasts **5 minutes** (`Jwt:AccessTokenMinutes`); the body's **`expiresAtUtc`** says when, and so does the JWT's `exp` | The name is `REFRESH_COOKIE_NAME` in `config/<flavour>.json`, never in code. The cookie goes back, as a `Cookie` header, only to `/api/v1/auth/refresh` and `/api/v1/auth/logout`. The expiry (the earlier of `expiresAtUtc` and `exp`) drives the early refresh |
| 3 | Does refresh rotate? A spent token? A grace window? | **Rotates**: each refresh marks the token used and issues its successor in the same family. A **used** token presented again is reuse: **`401`** *"Refresh session is invalid. Please sign in again."* and **the whole family is revoked, the newer token too** (checked with curl: the spent token, then the newer one, both `401`). **There is no grace window** in this API (8.2's isn't in any branch; `Housekeeping:RefreshTokenGraceDays` only keeps expired rows for investigation), so there is nothing to turn off: the tests and the live run are always without one | One refresh at a time ([The session](#the-session)); a `401` for a request sent with an older token is retried with the current one, never refreshed again. The fake server in the tests rotates and detects reuse the same way |
| 4 | Which claims are in the access token? Where does a stokvel role come from? | `sub` (user id), `jti`, `iat`, `nbf`, `exp`, `iss`, `aud`. **No role**: `platform_role` is added on the server per request, and stokvel roles come only from memberships (`/me/home`, `/stokvels/{id}`) | Claims are read (not checked) for `exp` only. Treasurer buttons come from the membership, as in 11.1, never from the token |
| 5 | Logout with a good cookie, a spent one, none? | **`204` every time**, with the cookie cleared. A known token (spent or not) revokes **its whole family**; none or an unknown one revokes nothing | Sign-out wipes the phone first, then tells the API with a 5 s timeout, and never depends on the answer |
| 6 | How are login and register rate limited? | Login: **5 a minute per caller address**, fixed window, **successes counted too**; `429` with **`Retry-After: 60`** (the whole window) and a problem body. **Register was not limited at all** (gap 15, fixed in API PR #17: register now shares login's window) | The form shows the wait from `Retry-After` and keeps the button disabled until it ends, on sign-in and register both. The live test signs in four times, inside the five |
| 7 | Joining with a code: success, wrong, expired, already a member? Signed in? | `POST /invites/{code}/join` needs a signed-in person (`401` otherwise). Success **`204`**, no body. Unknown code **`404`** *"Invite not found."*; expired **`410`** *"This invite has expired."* (the preview `GET /invites/{code}` answers the same two first); already a member **`409`** *"You are already a member of this stokvel."* (the join's only `409`). Per-account limit 10/min | Opened signed out, `/join/:code` goes to sign-in and joins once afterwards: success and already-a-member land in the stokvel (the id from the preview); a wrong or expired code says so on the invite screen |

**Gaps found in 11.2** (fixed in [API PR #17](https://github.com/mdvar2/RondiTrack/pull/17), with `RateLimitContractTests.Register_SharesLoginWindow_RejectsWithRetryAfter`; `dotnet test` **196 passed**):

| # | Gap | Why it matters to the app | Status |
|---|---|---|---|
| 15 | `POST /auth/register` had no rate limit | Account creation could flood or probe without limit; the form's 429 wait had nothing to come from | **Fixed**: the Login policy, shared with sign-in, per address |
| 16 | Register declared `200`; it answers `201` | A generated client would read the wrong status | **Fixed**: `201` with `UserResponse` |
| 17 | Register's `400` (with `errors`) and `409`, refresh's `401`, logout's `204` weren't in the contract | The app's contract copy didn't say what the forms must handle | **Fixed**: declared |

#### Gaps found, and backend pull requests

**Backend branch:** [`fix/mobile-contract-gaps`](https://github.com/mdvar2/RondiTrack/compare/assignment-9.3...fix/mobile-contract-gaps) in the API repo, commit `0bb7f92`, based on the contract commit `3d04a52` (branch `assignment-9.3`). **Pull request:** not yet opened; open it at <https://github.com/mdvar2/RondiTrack/pull/new/fix/mobile-contract-gaps> with base `assignment-9.3`, and put its link here.

**Opened in 10.3:** the 10.1 branch is [API PR #14](https://github.com/mdvar2/RondiTrack/pull/14) (base `assignment-9.3`). The 10.3 payout order fix is [API PR #15](https://github.com/mdvar2/RondiTrack/pull/15), stacked on it (base `fix/mobile-contract-gaps`), with its tests in `PayoutOrderTests`.

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
| 9 | No endpoint returned a cycle's payout order, and nothing said who is next (10.3) | The app would have had to sort members and decide who is next: a copy of the server's money rule | **Fixed** in [API PR #15](https://github.com/mdvar2/RondiTrack/pull/15) (`da39b16`): `GET …/cycles/{cycleId}/payouts`, statuses `Paid`, `Next`, `Waiting`, `Next` from the same query `POST` pays from |
| 10 | `CreatePayoutRequest.amount` is a `decimal` in rands, not cents (10.3) | Week 11's "Record payout" must send rands as a decimal | Open. Every amount the app *reads* is cents; changing a write body is a breaking API change, for Week 11 with the form that uses it |

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
| **10.3 Domain** Every payout status the API sends maps; a new one is `unknown`; every status has words | `test/features/payouts/domain/payout_status_test.dart` |
| **10.3 Fake** A non-member gets "not found"; a member gets the order as seeded | `test/features/payouts/data/fake_payout_repository_test.dart` |
| **10.3 Provider** Empty is empty; loading, data and failure each map once; two cycles keep separate state; disposal | `test/features/payouts/presentation/payout_order_provider_test.dart` |
| **10.3 Theme** Each status's token, the reused paid-out pair, the dark tokens in dark mode | `test/features/payouts/presentation/payout_status_chip_test.dart`, `test/core/theme/contrast_test.dart` |
| **10.3 Route** The payouts address in the Stokvels tab, back to the cycle from a cold start, a signed-out link survives sign-in | `test/app/router/payouts_route_test.dart`, `test/app/router/redirect_test.dart` |
| **10.3 Screen** Every state; the order as sent, not re-sorted; the next member highlighted; Treasurer actions follow the membership; 360 dp at 200% text; dark mode | `test/features/payouts/presentation/payouts_screen_test.dart` |
| **10.3 The twist** No switcher in staging or prod; each persona's own world; no frame of the last person after a switch | `test/app/dev/persona_switcher_test.dart`, `test/app/personas_test.dart` |
| **10.3** "Not found" never retried | `test/app/retry_test.dart` |
| **10.3** Every address in the Routes table opens where the table says, and the table is the router's | `test/app/router/routes_table_test.dart` |
| **10.3** Architecture rules, with each exception's reason and end | `test/architecture_test.dart` |

Router-level tests pump the real app ([`app_harness.dart`](test/helpers/app_harness.dart)): router, gate, theme and shell, on fakes with no delay. A cold start is simulated with the platform's initial route, which is where a deep link arrives when it starts the app.

The **10.1 one-frame test** now runs through the router. The picker changes the address, and one frame later Soweto Teachers is loading, with none of Mabena Family's contributions. The 10.1 widget tests that pumped a screen on its own still do. The app smoke test signs Lerato in first, because the app now opens behind the gate.

Widget tests swap repositories with `overrideWithValue`, never by editing a provider. Each test puts its `ProviderScope` directly inside `tester.pumpWidget(…)`. Failure tests pass `retry: (retryCount, error) => null`. Since 10.3 the whole-app harness retries with the app's own `appRetry`, as `main` does, so a "not found" that spins or repeats would show.

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

```text
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
| Recording: `/join/MABENA26` opened signed out, through sign-in, to the invite, then Join | [`07-join-link-signed-out-to-invite.mp4`](docs/evidence/10.2/07-join-link-signed-out-to-invite.mp4),<br>with the result in [`07a-joined-mabena-as-member.png`](docs/evidence/10.2/07a-joined-mabena-as-member.png) (Thabo,<br>Member: Pay only) |
| 360 dp, text at 200%: Home, the stokvel list, a stokvel (top and scrolled to its actions) | [`08-home-360dp-200pct.png`](docs/evidence/10.2/08-home-360dp-200pct.png),<br>[`09-stokvel-list-360dp-200pct.png`](docs/evidence/10.2/09-stokvel-list-360dp-200pct.png),<br>[`10-stokvel-360dp-200pct.png`](docs/evidence/10.2/10-stokvel-360dp-200pct.png),<br>[`10b-stokvel-360dp-200pct-scrolled.png`](docs/evidence/10.2/10b-stokvel-360dp-200pct-scrolled.png) |
| Tablet on its side: list and detail side by side | [`11-tablet-landscape-list-detail.png`](docs/evidence/10.2/11-tablet-landscape-list-detail.png) |
| Tablet upright: the same stokvel, one pane | [`12-tablet-portrait-same-stokvel.png`](docs/evidence/10.2/12-tablet-portrait-same-stokvel.png) |

What the phone showed that the tests don't: go_router receives the whole link (`ronditrack-dev://app/stokvels/…`) as the cold-start route and matches on its path, so the custom scheme and `app` host need no handling in the app. The gate reads only the path, too (`redirect_test.dart` covers a full link). The bottom bar's labels stay smaller than the rest at 200% because Flutter's `NavigationBar` caps their text scaling itself; all four labels stay visible.

#### Assignment 10.3: verification

Run locally on 2026‑11‑15 (Windows, Flutter 3.47.7, Dart 3.13.5), after every commit on the branch:

| Check | Result |
|---|---|
| `dart format --output=none --set-exit-if-changed` (hand-written files) | 0 changed |
| `dart run build_runner build` | Built; generated files unchanged |
| `dart analyze --fatal-infos` | No issues found |
| `flutter test` | **415 passed**, 0 failed (268 from 10.1 and 10.2 still green) |
| `flutter build apk --debug --flavor dev / prod` | Both built and installed side by side |
| CI on the pull request | [run 43762651639](https://github.com/mdvar2/RondiTrackApp/actions/runs/43762651639), every step green |
| API: `PayoutOrderTests` (7), the authorization matrix row, four required fields, the contract test | Green in the API's CI on [PR #15](https://github.com/mdvar2/RondiTrack/pull/15) (run [43756817752](https://github.com/mdvar2/RondiTrack/actions/runs/43756817752)), 179 tests |

**Tests seen to fail.** For five tests, the code each one guards was broken on purpose, the test run, and the code restored:

| Broke | Test | Went red with |
|---|---|---|
| `PayoutStatus.fromApi` compares ignoring case | `payout_status_test.dart` | "the spelling is exact": expected `unknown`, got `paid` for `"paid"` |
| `FakePayoutRepository` without its membership check | `fake_payout_repository_test.dart` | 3 tests: Thabo and nobody got Mabena Family's and Soweto Teachers' orders instead of `CycleNotFoundException` |
| The shell builds the switcher in every flavour (`hasDevTools \|\| true`) | `persona_switcher_test.dart` | 20 tests: "Found 1 widget with type PersonaSwitcherButton" on every staging and prod address |
| `appRetry` retries not-found (`error is Never`) | `retry_test.dart` | 6 tests: a 200 ms retry instead of `null`; the link was asked more than once |
| `Colors.teal` typed into the payouts screen's border | `architecture_test.dart` | "no colour typed outside the theme" listed the line |

**Emulator evidence** (Pixel profile, 1080×2400 at density 420, debug builds), in [`docs/evidence/10.3/`](docs/evidence/10.3/):

| What | File |
|---|---|
| The payouts view as Lerato in Mabena Family, where she is Treasurer: the order as sent, Nomsa paid, Lerato next (highlighted), Sipho waiting, and **Record payout**. Opened by a cold-start deep link, through sign-in | [`01-payouts-lerato-treasurer.png`](docs/evidence/10.3/01-payouts-lerato-treasurer.png) |
| The same view as Sipho, a Member: the same order, no action | [`02-payouts-sipho-member.png`](docs/evidence/10.3/02-payouts-sipho-member.png) |
| Home as Thabo, in no stokvel: what to do next | [`03-home-thabo-empty.png`](docs/evidence/10.3/03-home-thabo-empty.png) |
| The persona switcher, open, in the dev build | [`04-switcher-dev.png`](docs/evidence/10.3/04-switcher-dev.png) |
| Home as Lerato: dev with the switcher button, prod without it | [`05a-home-dev-with-switcher.png`](docs/evidence/10.3/05a-home-dev-with-switcher.png), [`05b-home-prod-no-switcher.png`](docs/evidence/10.3/05b-home-prod-no-switcher.png) |
| Prod's sign-in, with no test accounts | [`06-signin-prod-no-test-accounts.png`](docs/evidence/10.3/06-signin-prod-no-test-accounts.png) |
| Recording: Lerato with Mabena Family open ("Your role: Treasurer", treasurer actions) switches to Sipho, through sign-in, back to Mabena Family as a Member | [`07-switch-lerato-to-sipho-mabena-open.mp4`](docs/evidence/10.3/07-switch-lerato-to-sipho-mabena-open.mp4) |

What the phone showed that the tests don't: after the switch, the dev build lands on the same address as the new person without anyone navigating, because the gate remembered it at sign-out. In prod, a person has to type an email, as there is no test-account list to tap.

---

## Part 9: Still open

*What is not done yet.*

### Still open

> **What this section is.** The honest list of what isn't done yet, so nothing missing is hidden.

- [x] Open the backend pull request (link above) and link it here and in the app PR: [API PR #14](https://github.com/mdvar2/RondiTrack/pull/14), and the 10.3 fix [API PR #15](https://github.com/mdvar2/RondiTrack/pull/15).
- [x] Open the "Assignment 10.1: Foundations and State" pull request and wait for its green run: [#3](https://github.com/mdvar2/RondiTrackApp/pull/3), merged into `main`.
- [ ] Gaps 1, 2, 4, 7 and 8 in "Contract notes" are open, with reasons.
- [ ] iOS flavours and iOS deep links (need Xcode on a Mac).
- [ ] 10.3: the empty payout order (a cycle that isn't open and had no payout) is tested with a scripted repository, but no seed cycle shows it: both seed cycles are open. Week 11's real API, or a closed seed cycle, would show it on a phone.
- [ ] 10.3: Record payout says "coming soon"; the request body is rands as a `decimal` (contract gap 10).
- [ ] 10.3 stretch goals not attempted: the switcher listing what it cleared, a contract check for the fakes, a second Dart 3 refactor.
- [ ] Stretch goals not attempted: every route as every persona in one test, a dev-only theme gallery, predictive back, a real App Link.
- [ ] 11.1: Gaps 12, 13 and 14 in "Contract notes" are open, with reasons.
- [ ] 11.1: the architecture exceptions that read `signedInUserIdProvider` and `demoAccountsProvider` from presentation are still listed as ending in Week 11; they end with tomorrow's sign-in, which gives the session its own home.
- [ ] 11.1: the writes (pay, confirm, close, record payout) still say "coming soon"; the close screen shows the preview a close would send back.
- [x] 11.1 stretch: a nightly contract check, and one request id end to end (the app's `traceparent`, the API's `correlationId`). Not attempted: the fakes checked against the schema, staging over HTTPS for real.

---

## Part 10: Real data (Assignment 11.1)

*The app on its own API: the client, the failures, the swap, and how to run it.*

### Running against the API

> **In plain words.** The dev build now talks to the RondiTrack API running on your laptop, signed in as one of the three seed personas. These are the steps from nothing.

**1. The API, on a fresh seed** (in the API repository, branch `feat/mobile-dev-seed` or later, [API PR #16](https://github.com/mdvar2/RondiTrack/pull/16)). The API's user secrets hold the PostgreSQL connection and JWT key (API README "Configure the API"). The mobile seed uses its own database, so your usual development data is untouched:

```powershell
cd ..\RondiTrack
# Point the API at a database of its own for the seed (the same server and login as your user secret).
$env:ConnectionStrings__RondiTrackDb = 'Host=localhost;Port=5432;Database=ronditrack_mobile;Username=<user>;Password=<password>'
# A fresh seed: drop and recreate that database.
dotnet ef database drop --force --project Infrastructure --startup-project API
dotnet ef database update --project Infrastructure --startup-project API
# The seed password is yours to choose, kept outside both repositories. Never commit it.
$env:DevSeed__Password = '<seed password>'
dotnet run --project API --launch-profile http -- --urls http://localhost:8081
```

The log says `Development seed created.` The seed runs only in Development and only with a password. Port **8081**, not 5101: on this machine Windows reserves 5041–5140 once Docker Desktop is running (`netsh int ipv4 show excludedportrange protocol=tcp`).

**2. The phone (or emulator) reaches the laptop over USB** with `adb reverse`, so the dev flavour's address, `http://127.0.0.1:8081` in [`config/dev.json`](config/dev.json), is the laptop's API. No LAN address or firewall rule is needed:

```powershell
adb reverse tcp:8081 tcp:8081
```

**3. The dev flavour, with the seed password passed in at run time:**

```powershell
flutter run --flavor dev --dart-define-from-file=config/dev.json --dart-define=SEED_PASSWORD=<seed password>
```

Sign in with a test account (or the persona switcher). `--dart-define=DATA_SOURCE=fakes` runs the dev build on the Week 10 fakes instead.

**4. The live test**, against the same API (it signs in three times; the login limit is five a minute per IP):

```powershell
$env:SEED_PASSWORD = '<seed password>'
flutter test --tags live --run-skipped
```

### The API client

> **In plain words.** The app doesn't hand-write HTTP calls. A tool reads the API's contract (its OpenAPI document) and writes a typed client for exactly the calls the app makes. Two CI checks make sure that client, the contract copy and the real API never drift apart.

- **Generated with swagger_parser 1.45.1** from [`contract/openapi/v1.json`](contract/openapi/v1.json), for only the paths in `include_paths` of [`swagger_parser.yaml`](swagger_parser.yaml) (the 11 the app calls), into [`lib/core/data/generated/`](lib/core/data/generated/), and committed. Every call returns its `HttpResponse`, so a repository can read the `ETag`.
- **Regenerate it** (the generator never deletes a file it stopped writing, so the folder goes first):

  ```powershell
  Remove-Item -Recurse -Force lib\core\data\generated
  dart run swagger_parser
  dart run build_runner build
  ```

- **Generated types stop in `data/`.** A mapper per feature ([`home_mapper.dart`](lib/features/home/data/home_mapper.dart), [`stokvel_mapper.dart`](lib/features/stokvels/data/stokvel_mapper.dart), and the payout and invite mappers beside their repositories) turns each into a domain type: statuses and roles into the 10.1 enums with `unknown`, amounts into `Cents`, instants in UTC, due dates as `CalendarDate`, the ETag kept exactly as sent (`ConcurrencyToken`), and the end marker `""` as "no more pages" ([`api_values.dart`](lib/core/data/api_values.dart)). The architecture test fails if any presentation or domain file imports Dio, Retrofit or anything in `core/data/`.

**The two CI checks** ([`ci.yml`](.github/workflows/ci.yml)):

| Check | Compares | Fails on |
|---|---|---|
| **The client matches the contract copy** (job `verify`) | The committed client with what swagger_parser and build_runner generate again from the committed `contract/openapi/v1.json`, after deleting the folder | Any changed, deleted **or new untracked** file under `lib/core/data/generated` (`git status --porcelain --untracked-files=all`) |
| **Contract copy matches the API** (job `contract`) | `contract/openapi/v1.json` with `openapi/v1.json` in [mdvar2/RondiTrack](https://github.com/mdvar2/RondiTrack) at `fix/mobile-contract-gaps` (public, so no token), or at the branch given by the workflow input `api_ref` (Actions → CI → Run workflow) | Any difference (`diff -u`). It also runs nightly, so an API change turns the app red within a day |

### Failures

> **In plain words.** Every way a call can fail becomes one value of one type, `Failure`, and each kind decides its own words. Screens never look at status codes. Only [`toFailure`](lib/core/data/to_failure.dart) does, once, in `core/`.

| The API says | `Failure` | Retried? | The person sees |
|---|---|---|---|
| `400` (validation; also a page token reused with other filters) | `ValidationFailure`, with `detail` and each field's `errors` | No | The API's words |
| `401` on a call | `UnauthorisedFailure` | No | Signed out, and sign-in says **"Your session ended. Sign in again."** |
| `401` signing in | `UnauthorisedFailure(atSignIn: true)` | No | **"That email and password don't match an account."** |
| `403`, a treasurer action opened by a Member | `ForbiddenFailure` | No | **"Your role in this stokvel doesn't allow that. Only its treasurer or chairperson can do it."** They stay signed in |
| `404`, a stokvel or cycle they aren't in, or one that doesn't exist | `NotFoundFailure` | No | **"We couldn't find that stokvel."** (or cycle, or invite) at once, with no spinner. Never "you don't have access" |
| `409` (a business rule, a stale close preview), `410` (an expired invite) | `RuleFailure`, with `detail` | No | The API's words |
| `412`, a stale `If-Match` | `ConflictFailure` | No | **"This changed somewhere else. Reload it and try again."** |
| `429`, the login limit | `RateLimitedFailure`, with `Retry-After` | No | **"Too many attempts. Wait 60 seconds, then try again."** The number is the API's |
| `500` (or any other status), a proxy's HTML `502`, a body the models can't read | `ServerFailure`, with `correlationId` (or the trace id the app sent) | No | **"Sorry, something went wrong on our side. If it keeps happening, quote the reference."** and the reference, selectable, with a copy button, until they act. Never the API's message or a stack trace |
| No answer (offline, refused, a timeout) | `NoAnswerFailure` | **Yes**: 3 times, after 1, 2 and 4 s | **"You're offline, or we couldn't reach the server."** with **Try again** |

Calls awaited together (a cycle's stokvel, cycle and contributions) that fail arrive as a `ParallelWaitError`; `toFailure` takes the most telling of its failures, so a `404` among them is still not found. The words live on each `Failure` ([`failure.dart`](lib/core/errors/failure.dart)); a screen only names *what* wasn't found.

**The reference** is the API's `correlationId`, the W3C trace id of the request. The app sends its own `traceparent` on every request, and the API adopts it, so even an answer with no body has a reference. The app's log line and the API's log carry the same id:

```text
App:  API GET /api/v1/stokvels/5d0c…0101/cycles/9e8f…0201/close/preview 403 in 49 ms [correlationId 50f1f433e45663c4111f982d98d0a9a4]
API:  Request rejected with 403 (ForbiddenException). CorrelationId: 50f1f433e45663c4111f982d98d0a9a4
```

**The log line** ([`ApiLogInterceptor`](lib/core/data/api_client.dart)) is the method, the path (never the query), the status, the time and the trace or correlation id. Never a header (the token), a cookie, a body, a name or an amount: under POPIA a member's amounts, arrears and name are personal information. Dio's own `LogInterceptor` prints request headers, so it isn't used.

### Decisions

| Decision | What, and why |
|---|---|
| **`Result` is a sealed class** | `Ok(value)` or `Err(failure)` ([`result.dart`](lib/core/errors/result.dart)). A record such as `(T?, Failure?)` can hold both or neither, and a switch over it can't prove every case was handled; a sealed class has exactly two cases, and the compiler checks both. Providers unwrap with `valueOrThrow`, so Riverpod holds the `Failure` in an `AsyncError` |
| **Generated models, not hand-written freezed** | swagger_parser and json_serializable, from the contract copy, checked by CI. Hand-written models would be a second copy of the contract that nothing checks. The error body is the one thing read raw: the contract's `ProblemDetails` lists none of `correlationId`, `errors` |
| **Timeouts: connect 10 s, send 10 s, receive 30 s** | Measured with the API's database unreachable (`GET /me/home`, three tries each): a closed database port answered `500` after **19.5 to 21.0 s** (EF Core's `EnableRetryOnFailure` tries four times); a database host that never answers took **64.2 s** (four 15 s connection timeouts). Receive at 30 s lets the API's own 20 s `500`, with its reference, arrive, instead of the app giving up first. The 64 s case is cut off and shown as no answer. Connect and send are short: the API is one hop away, and every body is a few hundred bytes |
| **Retry only "no answer"** | [`appRetry`](lib/app/retry.dart) is a rule over `Failure` types: `NoAnswerFailure` three times, after 1, 2 and 4 s; everything else never. Every 4xx is final. A 500 isn't retried either: the API already retries its database (measured above), so three more tries in the app would be a minute of spinner. Only providers retry, and every provider reads: no write is retried |
| **The access token in memory only** | [`AccessTokenHolder`](lib/core/data/api_client.dart), gone at sign-out or when the app stops; the API's 5 minutes, with no refresh until tomorrow's sign-in. No storage, no cookie jar |
| **One switch for fakes** | `dataSourceProvider`, `DataSource.api` by default. The Week 10 whole-app tests override it once, in the harness, and pass as before |

### Assignment 11.1: verification

- `dart format` clean (hand-written files), `dart analyze --fatal-infos`: **No issues found!**, `flutter test`: **all passing**, the live test skipped.
- The live test against a fresh seed, through the app's own providers: **4 passed** (output in the pull request).
- API: `dotnet test` **195 passed** with Docker running ([API PR #16](https://github.com/mdvar2/RondiTrack/pull/16)).

**Three tests seen to fail.** For each, the code it guards was broken and the test went red, then the change was reverted:

| Broke | Test that went red |
|---|---|
| `home_screen.dart` imports `package:dio/dio.dart` | `architecture_test.dart`: "no presentation or domain file imports Dio or the generated client" (and "no screen imports … Dio"), naming `home_screen.dart:1` |
| The log line uses `request.uri` instead of `request.uri.path` | `api_client_test.dart`: "the log line leaves nothing personal in it": `API GET http://127.0.0.1:8081/api/v1/me/home?userId=lerato-secret-query 200 …` |
| `AuthInterceptor` ends the session on a `403` as well as a `401` | `api_client_test.dart`: "a 403 signs nobody out, and keeps the token": expected no ended session, got one |

#### Assignment 11.1: phone evidence

The dev flavour, a **release** build (so INTERNET in `main/` is what reaches the API), on a Huawei MAO-LX9 (Android 12), against the API on a fresh seed through `adb reverse`:

| What | Screenshot |
|---|---|
| Lerato's Home, from the API: Treasurer of Mabena Family, Member of Soweto Teachers, the API's own figures | [`01-home-lerato-real-data.png`](docs/evidence/11.1/01-home-lerato-real-data.png) |
| Lerato opening a link to Molefe Burial Society, a real stokvel she isn't in: "not found" at once | [`02-not-found-stokvel-she-isnt-in.png`](docs/evidence/11.1/02-not-found-stokvel-she-isnt-in.png) |
| Sipho, a Member, opening Mabena Family's Close cycle link: the 403 message, still signed in (the tabs stay) | [`03-forbidden-member-treasurer-action.png`](docs/evidence/11.1/03-forbidden-member-treasurer-action.png) |
| A persona switch after the login limit was spent: the wait, from `Retry-After` | [`04-rate-limited-wait.png`](docs/evidence/11.1/04-rate-limited-wait.png) |
| Thabo's Home, from the API: in no stokvel | [`06-home-thabo-empty.png`](docs/evidence/11.1/06-home-thabo-empty.png) |
| A server failure: Lerato opens Soweto Teachers while the API's database is unreachable. The apology and the reference, copyable; the same id is in the API's log (below) | [`05-server-failure-reference.png`](docs/evidence/11.1/05-server-failure-reference.png) |
| The twist, red run 1: the cross-repo check pointed at the API branch that renamed `stokvelName` ([run 44257434382](https://github.com/mdvar2/RondiTrackApp/actions/runs/44257434382)): "The contract copy drifted from the API" | [`07-twist-red-1-contract-drift.png`](docs/evidence/11.1/07-twist-red-1-contract-drift.png) |
| The twist, red run 2: the contract copied and the client generated ([run 44258167649](https://github.com/mdvar2/RondiTrackApp/actions/runs/44258167649)): the analyser names `lib/features/home/data/home_mapper.dart#L17` | [`08-twist-red-2-analyser-names-mapper.png`](docs/evidence/11.1/08-twist-red-2-analyser-names-mapper.png) |

**The server failure, phone and API side by side.** The API was restarted on the same port with `ronditrack_mobile`'s connection string on a closed port (5499), so its database was unreachable; Lerato's token, signed by the same key, stayed valid. The phone showed reference `18cadb3ff15682f5b3f1686316572e9b` after about 20 s. The API's log, for that id:

```text
fail: RondiTrack.Handlers.GlobalExceptionHandler[0]
      Request failed with 500. CorrelationId: 18cadb3ff15682f5b3f1686316572e9b
      Microsoft.EntityFrameworkCore.Storage.RetryLimitExceededException: The maximum number of retries (3) was exceeded while executing database operations with 'NpgsqlRetryingExecutionStrategy'. See the inner exception for the most recent failure.
       ---> Npgsql.NpgsqlException (0x80004005): Failed to connect to 127.0.0.1:5499
       ---> System.Net.Sockets.SocketException (10061): No connection could be made because the target machine actively refused it.
```

The id appears once: the app didn't retry the `500`. The outage log has one other `500` (`0e3d8248…`), Home's `/me/home`, asked for at the same moment by the stokvel screen's picker. The API was then restarted on `ronditrack_mobile` as normal; the development database (`ronditrack`) was never used: it has none of the seed's users or stokvels, and its migrations are unchanged.

What the phone showed that the tests don't: the login limit is per address, and `curl localhost` on Windows goes over IPv6 (`::1`), a different bucket from the phone's `127.0.0.1` through `adb reverse`; spending the limit for the screenshot needed `curl 127.0.0.1`.

---

## Part 11: Sign-in (Assignment 11.2)

*A real session: register, sign in, a restart, one refresh, and a sign-out that leaves nothing behind on a phone a family shares.*

### The session

> **In plain words.** Signing in gives the app two tokens. The **access token** goes on every request and works for 5 minutes. The **refresh token** gets a new access token when the old one runs out, and is itself replaced each time. The app keeps the first only in memory and the second encrypted on the phone, and is careful to swap the second for a new one exactly once, because the API treats a swapped-out token used again as stolen and ends the session.

**Where each token lives**

| Token | Where | Never |
|---|---|---|
| Access token, with its expiry | In memory, in [`Session`](lib/core/session/session.dart) ([`AccessToken`](lib/core/session/access_token.dart)) | On disk, in a log line (its `toString` leaves it out), in an error message, in a crash report |
| Refresh token | `flutter_secure_storage` (Android: encrypted with a Keystore key), behind [`RefreshTokenStore`](lib/core/session/refresh_token_store.dart); tests use `InMemoryRefreshTokenStore` | Sent to anything but `/auth/refresh` and `/auth/logout`, or logged |

The refresh token is read from `Set-Cookie` **by hand**, by the name in the flavour's config (`REFRESH_COOKIE_NAME`; a config without it refuses to start, like a missing base URL), in [`cookieFrom`](lib/core/data/set_cookie.dart). A sign-in answer without it is an error. The app keeps no cookie jar: `HttpOnly`, `Secure` and `SameSite` are a browser's instructions, so keeping the cookie off every other request is the app's own job ([`AuthCalls`](lib/core/data/auth_calls.dart) is the only code that sends it).

**When a refresh happens.** One interceptor owns the session, [`SessionInterceptor`](lib/core/data/session_interceptor.dart):

- **Before a request**, if the token expires within **30 s** (the margin), it refreshes first: no `401` needed. If no token is in memory but one is stored (the app was just opened), it refreshes first too.
- **On a `401`**, it refreshes once and sends that request again once.
- **Single flight**: while a refresh runs, every other request that needs one awaits the same one. A `401` for a request sent with a token that has since been replaced is sent again with the new token, and nothing is refreshed: the "was this sent with the current token?" check that a `QueuedInterceptor` alone doesn't give.
- **The refresh and the retry go through a second client** (`bareClientProvider`: a trace id and the log line, no session interceptor), so neither can wait on the interceptor that is waiting for them, and a retry's own `401` is final.

**What ends a session, and what doesn't.** Only the **refresh endpoint's own `401`** (spent, revoked, expired or unknown token). A `403`, a `429`, a `500` or no answer never signs anyone out: the request fails with that failure, and the session stays.

**On launch: one refresh.** [`AuthController`](lib/features/auth/presentation/auth_controller.dart) starts in `Restoring` (a sealed state with three cases: `SignedOut`, `Restoring`, `SignedIn`; the compiler lists every `switch` that has to decide what restoring means). While restoring, every address waits on [`/splash`](lib/features/auth/presentation/splash_screen.dart), remembering where it was going, so the sign-in form never flashes for a signed-in person and a link survives. A refused refresh is signed out; a good one lands on the remembered screen. **No signal is not signed out**: the splash says so, with **Try again** and **Sign out** (from 11.3, cached stokvels instead).

**What sign-out wipes**, first, before the network: the access token (at once, before any `await`), the stored refresh token, and the auth state. Every user-scoped provider follows the auth state: the repositories watch `signedInUserIdProvider`, and every provider holding stokvels, cycles, contributions or arrears is autoDispose and leaves with the shell, so nothing is cleared by hand one by one. Then `POST /auth/logout` with the old cookie, cut off after **5 s**. A refresh that finishes after sign-out signs nobody back in: every sign-in and sign-out moves the session's epoch on, and a refresh from an older epoch stores nothing (`RefreshOutlived`).

**Signing in.** [Sign-in](lib/features/auth/presentation/sign_in_screen.dart) and [register](lib/features/auth/presentation/register_screen.dart), with the 10.2 theme: the API's field errors under their fields, an address already in use under the email, a refused sign-in only *"That email and password don't match an account."*, and a `429` that says how long to wait and disables the button until then. The dev build's persona switcher only fills in the email; the password is typed. The dev build's Profile adds two **session tools**: *Spoil access token* and *Expire it now*. Staging and prod have neither (tested).

**The join link.** `/join/:code` opened signed out goes (through the splash, from a cold start) to sign-in or register, which remember the join as the form is sent ([`PendingJoin`](lib/features/invites/presentation/pending_join.dart)); the invite screen takes it once and joins. Back, a rotation or a rebuild never join again.

**Android backup is off**: `android:allowBackup="false"`, `fullBackupContent="false"`, and [data extraction rules](android/app/src/main/res/xml/data_extraction_rules.xml) excluding everything from cloud backup and phone-to-phone transfer (Android 12+ ignores `allowBackup` for the latter). A restored copy of the encrypted token would be useless without its Keystore key, and on a shared phone it is somebody's session.

### Running against the API: what changed in 11.2

- **No seed password is passed in, in any flavour.** Step 3 of [Running against the API](#running-against-the-api) is now just `flutter run --flavor dev --dart-define-from-file=config/dev.json`; the app no longer reads `SEED_PASSWORD` (a `--dart-define` of it is ignored). Sign in by typing the password, or choose a test account to fill in the email.
- `config/<flavour>.json` has **`REFRESH_COOKIE_NAME`**; without it the app refuses to start.
- **The grace window:** this API has none (Contract notes › Auth, question 3), so there is nothing to turn off. The live test checks reuse detection as it is.
- **The live test** reads the password from the test run's environment only, and signs in **four** times (login and register share 5 a minute per address); run it once a minute at most:

  ```powershell
  $env:SEED_PASSWORD = '<seed password>'
  flutter test --tags live --run-skipped
  ```

- API: branch `fix/auth-contract-for-mobile` ([API PR #17](https://github.com/mdvar2/RondiTrack/pull/17)) or later.

### Decisions (11.2)

| Decision | What, and why |
|---|---|
| **Dio, not the generated client, for the four auth calls** | The generated client does return headers (`HttpResponse`), but its methods take no per-call header, and the refresh token must go out as a `Cookie` on exactly refresh and logout, and the calls must run on the bare client. So [`AuthCalls`](lib/core/data/auth_calls.dart) calls Dio directly, with the **generated models** (`LoginRequest`, `RegisterRequest`, `AccessTokenResponse`, `UserResponse`) for every body |
| **Backup off, not excluded** | Nothing in the app is worth restoring onto another phone: the token can't be decrypted there, and 11.3's cache belongs to whoever was signed in. Off is simpler to check than a list of exclusions |
| **Refresh margin: 30 s** | Of the API's 5 minutes: longer than a slow request's round trip on mobile data plus the API's 30 s clock skew allowance is generous, and short enough that a token is used for 90% of its life. A request near the end is refreshed first, with no `401` |
| **Sign-out timeout: 5 s** | Sign-out never waits for it (the state changes first); it only bounds how long the app keeps trying to tell the API |
| **Dependency overrides** | `flutter_secure_storage` 11.2.0 (2026-09-16) pulls `path_provider_android`, whose newest `jni` 1.2.1 (2026-11-19) and `jni_flutter` 1.1.0 (2026-11-18) were under two weeks old on 2026-11-22. Held back to **`jni` 1.1.2** (2026-11-03) and **`jni_flutter` 1.0.4+1** (2026-10-06), in `pubspec.yaml`'s `dependency_overrides`. **Remove both on or after 2026-12-03**, once `flutter pub get` without them picks nothing under two weeks old. Every other package in `pubspec.lock` was published by 2026-11-08 |

### Assignment 11.2: verification

- `dart format` clean (hand-written files), `dart analyze --fatal-infos`: **No issues found!**, `flutter test`: **all passing**, the live test skipped.
- The live test against the seeded API: **5 passed**. The spoiled token: three `401`s, **one** refresh, three retries; the spent refresh token refused, and the newer one after it; after sign-out, the old refresh token refused. Output in the pull request.
- API: `dotnet test` **196 passed** ([API PR #17](https://github.com/mdvar2/RondiTrack/pull/17)).

**What each new test proves**

| Layer | Test |
|---|---|
| Cookie and claims | [`set_cookie_test.dart`](test/core/data/set_cookie_test.dart): the cookie found by its configured name among several `Set-Cookie` lines, a response without it an error, the name in no `lib/` file; claims read from a token whose signature nobody checked |
| Session | [`session_test.dart`](test/core/session/session_test.dart), over [`FakeAuthServer`](test/helpers/fake_auth_server.dart), which rotates and detects reuse like the API: three requests, one refresh (and the same with a token past its expiry, with no `401`); an old-token `401` retried without a refresh; **the plain interceptor that refreshes per `401` trips reuse detection**; a refused refresh ends the session once; no answer, `403`, `429` and `500` don't; a retry's `401` is final; the cookie only to refresh and logout; a late refresh after sign-out ignored; the log shows `401`s, one refresh, retries and no token |
| Auth state | [`auth_state_test.dart`](test/features/auth/auth_state_test.dart): restore with a good, a refused, no stored token and no network (then Try again); sign-in stores the refresh token; sign-out with a network, without, and slow; a late restore after sign-out ignored; a sign-in at launch not overruled by the launch's restore |
| Router and screens | [`redirect_test.dart`](test/app/router/redirect_test.dart) (restoring: every route to the splash, remembered); [`auth_screens_test.dart`](test/features/auth/auth_screens_test.dart): the splash and never the form while restoring, the offline splash, a wrong password, the `429` wait, register's field errors and address in use; no session tools in staging and prod |
| Whole app | [`family_phone_test.dart`](test/app/family_phone_test.dart): Lerato, her Treasurer stokvel, sign-out, Thabo: none of her providers exist and none of her stokvels are on screen; the join link opened signed out from a cold start joins once (and after register), a member lands in the stokvel, a wrong code says so |

**Three tests seen to fail.** Each break was made, the test run, and the change reverted:

| Broke | Test that went red |
|---|---|
| Single flight: `Session.refresh` calls `_refresh()` each time instead of sharing `_refreshing` | "three requests, one refresh against a server that rotates and detects reuse": `Expected: [200, 200, 200]`, `Actual: [DioException … status code of 401 …` (reuse detection revoked the family) |
| The epoch check before storing a refresh's answer removed | "a refresh that finishes after sign-out signs nobody back in": `Expected: <Instance of 'RefreshOutlived'>`, `Actual: ServerFailure` |
| `AuthController.signOut` awaits the API before changing the state | "sign-out with a slow network: signed out and wiped before the API answers": `Expected: <Instance of 'SignedOut'>`, `Actual: <Instance of 'SignedIn'>` |

The live run also found one real bug the unit tests had missed, now fixed with a test: a sign-in sent before the launch's restore had run was overruled by it.

#### Assignment 11.2: phone evidence

The dev flavour, a **debug** build (so the app's log lines reach logcat, the Run console), on a Huawei MAO-LX9 (Android 12), against the seeded API through `adb reverse`, in [`docs/evidence/11.2/`](docs/evidence/11.2/):

| What | Evidence |
|---|---|
| Lerato signed in with a typed password: her Home from the API | [`01-home-lerato-signed-in.png`](docs/evidence/11.2/01-home-lerato-signed-in.png) |
| Stopped (`am force-stop`, as Android Studio's Stop) and reopened: the splash, never the form, then Home; one refresh, then `/me` | [`02a-splash-restoring-after-stop.png`](docs/evidence/11.2/02a-splash-restoring-after-stop.png), [`02b-restored-home-after-stop.png`](docs/evidence/11.2/02b-restored-home-after-stop.png), [`02-restore-run-console.txt`](docs/evidence/11.2/02-restore-run-console.txt) |
| Spoil access token, then a cycle opened by link: **four `401`s, one refresh, the retries** | [`03a-spoil-access-token.png`](docs/evidence/11.2/03a-spoil-access-token.png), [`03b-cycle-after-spoiled-token.png`](docs/evidence/11.2/03b-cycle-after-spoiled-token.png), [`03-spoiled-token-run-console.txt`](docs/evidence/11.2/03-spoiled-token-run-console.txt) |
| Secure storage (`shared_prefs/FlutterSecureStorage.xml`, read with `run-as`, the file Device Explorer shows): one encrypted `session.refresh` entry while signed in; `<map />` after sign-out | [`04a-secure-storage-signed-in.txt`](docs/evidence/11.2/04a-secure-storage-signed-in.txt), [`04b-secure-storage-after-sign-out.txt`](docs/evidence/11.2/04b-secure-storage-after-sign-out.txt) |
| Reopened with the API unreachable: the offline splash, still signed in; Try again once it was back: Home | [`05a-offline-splash.png`](docs/evidence/11.2/05a-offline-splash.png), [`05b-try-again-signed-in.png`](docs/evidence/11.2/05b-try-again-signed-in.png) |
| The family phone: Lerato's Treasurer stokvel; sign out; Thabo signs in on the same phone: his Profile, his empty Home, nothing of hers | [`06a`](docs/evidence/11.2/06a-family-phone-lerato-treasurer-stokvel.png), [`06b`](docs/evidence/11.2/06b-family-phone-signed-out.png), [`06c`](docs/evidence/11.2/06c-family-phone-thabo-profile.png), [`06d`](docs/evidence/11.2/06d-family-phone-thabo-home.png) |
| Register's field errors under their fields; a wrong password; the `429` wait with the button disabled | [`07a-register-field-errors.png`](docs/evidence/11.2/07a-register-field-errors.png), [`07b-wrong-password.png`](docs/evidence/11.2/07b-wrong-password.png), [`07c-429-wait.png`](docs/evidence/11.2/07c-429-wait.png) |
| `ronditrack-dev://app/join/SOWETO26` opened signed out: sign-in; after it, **one** join and Soweto Teachers, as a Member | [`08a-join-link-signed-out.png`](docs/evidence/11.2/08a-join-link-signed-out.png), [`08b-join-link-after-sign-in-in-the-stokvel.png`](docs/evidence/11.2/08b-join-link-after-sign-in-in-the-stokvel.png), [`08-join-run-console.txt`](docs/evidence/11.2/08-join-run-console.txt) |

**Offline, honestly:** the phone reaches the laptop's API through `adb reverse`, so airplane mode would not have cut it. The route was removed instead (`adb reverse --remove tcp:8081`): the same "no answer" the app gets in airplane mode.

**Found on the phone:** register's password error was cut to one line ("The length of '…"); the forms now let an error wrap (`errorMaxLines`), as the screenshot shows.
