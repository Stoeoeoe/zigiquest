# ZigiQuest

**Sammle. Zähle. Räume auf.** ZigiQuest is an Android-first, offline-first Flutter cleanup tracker. It turns quick, exact cigarette-butt logging into a restrained game with a physical jar, cleanup sessions, XP, quests, milestones, history, private optional location/photos, and eventual private backup. No account is required.

## What is implemented

- Material 3 navigation for Today, History, Quests, and Settings
- Drift as the local authority; exact non-negative count updates and atomic session/day writes
- Sync outbox with bounded batches and exponential retry; Supabase failure never blocks local use
- Flame + Forge2D jar with at most 40 active bodies and deterministic logarithmic baked fill up to 100,000+
- Daily/weekly quests, nonlinear levels, XP, milestones, and cosmetic unlock records
- Local history and `fl_chart` daily aggregation
- Active-session foreground GPS tracking for `approximate` and `route` modes, with permission requested only after explicit selection; route samples are simplified and capped before local storage
- JPEG processing with orientation normalization, resize, re-encode (metadata stripping), iterative quality/dimension reduction, and a hard 200 KB result
- Before/after session photo attachment from camera or gallery, local thumbnails, transactional persistence, and private upload outbox records
- Shareable rendered achievement cards that exclude route and coordinate data
- Versioned JSON file import with three merge modes and CSV/JSON export (settings UI currently copies exports to the clipboard)
- Foreground connectivity-triggered and Android WorkManager background outbox sync, cloud-photo usage display, a signed-URL gallery, and individual or bulk remote-backup deletion
- Optional Supabase initialization using compile-time environment values

## Setup

Prerequisites: Flutter 3.38.5+ with Android SDK/JDK configured, and optionally Supabase CLI.

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format .
flutter analyze
flutter test
flutter build apk --debug
```

Run locally without a backend with `flutter run`. For cloud features:

```sh
supabase link --project-ref YOUR_REF
supabase db push
flutter run --dart-define=SUPABASE_URL=https://PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=KEY
```

Never commit real keys. `.env.example` documents the names; Flutter receives them through `--dart-define`.

## Google sign-in setup

The app includes Google OAuth through Supabase. To activate it, create a Google **Web application** OAuth client, enter its client ID and secret in Supabase Auth → Providers → Google, and add `zigiquest://auth/callback` to Supabase Auth → URL Configuration → Redirect URLs. The Android manifest already registers this private callback scheme and the account screen opens the OAuth flow in the browser. The project URL and publishable/anon key still need to be supplied via `--dart-define`.

## Background sync

Android WorkManager schedules a network-constrained outbox retry every 24 hours in addition to foreground sync. Android decides the precise execution time and may defer it for battery or system policy; a failed task requests retry with WorkManager backoff.

## Supabase and privacy

`supabase/migrations/202607120001_initial.sql` creates every user table, check/unique constraints, RLS, the private `session-photos` bucket, owner-path storage policies, and an authenticated account-deletion RPC. Every relational policy compares `auth.uid()` to the row owner. Storage is restricted to `users/{userId}/sessions/{sessionId}/{photoId}.jpg`, JPEG, 200 KB, with no public reads. Inspect policies in the Supabase dashboard after applying the migration.

Drift writes happen first. Mutations enqueue JSON outbox records. Signed-in clients can send up to 50 changed records per batch; failures record an error and exponentially delayed retry. Daily/session conflict resolution is record-level latest-update-wins. Active quests and progression are derived locally to avoid additive merge double-counting.

Location defaults to off. Approximate values are rounded to 2–3 decimals; exact samples are collected only during an active foreground session, never in the background. Route simplification caps stored points. The Android manifest requests only foreground coarse/fine permissions; the UI does not request them at launch. Achievement exports never include routes or exact coordinates.

Imported photos are decoded, orientation-baked, resized, and freshly JPEG-encoded, stripping EXIF/GPS metadata. Only the derivative is retained. Upload requires authentication, enabled cloud backup, connectivity, ownership, ≤200 KB, two-photo limit, and room in the 25 MB app-side quota.

## Cost controls

Local reads/writes and charts avoid backend queries. Sync is batched with no polling or realtime subscriptions. Photos are private, capped and compressed; there is no public feed, server transform, or automatic full-resolution upload. Costs can still grow with database/storage size, egress, authentication volume, compute, and excessive multi-device synchronization.

## Physics

The Forge2D simulation creates only the newest 40 Zigis and uses sleeping physics. Older items become a stable, procedural baked mass; the active hard cap is below 60. Reduced-motion mode uses only the static renderer. The game has no repository, navigation, Drift, or Supabase access.

## Placeholder assets

`assets/placeholders/README.txt` lists replaceable `park_background`, `badge_art`, and `container_skins`. These use Material icons/neutral blocks in the UI. Replace them with optimized PNG/WebP assets and register filenames in `pubspec.yaml`. The functional jar and seven color/rotation variants are drawn directly; there are no giant SVGs.

## Tests

Tests cover count persistence/non-negativity, progression thresholds, milestones, deterministic approximation/route caps, JSON validation/merge, and core UI zero state. Database tests use in-memory Drift.

## Known limitations

Google OAuth requires your Google Cloud client credentials and enabling the Google provider in your Supabase project; these cannot be provisioned from the app repository. Background sync is best-effort because Android controls scheduled work. The production vessel has four selectable glass colorways but no alternate container shape yet. The app has no background location, public feed, public URLs, social features, or unsupported environmental-impact claims.

## Zigi sprite pipeline

The 12 production Zigi PNGs live in `assets/zigis/`. `tool/generate_zigi_sprite_data.dart` scans pixels above the alpha threshold, calculates a convex hull, simplifies it to Forge2D's maximum safe eight vertices, and writes normalized render/collision data to `lib/features/visualization/zigi_sprite_data.dart`. Run `dart run tool/generate_zigi_sprite_data.dart` whenever the source sprites change. Collision generation is a development step, not an app-startup cost.



