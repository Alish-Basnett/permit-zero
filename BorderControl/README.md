# Border Control

A "Papers, Please"-inspired border-inspection game for iOS, built with SwiftUI.

You work the Grennsford checkpoint. Each day the rulebook grows: check
passport expiration, then entry permits, then banned nationalities, then
cross-document name matching, then wanted bulletins. Approve or deny each
traveler, meet your daily quota, and pay rent at day's end — or your
family's health suffers. Survive all 5 days to complete your contract.

## Project layout

```
BorderControl/
  project.yml              XcodeGen spec (generates the .xcodeproj)
  Sources/
    App/                    App entry point + root view router
    Models/                 Document types, Applicant, DayRules, GameState
    Data/                   Per-day rule configs, procedural applicant generator
    Engine/                 RuleEngine: checks an applicant against the day's rules
    Story/                  Lightweight dialogue system between days
    Views/                  SwiftUI screens (booth, rulebook, stamps, summaries)
  Resources/
    Info.plist
    Assets.xcassets/        Placeholder app icon slot — add real artwork here
```

## Building (on a Mac, with Xcode 15+)

This project uses [XcodeGen](https://github.com/yonaskolb/XcodeGen) instead of
a checked-in `.xcodeproj`, so the project file is always generated fresh and
never goes stale or conflicts in git.

```sh
brew install xcodegen
cd BorderControl
xcodegen generate
open BorderControl.xcodeproj
```

Then select an iPhone simulator and hit Run (⌘R).

## Game design notes

- **Escalating rules**: `Sources/Data/DaysData.swift` defines the ruleset for
  each of the 5 days (quota, rent, which documents are required, banned
  nationalities, wanted bulletins). Add a new `case` there (and a matching
  `StoryData.beat`) to extend the game past day 5.
- **Solvable by construction**: `ApplicantGenerator` seeds at most one
  violation per traveler, and only ever seeds violations the current day's
  rules can actually catch — so every case has a clear, checkable answer.
- **Story beats**: `Sources/Story/StoryData.swift` holds the dialogue shown
  before each day, including two choices (day 3 and day 4) that trade money
  or family well-being for suspicion.
- **Extending documents**: to add a new document type (e.g. a diplomatic
  authorization or grant of asylum), add a struct in `Models/Document.swift`,
  a field on `Applicant`, a rule flag on `DayRules`, a check in
  `RuleEngine.evaluate`, generation logic in `ApplicantGenerator`, and a card
  in `DocumentCardView`.

## Shipping to TestFlight

Building/signing/uploading requires **macOS + Xcode** — do this from a Mac.
The steps below are ordered so nothing blocks the first upload. Items marked
**(portal)** happen in a browser, separately from the Xcode project.

**Before the first archive:**

1. **(portal)** Register the **App ID / bundle identifier** in the Apple
   Developer portal (Certificates, Identifiers & Profiles → Identifiers).
2. **(portal)** Create the **App Store Connect app record** (My Apps → +):
   name, bundle ID, SKU. Both #1 and #2 are separate from Xcode and each
   block upload if missing.
3. **(portal)** Create an **App Store Connect API key** (Users and Access →
   Integrations → Keys, **App Manager** role). Authenticate uploads with this
   key instead of Apple ID + password — it skips 2FA and makes uploads fully
   scriptable (`xcrun altool`/`notarytool`, `xcodebuild -exportArchive`, or
   Fastlane can all use it).
4. In `project.yml`, set `PRODUCT_BUNDLE_IDENTIFIER` (and `bundleIdPrefix`) to
   match the bundle ID from #1, then re-run `xcodegen generate`.
5. Open the project, enable **"Automatically manage signing"** and pick your
   team. Manual certs/profiles are the #1 first-time time-sink — avoid unless
   you have a specific reason.
6. App icon is already included — a 1024×1024 icon ships in
   `AppIcon.appiconset`, with its editable source at
   `Resources/AppIcon.source.svg` (re-render with headless Chromium or any
   SVG→PNG tool if you tweak it). Swap in your own artwork anytime.

**Already handled in this repo:**

- `ITSAppUsesNonExemptEncryption = false` is set (in `project.yml` properties
  and `Info.plist`) — skips the export-compliance prompt on every upload. If
  you ever add custom encryption, revisit this.
- No camera/location/mic/etc. are used, so **no `NSUsageDescription` strings
  are needed**. If you add any such API, its usage-description string is
  mandatory or the binary is rejected at validation — add it to `project.yml`
  properties (not just `Info.plist`, which XcodeGen overwrites on generate).

**Each upload:**

- **Bump the build number** (`CURRENT_PROJECT_VERSION`) every time — it must
  strictly increase; you can't reuse one even after a failed upload.
- Archive (Product → Archive), then upload via the Organizer.
- Processing takes **~5–15 min** before the build is selectable.
- **Internal testing** (your own team, ≤100 people) is available immediately,
  no review. **External** groups need a one-time Beta App Review (~24h) — use
  internal for your own device today.

## Known gaps / good next steps

- No persistence — progress resets when the app is killed.
- No sound/haptics on stamping.
- App icon is a generated placeholder (passport + approval stamp); swap in
  final artwork when you have it.
- Only 5 days of content; the real game's depth comes from many more days
  and document types, which this scaffold is structured to make easy to add.
