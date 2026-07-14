# ZigiQuest product log

This is the lightweight backlog for bugs, feature requests, and product decisions raised during development.

## Open

### BUG-001 — Forgotten cleaning session can leave the app stuck

- **Type:** Bug
- **Priority:** Serious / high
- **Reported:** 2026-07-13
- **Status:** Triaged

**Observed behavior**

1. Start a cleaning session.
2. Leave it running long enough to forget about it.
3. Return to the app: the app can no longer be opened normally and appears stuck.
4. Force-kill and restart the app: the cleaning run is stopped.

**Expected behavior**

- An active or stale session must never prevent the app from opening or resuming.
- Restarting the process must restore a still-valid session rather than implicitly ending it.
- Cleaning sessions automatically time out after a configurable duration.
- The default timeout is **2 hours**.
- When a session times out, it is safely finalized and the user receives a local notification.
- Settings expose the session timeout and clearly explain what happens on expiry.

**Implementation/QA notes**

- Base expiry on persisted timestamps, not an in-memory timer alone.
- Handle foreground resume, process death, device restart, and clock/time-zone changes.
- Persist all counts already recorded before finalizing the timed-out session.
- Notification delivery must not be required for timeout/finalization to succeed.
- Add regression coverage for returning before expiry, returning after expiry, and restarting while a session is active.

**Open product decisions**

- Allowed timeout choices and whether “never” is supported.
- Whether expiry should end exactly at the configured limit or record the last known active time.
- Exact timeout-notification copy and tap destination.

### FEAT-001 — Gentle cleaning reminders and notification settings

- **Type:** Feature
- **Priority:** Normal
- **Reported:** 2026-07-13
- **Status:** Proposed

**Goal**

Offer optional reminders to do a cleaning run without nagging or guilt-based language.

**Proposed behavior**

- Add a Notifications section in Settings.
- Let users enable/disable cleaning reminders and control their cadence.
- Keep defaults deliberately low-frequency:
  - at most one reminder per week for a user with recent activity;
  - reduce to at most one reminder per month when no activity is detected.
- A completed cleaning run resets the reminder schedule.
- Do not send a cleaning reminder during an active cleaning session.
- Ask for notification permission in context, only when notifications are first enabled or otherwise needed.
- Notification scheduling remains local-first and does not require an account.

**Tone guardrails**

- Encouraging, optional, and non-moralizing.
- No streak-loss pressure, urgency tricks, or repeated prompts after dismissal.

**Open product decisions**

- Whether reminders are enabled by default or offered through an explicit opt-in.
- Definition of “no activity” and the exact transition from weekly to monthly.
- Preferred day/time and whether the user can choose both.
- Reminder copy variants.

### FEAT-002 — Polite app-rating banner

- **Type:** Feature
- **Priority:** Low
- **Reported:** 2026-07-13
- **Status:** Proposed

**Goal**

Add a small, warm rating request that feels apologetic and respectful rather than demanding.

**Experience guardrails**

- Never interrupt an active cleaning session or first-run experience.
- Show only after a genuinely positive moment or meaningful use of the app.
- Use an unobtrusive in-app banner before opening the platform rating flow.
- Provide clear “Not now” and “Don’t ask again” actions.
- Persist dismissal state and strictly cap how often the banner can return.
- Do not condition rewards, functionality, or progress on leaving a rating.

**Starter copy direction**

> A tiny favor—only if ZigiQuest has earned it. Would you mind leaving a rating? No worries at all if not.

Actions: **Rate ZigiQuest**, **Not now**, **Don’t ask again**

**Open product decisions**

- Eligibility trigger (for example, after several completed runs or a milestone).
- Maximum number of appearances and cooldown after “Not now.”
- Final copy and whether to invite private feedback separately.

## Completed

No tracked items completed yet.
