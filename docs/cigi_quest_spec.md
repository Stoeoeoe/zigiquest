# Codex One-Shot Implementation Specification

## ZigiQuest — Gamified Cigarette-Butt Cleanup Tracker

> **Execution instruction for Codex:** Implement the complete application described below in the current repository. Do not stop after scaffolding. Do not return only snippets or an architecture proposal. Create and modify the actual project files, run code generation, format the code, execute static analysis and tests, and fix issues until the project is coherent and buildable. Make reasonable engineering decisions where this specification leaves minor details open. Do not ask for clarification unless a missing external secret or unavailable tool makes progress impossible.

---

# 1. Product summary

Create an Android-first Flutter application named **ZigiQuest**.

The app helps users track how many discarded cigarette butts they collect while cleaning public spaces. The Swiss term **“Zigi”** is used intentionally as part of the product identity.

ZigiQuest must not feel like a generic counter. It should feel like a small real-world cleanup game:

- users collect cigarette butts;
- they log them quickly;
- each logged butt drops into a visual container using physics;
- users complete cleanup sessions;
- users earn XP;
- users complete quests;
- users unlock cosmetic rewards;
- users can optionally record an approximate route or location;
- users can optionally attach private photos to cleanup sessions;
- all core functionality works offline;
- Supabase provides account, backup, sync, and private cloud storage.

The app must not require an account to function locally.

The initial target is Android. Keep the architecture portable enough that iOS support would not require rewriting the domain and data layers.

---

# 2. Product principles

Prioritize these goals in this order:

1. Reliable counting and persistence
2. Fast interaction
3. Offline-first behavior
4. Satisfying visual feedback
5. Privacy
6. Controlled backend cost
7. Clear historical insights
8. Maintainable code
9. Battery and rendering efficiency
10. Visual polish

The locally stored count is authoritative while offline.

The physics visualization is derived state and must never be the sole source of truth.

The app must remain usable if:

- Supabase is unavailable;
- the user is logged out;
- photo upload fails;
- GPS permission is denied;
- the physics engine fails to initialize.

---

# 3. Scope

## 3.1 Required for the first complete implementation

Implement:

- Flutter Android project;
- Material 3;
- bottom navigation;
- Today screen;
- cleanup sessions;
- History screen;
- Quests screen or quest section;
- Settings screen;
- local Drift database;
- Riverpod state management;
- go_router navigation;
- Flame + Forge2D visualization;
- charts with fl_chart;
- XP and levels;
- daily and weekly quests;
- cosmetic unlock model;
- optional GPS session tracking;
- optional private session photos;
- local image compression to 200 KB or less;
- Supabase authentication;
- Supabase Postgres sync;
- Supabase private storage;
- anonymous/local-first onboarding;
- optional account linking;
- CSV export;
- JSON export;
- JSON import;
- light, dark, and system themes;
- accessibility labels;
- unit, database, and widget tests;
- README;
- setup instructions for Supabase;
- SQL migrations and Row Level Security policies;
- no unresolved TODOs in required functionality.

## 3.2 Explicitly out of scope

Do not implement:

- public social feed;
- public image gallery;
- public maps;
- comments;
- direct messaging;
- likes;
- followers;
- public profiles;
- leaderboards;
- public route sharing;
- moderation dashboard;
- advertisements;
- subscriptions;
- payments;
- push notifications;
- background location when no cleanup session is active;
- image recognition;
- automated content moderation;
- environmental claims not grounded in configurable assumptions;
- tobacco branding;
- GPS tracking without explicit session-level user consent.

---

# 4. Product identity

Use:

```text
App name: ZigiQuest
Tagline: Sammle. Zähle. Räume auf.
```

The product tone should be:

- playful;
- restrained;
- encouraging;
- not childish;
- not moralizing;
- not competitive by default;
- not guilt-based.

The app should not imply smoking endorsement.

---

# 5. Technical stack

Use the latest mutually compatible stable versions available in the environment.

Required technologies:

| Concern                | Technology                                                    |
| ---------------------- | ------------------------------------------------------------- |
| Framework              | Flutter stable                                                |
| Language               | Dart with sound null safety                                   |
| UI                     | Material 3                                                    |
| Navigation             | `go_router`                                                   |
| State management / DI  | `flutter_riverpod`                                            |
| Immutable state/models | `freezed`, `json_serializable` where useful                   |
| Local persistence      | `drift` with SQLite                                           |
| Backend                | Supabase                                                      |
| Authentication         | Supabase Auth                                                 |
| Remote relational data | Supabase Postgres                                             |
| Cloud file storage     | Supabase Storage                                              |
| Backend access control | Row Level Security                                            |
| Physics                | `flame`, `flame_forge2d`                                      |
| Charts                 | `fl_chart`                                                    |
| Images                 | maintained image picker package                               |
| Image processing       | maintained Dart image package or native-compatible compressor |
| Location               | `geolocator` or equivalent maintained package                 |
| Route rendering        | lightweight custom path or map package only if needed         |
| File paths             | `path_provider`                                               |
| Sharing                | `share_plus`                                                  |
| File import            | maintained file picker package                                |
| Formatting             | `intl`                                                        |
| IDs                    | UUID package                                                  |
| Connectivity           | maintained connectivity package                               |
| Testing                | `flutter_test`, `mocktail` or equivalent                      |
| Lints                  | `flutter_lints` plus stricter rules                           |

Do not introduce:

- Firebase;
- a second database ORM;
- a second state management framework;
- a service locator in addition to Riverpod;
- a second navigation framework;
- another game engine.

---

# 6. High-level architecture

Use a feature-oriented layered architecture.

Recommended layout:

```text
lib/
  app/
    app.dart
    bootstrap.dart
    router.dart
    theme/
  core/
    database/
    sync/
    network/
    errors/
    result/
    logging/
    time/
    permissions/
    images/
    location/
    widgets/
  features/
    onboarding/
    auth/
    today/
    sessions/
    history/
    quests/
    progression/
    visualization/
    export_import/
    settings/
  main.dart
```

Maintain these boundaries:

- UI does not access Drift directly;
- UI does not call Supabase directly;
- Flame game does not access repositories;
- repositories expose domain models;
- sync logic is separate from local storage;
- local database remains usable independently of Supabase;
- GPS and image services are behind interfaces;
- Supabase-specific DTOs do not leak into presentation;
- visual assets are independent from game state;
- image compression occurs before upload.

Use pragmatic SOLID principles.

Do not create ceremonial classes for trivial one-line behavior.

---

# 7. Local-first data strategy

The app must work fully without login.

## 7.1 Local authority

Drift is the immediate source of truth for:

- today’s count;
- historical entries;
- cleanup sessions;
- quests;
- XP;
- levels;
- unlocks;
- settings;
- pending sync operations;
- local photo metadata;
- local GPS route data;
- visualization state.

Every user action writes locally first.

## 7.2 Remote backup and sync

Supabase is used for:

- account identity;
- cross-device backup;
- remote synchronization;
- private photo storage;
- remote session and count backup.

Sync is eventual, not blocking.

## 7.3 Outbox pattern

Implement a local sync outbox.

Each mutation creates or updates an outbox operation.

Suggested fields:

```text
id
entity type
entity id
operation type
payload
created at
attempt count
last error
next retry time
status
```

Sync states:

```text
pending
syncing
failed
completed
```

Retry with exponential backoff.

Do not block local usage because sync failed.

---

# 8. Authentication model

## 8.1 First launch

The user can use the app immediately without registration.

Local data must not depend on an account.

## 8.2 Optional account

Offer:

- email magic link or email/password;
- Google sign-in if practical;
- anonymous Supabase auth only if supported cleanly in the chosen setup;
- otherwise local guest mode until explicit signup.

Do not force login.

## 8.3 Linking and migration

When the user signs in:

- associate existing local data with the authenticated user;
- upload unsynced data;
- preserve local state;
- detect conflicts;
- provide deterministic merge behavior.

## 8.4 Sign-out

Signing out must not delete local data automatically.

Explain that remote sync pauses.

## 8.5 Account deletion

Provide account deletion flow.

It must:

- delete remote user-owned database rows;
- delete remote photos;
- sign out;
- optionally ask whether local data should also be deleted.

---

# 9. Supabase schema

Create SQL migrations under a dedicated Supabase directory.

Recommended structure:

```text
supabase/
  migrations/
  seed.sql
  README.md
```

## 9.1 Tables

### profiles

```text
id uuid primary key references auth.users(id)
created_at timestamptz
updated_at timestamptz
display_name text nullable
xp bigint not null default 0
level integer not null default 1
```

### daily_collections

```text
id uuid primary key
user_id uuid not null
date_key date not null
count integer not null
created_at timestamptz not null
updated_at timestamptz not null
deleted_at timestamptz nullable
unique(user_id, date_key)
```

### cleanup_sessions

```text
id uuid primary key
user_id uuid not null
started_at timestamptz not null
ended_at timestamptz nullable
count integer not null
duration_seconds integer nullable
distance_meters double precision nullable
location_mode text not null
approximate_latitude double precision nullable
approximate_longitude double precision nullable
route_polyline text nullable
notes text nullable
created_at timestamptz not null
updated_at timestamptz not null
deleted_at timestamptz nullable
```

### session_photos

```text
id uuid primary key
user_id uuid not null
session_id uuid not null
storage_path text not null
photo_type text not null
width integer not null
height integer not null
size_bytes integer not null
created_at timestamptz not null
deleted_at timestamptz nullable
```

### quest_progress

```text
id uuid primary key
user_id uuid not null
quest_key text not null
period_key text not null
progress integer not null
target integer not null
completed_at timestamptz nullable
claimed_at timestamptz nullable
created_at timestamptz not null
updated_at timestamptz not null
unique(user_id, quest_key, period_key)
```

### unlocks

```text
id uuid primary key
user_id uuid not null
unlock_key text not null
unlocked_at timestamptz not null
unique(user_id, unlock_key)
```

### milestones

```text
id uuid primary key
user_id uuid not null
milestone_key text not null
achieved_at timestamptz not null
unique(user_id, milestone_key)
```

### user_settings

```text
user_id uuid primary key
theme_mode text not null
haptics_enabled boolean not null
sound_enabled boolean not null
reduced_motion boolean not null
selected_container_style text not null
cloud_photo_backup_enabled boolean not null
location_default_mode text not null
updated_at timestamptz not null
```

## 9.2 Soft deletion

Use soft deletion where sync conflicts may occur.

Rows with `deleted_at != null` are considered deleted.

Local and remote sync must propagate tombstones.

## 9.3 Row Level Security

Enable RLS on every user-owned table.

Policies must enforce:

```sql
auth.uid() = user_id
```

Users may only:

- select their own rows;
- insert rows with their own `user_id`;
- update their own rows;
- delete or soft-delete their own rows.

Do not permit public reads.

---

# 10. Supabase Storage

Use a private bucket:

```text
session-photos
```

Storage path:

```text
users/{userId}/sessions/{sessionId}/{photoId}.jpg
```

Rules and policies must ensure:

- authenticated users only;
- owner-only read;
- owner-only upload;
- owner-only delete;
- no public bucket access;
- files only under the authenticated user’s path.

The app must use signed URLs or authenticated private downloads.

Do not store original full-resolution images remotely.

---

# 11. Photo model

## 11.1 Supported photo types

Per cleanup session allow:

- one optional “before” photo;
- one optional “after” or “achievement” photo.

Maximum two photos per session.

## 11.2 Privacy

Photos are private.

No other user can browse them.

Do not build a public feed.

Sharing happens through the Android share sheet.

## 11.3 Local image processing

Before local persistence or remote upload:

1. read image;
2. normalize orientation;
3. strip EXIF metadata;
4. remove embedded GPS metadata;
5. resize;
6. compress;
7. verify final size;
8. save processed derivative;
9. discard temporary working files.

## 11.4 Image size limit

Every stored or uploaded processed image must be:

```text
<= 200 KB
```

Use iterative compression.

Suggested algorithm:

1. resize longest edge to max 1600 px;
2. encode JPEG around quality 75;
3. if over 200 KB, reduce quality in steps;
4. if still over 200 KB, reduce dimensions;
5. repeat until <= 200 KB;
6. enforce a sensible minimum dimension;
7. reject with a useful error only if compression cannot reach the limit.

Prefer JPEG for photographs.

Use WebP only if platform and package behavior is reliable and thoroughly tested.

Store actual:

```text
width
height
size bytes
```

## 11.5 Local storage

Store compressed files in app-private storage.

Do not depend on gallery access after import.

## 11.6 Upload behavior

Only upload when:

- user is signed in;
- cloud photo backup is enabled;
- network is available;
- file size <= 200 KB;
- photo belongs to the authenticated user’s session.

Failed uploads remain queued.

## 11.7 Photo quota

Implement a configurable per-user cloud photo quota.

Initial app-side quota:

```text
25 MB per user
```

At 200 KB maximum this allows roughly 125 photos.

Before upload:

- calculate currently known remote usage;
- block upload if quota would be exceeded;
- show clear UI;
- allow deleting older cloud photos.

The quota is an application control, not a billing guarantee.

---

# 12. GPS and location

## 12.1 Location modes

Per cleanup session support:

```text
none
approximate
route
```

Default:

```text
none
```

## 12.2 Permission model

Request location permission only when user explicitly enables a location mode.

Do not request location on first launch.

Do not require background location permission.

## 12.3 Approximate mode

Store:

- rounded latitude;
- rounded longitude;
- optional area label derived locally or through a future service.

Round coordinates enough to avoid exact-address precision.

Suggested precision:

```text
2 to 3 decimal places
```

Keep exact internal values only if required during the active session, then discard them after deriving the approximate value.

## 12.4 Route mode

Track only while a cleanup session is active and the app is in the foreground.

Store a simplified route.

Requirements:

- sample conservatively;
- reduce noise;
- simplify points;
- avoid excessive battery use;
- cap maximum point count;
- store encoded polyline or compact JSON;
- pause when session pauses;
- stop immediately when session ends.

Do not track in the background in v1.

## 12.5 Route privacy

Exact routes remain private.

Do not include route coordinates in exported share cards.

When generating share content, use:

- approximate place name;
- distance;
- duration;
- count.

---

# 13. Domain models

## 13.1 DailyCollection

```dart
@freezed
class DailyCollection with _$DailyCollection {
  const factory DailyCollection({
    required String id,
    required LocalDate date,
    required int count,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required SyncStatus syncStatus,
  }) = _DailyCollection;
}
```

## 13.2 CleanupSession

```dart
@freezed
class CleanupSession with _$CleanupSession {
  const factory CleanupSession({
    required String id,
    required DateTime startedAt,
    DateTime? endedAt,
    required int count,
    Duration? duration,
    double? distanceMeters,
    required LocationMode locationMode,
    ApproximateLocation? approximateLocation,
    EncodedRoute? route,
    String? notes,
    required List<SessionPhoto> photos,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required SyncStatus syncStatus,
  }) = _CleanupSession;
}
```

## 13.3 App settings

Persist:

```text
themeMode
hapticsEnabled
soundEnabled
reducedMotion
selectedContainerStyle
cloudPhotoBackupEnabled
defaultLocationMode
```

## 13.4 Progression

Persist:

```text
totalXp
level
completedQuests
claimedRewards
unlocks
milestones
```

---

# 14. Navigation

Bottom destinations:

1. Today
2. History
3. Quests
4. Settings

A cleanup session may open as a full-screen route.

Use a shell route or equivalent persistent navigation structure.

---

# 15. Today screen

## 15.1 Purpose

Primary fast-entry screen.

## 15.2 Layout

Include:

- current date;
- today’s count;
- central physics container;
- +1 button;
- -1 button;
- exact count entry;
- start cleanup session;
- daily quest progress;
- all-time total;
- level and XP progress.

## 15.3 Increment

On `+1`:

1. update local count immediately;
2. persist locally;
3. enqueue sync;
4. trigger one visual butt;
5. update quest progress;
6. update XP if applicable;
7. run haptic if enabled;
8. update milestone state;
9. save visualization state after settling.

Rapid taps must remain exact.

## 15.4 Decrement

On `-1`:

- never go below zero;
- update local count;
- enqueue sync;
- reverse one visual object;
- recalculate affected quest progress;
- do not revoke already claimed milestone rewards unless specifically designed.

## 15.5 Exact number entry

Use a dialog or bottom sheet.

For large count changes:

- update exact count;
- regenerate compressed pile;
- do not spawn thousands of bodies.

## 15.6 Reset today

Require confirmation.

Only today’s count changes.

---

# 16. Cleanup sessions

## 16.1 Session flow

```text
Start Cleanup
→ choose location mode
→ optionally add before photo
→ live session screen
→ increment count
→ end session
→ optionally add after photo
→ session summary
→ award XP and quest progress
```

## 16.2 Live session screen

Show:

- elapsed time;
- session count;
- optional distance;
- optional compact route preview;
- physics pile;
- +1;
- -1;
- pause;
- finish.

## 16.3 Session summary

Show:

- collected count;
- duration;
- distance;
- approximate area;
- before/after photos;
- XP earned;
- quests completed;
- milestones;
- generated achievement card;
- share action.

## 16.4 Session and daily count relationship

Session count contributes to the matching daily total.

Avoid double counting.

Use one atomic local transaction.

---

# 17. Physics visualization

## 17.1 Product role

The pile is the app’s primary visual hook.

Use Flame and Forge2D.

## 17.2 Rendering boundary

Expose a reusable widget:

```dart
ZigiPileView(
  scope: ZigiPileScope.today,
  count: count,
  seed: seed,
  containerStyle: style,
  reducedMotion: reducedMotion,
)
```

The game receives commands through a narrow interface:

```text
setCount
addOne
removeOne
rebuild
pause
resume
```

The game must not call Drift, Supabase, Riverpod, or navigation.

## 17.3 Container

Initial production container:

```text
glass jar
```

Future cosmetic containers may include:

- bucket;
- recycling tub;
- metal bin;
- wheelie bin;
- cleanup cart;
- dumpster.

Only one container must be fully polished in v1.

Additional container art can be placeholders.

## 17.4 Zigi variants

Provide at least seven variants.

Variants may differ in:

- length;
- filter color;
- ash tip;
- bend;
- stain;
- collision profile;
- scale.

Use simple custom drawing for basic shapes.

## 17.5 Complex image placeholder rule

For any complex visual asset, Codex must use a clearly labeled placeholder asset rather than generating enormous SVG markup or huge inline vector paths.

Complex assets include:

- detailed backgrounds;
- illustrated badges;
- elaborate container skins;
- character mascots;
- achievement illustrations;
- detailed app-store artwork;
- complicated maps;
- decorative scene art;
- large multi-layer icons.

Allowed placeholder approaches:

- simple colored rectangle;
- simple geometric icon;
- small basic SVG;
- text label such as `PLACEHOLDER: Park Background`;
- lightweight generated PNG;
- neutral gradient block;
- simple icon from Material symbols.

Do not generate:

- enormous SVG files;
- thousands of path commands;
- massive base64 assets;
- procedural illustration code spanning hundreds of lines;
- complex pseudo-art embedded directly in Dart.

Basic visuals that are central to functionality should still be implemented:

- jar outline;
- simple Zigi shapes;
- collision fixtures;
- particles;
- chart graphics;
- basic achievement card layout.

Create an `assets/placeholders/` directory and document every placeholder in the README.

## 17.6 Spawn behavior

Each new Zigi:

- uses seeded variation;
- appears above the jar;
- falls;
- rotates;
- collides;
- settles;
- triggers subtle impact;
- creates limited ash particles.

## 17.7 Body budget

Never simulate all objects.

Use:

### Active bodies

- newest 20–40;
- hard cap about 60.

### Static surface bodies

- 20–50;
- support incoming collisions.

### Baked mass

- all older items;
- deterministic procedural fill;
- no active physics.

## 17.8 Performance

- fixed timestep;
- sleeping enabled;
- capped particle count;
- pause hidden game;
- persist only after settle/debounce;
- no per-frame database writes;
- support totals at least 100,000.

## 17.9 Determinism

For a given:

```text
scope
count
seed
container style
visualization version
```

the regenerated static pile should be stable.

---

# 18. Gamification

## 18.1 Core loop

```text
Collect
→ log
→ watch pile grow
→ complete quest
→ gain XP
→ level up
→ unlock cosmetic reward
```

## 18.2 XP

Suggested XP sources:

```text
1 XP per Zigi
session completion bonus
daily quest reward
weekly quest reward
milestone reward
```

Keep values configurable.

## 18.3 Levels

Use a nonlinear progression curve.

Example:

```text
Level 1: 0 XP
Level 2: 100 XP
Level 3: 250 XP
Level 4: 500 XP
...
```

Keep calculation in a dedicated progression service.

## 18.4 Quests

Required quest types:

- collect N today;
- collect N this week;
- complete one cleanup session;
- complete several active days;
- collect N in one session;
- maintain a short streak.

Quests are generated locally and do not require a server.

## 18.5 Daily quests

Generate 2–3 daily quests.

Use deterministic generation based on:

```text
user seed
date
quest version
```

## 18.6 Weekly quests

Generate 2–3 weekly quests.

## 18.7 Unlocks

Initial cosmetic unlock categories:

- container style;
- jar label;
- particle style;
- background;
- badge frame.

Only the default container must have final art.

Other unlocks may use placeholders.

## 18.8 Milestones

Suggested thresholds:

```text
1
10
25
50
100
250
500
1000
2500
5000
10000
```

Milestone messages must avoid unsupported environmental claims.

---

# 19. History screen

Show:

- all-time total;
- current week;
- current month;
- best day;
- average per active day;
- current streak;
- longest streak;
- total cleanup sessions;
- total cleanup time;
- total recorded distance.

## 19.1 Time ranges

Support:

- 7 days;
- 30 days;
- current month;
- current year;
- all time.

## 19.2 Charts

Required:

1. daily bar chart;
2. cumulative line chart;
3. weekly totals;
4. monthly totals;
5. session count over time.

Use aggregation for large ranges.

## 19.3 Daily history list

Reverse chronological.

Allow editing past counts.

## 19.4 Session history

Show:

- date;
- count;
- duration;
- distance;
- approximate area;
- photo thumbnails;
- sync status.

---

# 20. Quests screen

Show:

- current level;
- XP progress;
- active daily quests;
- active weekly quests;
- completed quests;
- unlocked cosmetics;
- milestone gallery.

Allow claiming rewards if claim mechanics are used.

Avoid introducing multiple currencies.

Use XP only.

---

# 21. Achievement cards

Generate shareable achievement cards locally.

Include:

- optional after photo;
- count;
- duration;
- distance;
- approximate place;
- ZigiQuest branding;
- date;
- level or milestone.

Do not include:

- exact route;
- exact GPS coordinates;
- account email;
- internal IDs.

Export card as image and invoke Android share sheet.

Use placeholder decorative art if needed.

---

# 22. Export and import

## 22.1 CSV

Export:

```csv
date,count,created_at,updated_at
```

Sort ascending by date.

## 22.2 JSON

Use a versioned envelope.

Include:

- daily entries;
- cleanup sessions;
- settings;
- quests;
- progression;
- unlocks;
- milestones.

Do not include:

- authentication secrets;
- signed URLs;
- original images;
- remote storage internals.

Photos may be referenced by metadata only.

## 22.3 Import

Support JSON import.

Merge modes:

- replace all;
- keep existing;
- imported values win.

Validate fully before applying.

Use one local transaction.

Remote sync happens afterward.

---

# 23. Settings

## Appearance

- system;
- light;
- dark;
- reduced motion.

## Feedback

- haptics;
- sound.

## Location

- default location mode;
- permission status;
- privacy explanation.

## Photos

- cloud photo backup toggle;
- current cloud usage;
- 25 MB quota display;
- delete remote photos.

## Account

- sign in;
- link account;
- sign out;
- delete account.

## Data

- sync status;
- retry failed sync;
- export CSV;
- export JSON;
- import JSON;
- reset local data;
- reset all local and remote data.

## About

- version;
- privacy statement;
- open-source licenses.

---

# 24. Offline sync conflict strategy

Use field-level or record-level last-write-wins with safeguards.

Recommended rules:

## Daily counts

Resolve by latest `updated_at`.

## Cleanup sessions

Resolve by latest `updated_at`.

## Photos

Treat as immutable after upload.

Deletion wins when tombstone is newer.

## Settings

Latest update wins per settings record.

## Progression

Recompute from authoritative local domain data where possible rather than trusting conflicting totals.

## Quests

Recompute active quests locally.

Preserve claimed reward records.

Do not merge counts by summing records for the same day, because that can double count.

---

# 25. Security and abuse controls

Implement:

- RLS on all tables;
- private storage bucket;
- authenticated storage paths;
- owner-only access;
- max two photos per session;
- max 200 KB each;
- supported MIME types only;
- app-side quota;
- rate-aware upload queue;
- no public URLs;
- short-lived signed URLs;
- EXIF stripping;
- no public UGC;
- no public image listing.

Supabase does not remove the need for validation.

The client must validate before upload.

Database constraints must also validate critical fields.

---

# 26. Cost-control design

The app must be designed to remain within free-tier usage for a small beta.

Implement:

- local-first reads;
- local-first writes;
- batched sync;
- no polling loops;
- no realtime subscriptions unless necessary;
- no realtime listener per row;
- compressed photos <= 200 KB;
- max two photos per session;
- 25 MB cloud quota per user;
- no automatic full-resolution upload;
- no public image feed;
- no image transformations on the server;
- no unnecessary signed URL refresh;
- thumbnail reuse;
- cleanup of deleted storage objects;
- sync only changed records;
- avoid remote chart queries when local data exists.

Do not assume the backend is free forever.

Document where costs can grow:

- storage;
- egress;
- database size;
- auth volume;
- compute;
- excessive synchronization.

---

# 27. Accessibility

Implement:

- semantic labels;
- minimum touch targets;
- support large font sizes;
- reduced motion;
- screen-reader count updates;
- logical focus order;
- accessible chart summaries;
- no color-only meaning.

Suggested labels:

```text
Add one collected Zigi
Remove one from today’s count
127 Zigis collected today
Start cleanup session
```

---

# 28. Error handling

Handle:

- Drift initialization failure;
- Supabase unavailable;
- auth failure;
- sync failure;
- upload failure;
- quota exceeded;
- image compression failure;
- GPS denied;
- GPS unavailable;
- malformed import;
- unsupported import version;
- visualization failure;
- chart data failure.

Fallback behavior:

- counting remains available;
- sessions remain local;
- photos remain local;
- sync retries later;
- visualization falls back to static rendering.

---

# 29. Riverpod providers

Suggested providers:

```text
databaseProvider
supabaseClientProvider
clockProvider
connectivityProvider
dailyCollectionRepositoryProvider
cleanupSessionRepositoryProvider
questRepositoryProvider
progressionRepositoryProvider
settingsRepositoryProvider
photoRepositoryProvider
locationServiceProvider
syncServiceProvider
todayControllerProvider
sessionControllerProvider
historyControllerProvider
questControllerProvider
authControllerProvider
themeModeProvider
```

Avoid unnecessary global mutable state.

---

# 30. Performance requirements

Required:

- rapid taps remain exact;
- no dropped increments;
- hidden game paused;
- body hard cap;
- image compression off the UI thread where possible;
- route sampling conservative;
- local charts computed outside build;
- sync batched;
- no broad rebuild per physics frame;
- no database write per frame;
- no full remote reload for every app open;
- totals of 100,000 supported;
- hundreds of sessions supported;
- photo gallery lazy loaded.

---

# 31. Testing

## 31.1 Unit tests

Cover:

- non-negative counts;
- rapid increments;
- date normalization;
- midnight rollover;
- session-to-daily count transaction;
- XP calculation;
- level thresholds;
- quest generation;
- quest completion;
- milestone detection;
- streaks;
- aggregates;
- JSON export;
- JSON import;
- merge modes;
- sync conflict resolution;
- outbox retry;
- deterministic pile generation;
- monotonic fill curve;
- image compression result <= 200 KB;
- image metadata stripping;
- photo quota;
- route simplification;
- approximate coordinate rounding.

## 31.2 Database tests

Use in-memory Drift.

Cover:

- upserts;
- transactions;
- outbox creation;
- soft delete;
- history queries;
- session queries;
- sync state transitions.

## 31.3 Widget tests

Cover:

- Today zero state;
- increment;
- decrement at zero;
- exact entry;
- session start;
- location denied;
- History empty state;
- Quest completion;
- Settings theme;
- photo quota message;
- sync error display;
- visualization fallback.

## 31.4 Integration-style tests

Mock Supabase boundary.

Cover:

- login and local upload;
- remote merge;
- photo upload queue;
- signed URL retrieval;
- account deletion orchestration.

---

# 32. Supabase setup deliverables

Create:

- SQL migrations;
- RLS policies;
- storage policies;
- sample `.env.example`;
- setup guide;
- schema explanation;
- local development instructions;
- instructions for Supabase CLI if used.

Expected environment keys:

```text
SUPABASE_URL
SUPABASE_ANON_KEY
```

Do not hard-code secrets.

---

# 33. Placeholder asset policy

Codex must distinguish between simple functional visuals and complex decorative visuals.

## Implement directly

- jar outline;
- basic Zigi variants;
- collision shapes;
- simple particles;
- chart graphics;
- basic XP bar;
- basic quest icons;
- simple achievement card layout;
- basic app icon placeholder.

## Use placeholders

- elaborate backgrounds;
- detailed unlock skins;
- mascot;
- illustrated badges;
- complex achievement artwork;
- photorealistic objects;
- decorative maps;
- app-store promotional art;
- highly detailed container skins.

All placeholders must:

- have clear filenames;
- be listed in README;
- be easy to replace;
- not block functionality;
- not contain giant SVG markup.

---

# 34. Acceptance criteria

The implementation is complete only when:

1. dependencies resolve;
2. code generation succeeds;
3. formatting succeeds;
4. analysis has no errors;
5. tests pass;
6. Android debug build succeeds;
7. app launches;
8. local use requires no account;
9. increment is exact;
10. rapid increments are exact;
11. daily history persists;
12. sessions update daily totals correctly;
13. GPS is optional;
14. denied GPS does not block sessions;
15. photos are optional;
16. processed photos are <= 200 KB;
17. EXIF is removed;
18. cloud upload only occurs when enabled;
19. Supabase sync is non-blocking;
20. RLS policies are present;
21. private storage policies are present;
22. account deletion flow exists;
23. photo quota is enforced;
24. quests and XP work;
25. milestones work;
26. unlock data model works;
27. charts work;
28. export works;
29. import works;
30. no public feed exists;
31. no public image access exists;
32. physics body count is bounded;
33. complex visuals use placeholders;
34. no giant generated SVGs exist;
35. README accurately documents setup and limitations.

---

# 35. Implementation order

Proceed through all steps:

1. inspect repository;
2. scaffold Flutter;
3. configure dependencies;
4. create architecture;
5. implement Drift;
6. implement local repositories;
7. implement Today;
8. implement sessions;
9. implement quests and progression;
10. implement history and charts;
11. implement image compression;
12. implement optional GPS;
13. implement Flame/Forge2D pile;
14. implement export/import;
15. implement Supabase auth;
16. implement Supabase schema and RLS;
17. implement sync outbox;
18. implement private photo upload;
19. implement settings;
20. add tests;
21. run code generation;
22. format;
23. analyze;
24. test;
25. build Android debug;
26. fix failures;
27. update README.

Do not stop after scaffolding or local CRUD.

---

# 36. Commands

Document and run where possible:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format .
flutter analyze
flutter test
flutter build apk --debug
flutter run
```

For Supabase, document relevant CLI commands if used.

---

# 37. README requirements

Include:

- product description;
- screenshots section;
- prerequisites;
- Flutter setup;
- Supabase setup;
- environment variables;
- migrations;
- RLS;
- storage policies;
- local-first architecture;
- sync strategy;
- photo compression;
- GPS privacy;
- cost-control measures;
- physics strategy;
- active/static/baked pile model;
- placeholder asset list;
- replacement instructions;
- tests;
- build;
- known limitations.

Do not claim unfinished features are complete.

---

# 38. Final Codex response

After implementing, report:

- files created;
- architecture decisions;
- Supabase schema;
- RLS status;
- photo compression implementation;
- GPS behavior;
- sync strategy;
- commands executed;
- analysis result;
- test result;
- Android build result;
- placeholders used;
- remaining limitations.

Do not print the entire source code if it already exists in the repository.
