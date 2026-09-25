# Hello Dude! — companion voice & video calling app (working name)

**Working name: "Hello Dude!"** (placeholder, set by the owner 2026-09-23 — not final). Taglines:
"Talk. Vibe. Connect." and "Different languages. Same vibe." Code identifiers
(`pesu` package, `PesuApi`, `pesu_api`, DB names) keep the old codename; only
user-visible text uses the working name.

Read this file fully before doing any work. It records every product and technical
decision made so far. If a task conflicts with a decision here, stop and ask.

## What we are building
A Hima-style companion calling app for India (reference: Play Store `com.gmwapp.hima`).
- **Callers** sign up with a phone number, pick a language, buy coins and pay per
  minute for 1:1 **voice or video** calls with **companions** who speak that language.
- **Companions** pass KYC, go online, take calls, earn per minute + gift share,
  and withdraw to UPI.
- Language matching is the core idea (Tamil first, then Telugu, Kannada, Malayalam,
  Hindi, Bengali, Marathi, English).
- Solo developer. Keep things simple, boring and well-tested.

## Decisions already made
- **Android only at launch** (Flutter). iOS later — don't add iOS-only work now.
- **Voice and video from day one.** Video defaults to **480p**. Video is unlocked per
  companion only after KYC approval + academy lessons + a clean record.
- **Companion verification — no Aadhaar** (owner, 2026-09-24; replaces the in-house Aadhaar
  offline e-KYC): the companion enters a **date of birth + "I am 18+"** (under 18 auto-rejected),
  takes the **live selfie** (ML Kit blink check) and adds a **UPI ID**; an admin approves from the
  selfie in the KYC review queue. **PAN is optional** and can be added any time (even after
  approval): **without a PAN on file, TDS on withdrawals is 20%** (`payout.tds_no_pan_bps`, s.206AA),
  with a PAN the normal `payout.tds_bps`; the app says so on the KYC and Earnings screens. Older
  companions keep their Aadhaar data until retention/deletion removes it; the UIDAI verifier
  (`kyc/aadhaar.ts`) stays in the code but no route uses it. All KYC files stored encrypted.
- **Women are companions only** (owner, 2026-09-24): sign-up with gender female **or other
  (transgender, treated as women)** creates a companion account, never a caller; men sign up as
  callers and can still apply to be companions (unchanged). Existing women callers were converted
  (migration 0028). Women companions add a **voice intro** to verification: the app shows a random
  sentence (in her language) with 4 random digits, she records 3–15 s, an **admin listens** to it next to the selfie
  (checks a woman's voice reading that sentence). The clip is **deleted after the decision**; a
  rejection that ticks "voice" asks for a new recording with a new sentence. On first approval a **₹10 joining
  bonus** (`companion.joining_bonus_paise`) goes to her earnings (once). No automatic voice-gender
  detection — the admin decides.
  The sentence is in **her own language** (native script, per primary language; placeholder
  wording to be checked by native speakers). **Rejections name what to redo** (owner report
  2026-09-24): the admin ticks items (date of birth / selfie / voice / PAN / UPI); only those reset,
  and once the companion sends them all the case **goes back to the review queue by itself**. A
  voice intro not asked for again counts as checked (clip still deleted). Rejecting with nothing
  ticked = they fix things and press Submit.
- **Calls:** LiveKit. Start on LiveKit Cloud (paid starter plan), move to
  self-hosted LiveKit on an India VPS when volume justifies it.
- **Coin purchases and VIP subscription: Google Play Billing + User Choice Billing
  (UCB) with Razorpay** (decided by the owner 2026-09-23; replaces "Play Billing only").
  - Google shows its choice screen at checkout: Google Play or Razorpay. Razorpay runs
    **inside the app** (Razorpay Android/Flutter SDK). Never link or redirect users to a
    website to pay, and never mention cheaper prices elsewhere — that breaks Play policy.
  - Play purchases: verify server-side (Play Developer API) and consume Real-time
    Developer Notifications for refunds/cancellations.
  - Razorpay purchases: create the order on the server, credit coins only from the
    **verified webhook / signature** (never from the app's word), idempotent on the
    Razorpay payment id, and **report every UCB transaction to Google** (Play Developer
    API external transactions) within 24 h; Google bills its reduced fee monthly.
  - Requires enrolment in User Choice Billing in Play Console (India).
- **Companion payouts:** RazorpayX or Cashfree Payouts to UPI. Debit the earnings
  wallet when the payout is **requested**, not when it completes. Failed payouts
  credit the money back to the balance.
- **OTP (owner, 2026-09-24): Firebase Auth phone sign-in for the mobile app, India (+91) only.**
  The app verifies the number with Firebase and sends the ID token to `POST /v1/auth/firebase`;
  the server checks it with firebase-admin and issues its own sessions (same result as otp/verify).
  The **admin panel stays off Firebase**: it keeps `/v1/auth/otp/*` (dev code in dev; MSG91 in
  production). Dev mode keeps `DEV_OTP_CODE` for the demo accounts and tests.
- **Backend is REST + OpenAPI, not tRPC** — the Flutter app can't consume tRPC.
  Generate the Dart API client from the OpenAPI spec.

## Tech stack
| Layer | Choice |
|---|---|
| Mobile | Flutter (Android), Riverpod, go_router, `livekit_client`, `flutter_callkit_incoming` (ConnectionService), `firebase_messaging`, `in_app_purchase`, `google_mlkit_face_detection`, on-device TFLite nudity model |
| API | Node.js + TypeScript (strict), NestJS (or Fastify), REST + OpenAPI |
| Realtime | WebSocket (Socket.IO or `ws`): presence, matching, low-balance warnings, chat, room events |
| Jobs | BullMQ on Redis: billing worker, sweeper, payouts, reminders, streak resets, offer expiry |
| DB | PostgreSQL (source of truth for money), Drizzle or Kysely; raw SQL for wallet transactions |
| Cache | Redis: presence, busy locks, billing schedule, matching queue, rate limits, streaks |
| Storage | S3-compatible in an India region (AWS Mumbai or Cloudflare R2) |
| Admin | Next.js + shadcn/ui + Recharts, Auth.js with roles (admin, moderator, finance), audit log |
| Push | FCM |
| Analytics | Firebase Analytics + Crashlytics (or PostHog), Sentry, Remote Config for flags |
| Referrals | Android App Links on own domain + Play Install Referrer API (NOT Firebase Dynamic Links — shut down) |
| Infra | Docker Compose on 1–2 VPS in Mumbai/Bangalore; GitHub Actions; Codemagic/Fastlane for Android builds |

## Suggested repo layout
```
apps/mobile          Flutter app (caller + companion roles in one app)
apps/admin           Next.js admin panel
services/api         REST API + WebSocket server
services/worker      BullMQ workers (billing, payouts, sweeper, notifications)
db/                  schema + migrations
design/              screen designs (HTML reference) — see "Designs"
docs/                extra notes
```

## Billing rules (most important code in the project)
Reference implementation: `services/api/src/billing/billing-engine.reference.ts`
(draft — needs tests and the stubs filled in). Schema: `db/schema.sql`.
- **Prepaid per minute.** Minute N is charged at the **start** of minute N.
  Balances can never go negative (DB `CHECK (balance >= 0)` + guarded UPDATE).
- The first minute is charged only when **LiveKit reports both participants
  joined** (webhook), not when the caller taps Call.
- Each minute: debit caller coins + credit companion earnings **in one transaction**,
  plus one row in `call_ticks (call_id, minute_no)` — PK prevents double billing.
- Every ledger row has a unique `idempotency_key`. `ledger_entries` is
  **append-only** (trigger); corrections are new `adjustment` rows.
- Money in integers: coins wallet in coins, earnings wallet in paise. No floats.
- Rates are versioned per language + call type; a call **freezes its rate** at start.
- Calls shorter than **10 s** are fully refunded (grace period).
- Ring timeout **45 s** → missed. A sweeper job fixes calls left open by crashes
  or lost webhooks by checking LiveKit room participants.
- Low-balance warning is pushed to the caller when the next minute can't be paid.
- Postgres holds all money state; Redis state is disposable and rebuildable.
- Users can see every charge minute-by-minute (Call details screen) — trust is a
  competitive advantage (Hima's reviews complain coins vanish).

## Safety, moderation & compliance
- 18+ only. Report + block available during and after every call.
- On a report, keep the last few minutes of call audio (LiveKit Egress → S3),
  delete after the report is closed. Disclose this in terms and at call start.
- Video moderation: on-device TFLite nudity check every few seconds → blur
  immediately + upload that single frame for review. Cloud vision API only for
  flagged/reported frames (per-image cost).
  **Tuned 2026-09-24 (owner: ~90% false alarms):** frames too blurry (Laplacian variance < 80
  on the 224×224 grey image) or too dark (mean < 30) are skipped — the model scored blurry room
  shots 0.86–0.98; and the phone blurs/pauses + reports only after **2 flagged frames in a row**
  (~4–8 s) instead of the first. Applies to calls, live viewers, live hosts and group video.
  Next step if still noisy: replace the classifier with NudeNet (detects exposed body parts).
  **1:1 calls use silent mode** (owner, 2026-09-24): the check still runs on the other person's
  video but never blurs — flagged frames (2 in a row, max one per 30 s) only go to the admin
  Moderation queue; the companion still has report, block and call recording. **Lives and group
  video keep blurring/pausing** (public, many viewers).
- Chat: block/flag phone numbers, UPI IDs and payment requests (regex); LLM
  moderation for abusive Tamil/Indic text later.
- Fraud rules (jobs + SQL): many sub-70-second calls, UPI change right before
  payout, one device with many accounts, earnings far above a companion's average.
- Compliance: IT Rules 2021 grievance officer, DPDP Act 2023 (consent, deletion,
  retention), TDS on companion earnings, GST on coin sales, DLT for SMS,
  Google Play UGC / social-app policies.

## MVP scope
**In:** phone OTP, language selection, home with online companions + instant match,
1:1 voice + video calls, per-minute billing, wallet + coin packs (Play Billing + UCB/Razorpay),
first-recharge offer, gifts in call, rate after call, favourites, report/block with
recording, call details + refund request, companion offline KYC, companion home
(online toggle), incoming call, earnings + UPI withdrawal, admin (dashboard,
KYC review queue, payouts approval, reports, pricing).
**Later (v2):** voice rooms, chat, VIP subscription, scheduled calls, daily check-in,
referrals + share card, companion levels/academy video hosting, A/B pricing UI.
**v2 is built** (owner asked 2026-09-23; done 2026-09-24): notifications inbox, daily check-in, referrals + share card, chat, scheduled calls, VIP, companion levels/bonuses, voice rooms, admin Engagement page. VIP purchases and referral rewards wait for Play Billing (first recharge).

## v2 rules (defaults chosen where the designs are silent — all amounts admin-editable placeholders)
- **Notifications inbox** (caller + companion): stored rows + FCM push; types: favourite online,
  booking requested/confirmed/cancelled/reminder, refund decided, daily bonus, rate your call,
  referral joined/rewarded, report actioned, coins from support, payout paid/failed, KYC decided.
- **Daily check-in:** 7-day cycle 2/2/3/3/5/5/10 coins; one claim per IST day; a missed day
  resets to Day 1; after Day 7 the cycle restarts at Day 1.
- **Referrals:** each user gets a code; entered at sign-up; referrer +50 and friend +50 coins
  only after the friend's **first credited recharge**; max 50 rewarded referrals per referrer
  (same-device abuse is left to the fraud checks).
  **Companions have codes too** (owner, 2026-09-24): a caller who signs up with a companion's code
  gets the same welcome coins, and the companion gets `referral.companion_bonus_paise` (₹25,
  placeholder) in **earnings** on that caller's first credited recharge (same cap). Watch for
  companions farming their own callers (fraud checks).
- **Share card:** rendered on the phone; shows today's talk minutes + language + referral code;
  never the phone number or who they talked to.
- **Chat:** free; only between a caller and a companion who have had at least one connected
  call; messages with phone numbers / UPI IDs / payment requests are blocked (regex); calls and
  gifts appear in the thread.
  **Owner, 2026-09-24:** (D) a caller who hasn't called her yet can send **one message request**
  (≤300 chars, filtered, 5/day); she **accepts** (chat opens with it as the first message) or
  **declines** (they can ask again after 7 days). (A) The filter now undoes tricks: Indian-script /
  emoji / look-alike digits, number words in the launch languages, padding between digits, and a
  number **split over the last 5 messages (10 min)**. (B) Every blocked attempt is a **strike**:
  3 in 24 h pause the sender's chat for 24 h (`chat.*` settings), 5 in 30 days file one automatic
  report (reason off_platform, source system, no reporter) for admin review, and companions with
  3+ strikes in 30 days get a `contact_sharing` payout flag. (C) New report reason **off_platform**
  ("Asked for my number / to pay outside the app") in calls, chat (new Report / Block menu) and
  group video. Voice calls can't be filtered — reports + call recording cover them.
- **Scheduled calls:** favourites only; next 5 days; 30-min slots 7–11 PM IST; 10/20/30 min;
  coins = rate × minutes **held** at booking; companion must confirm within 12 h or it's
  cancelled and refunded; cancelled / no-show-by-companion = full refund; reminder 10 min before;
  when the booked call starts the hold is released back and normal per-minute billing applies.
- **VIP:** Play subscription (monthly / 3 months, blocked until Play Billing); 10% off call
  minutes paid by the platform (companion earnings unchanged); priority in instant match; gold
  badge; one free Rose per week (expires after 7 days). Admin can grant VIP manually.
- **Companion levels:** by talk hours this month (or last month, whichever is higher) + minimum
  rating; higher levels add % to per-minute earnings, frozen at call start. Daily goal is
  progress only. Online streak = consecutive IST days with ≥30 min online. Time-window bonuses
  (e.g. +₹50 for 3 h online 8–11 PM) are admin campaigns paid to earnings by the worker.
- **Voice rooms:** hosted by approved companions only; listening free; up to 8 on stage (host
  approves raised hands); gifts to host/speakers use the same companion gift share as calls;
  LiveKit audio rooms.
- **Offers popup** (owner asked 2026-09-24): admin → Offers popup creates promotions shown as a
  bottom sheet with confetti when the app opens (and again after ≥10 min in the background, only
  on the main tabs, never over a call or when the app was opened by accepting a call). The live
  offer for that person with the highest priority wins; audience all / callers / companions /
  never-paid / paid; frequency every open / daily (IST) / once. Buttons only open in-app screens,
  never external links (Play payments policy). Shows and taps are counted per offer.
- **Companion call types** (owner asked 2026-09-24): companions switch Voice and Video on/off
  on their home (at least one on). Video still has to be unlocked first; taking video = unlocked
  AND switched on. Listings, call start, instant match, favourites and bookings respect it.
  If an admin locks video again, voice is switched back on so they still get calls.
- **No screenshots** (owner asked 2026-09-24): FLAG_SECURE on the whole Android app — blocks
  screenshots and screen recording, and the app shows blank in recent apps.
- **Admin RBAC** (owner asked 2026-09-24): staff = users with role 'admin', each with one
  admin role (table admin_roles). Built-in roles: Admin (every permission, locked), Moderator,
  Finance; custom roles from Staff & roles. Permissions live in
  services/api/src/auth/permissions.ts and are checked **per request from the DB** (`can("…")`
  preHandler), so role changes and switch-offs apply at once. **Every new /admin route must use
  `can("<permission>")`**, and the admin panel hides pages/buttons via `useCan()`. Guard rails:
  nobody edits their own role/access, never zero active Admins, staff phone numbers can't be
  app accounts, every change audited. `make-admin` creates a full Admin (the owner).
- **Analytics** (owner asked 2026-09-24): admin → Analytics (permission `analytics.view`, not given
  to Moderator/Finance by default — tick it per role). Any IST date range vs the previous period:
  totals, daily trend, language / voice-video / hour breakdowns, leaderboards (top rated, works
  most, top earners, top spenders, most reported) and an **estimated** margin: sales ÷ (1+GST) ×
  (1−store fee) − companion earnings, vs target — GST %, fee % and target % are settings
  (`analytics.*`). Dashboard shows callers online (app open = live WebSocket, Redis `presence:app`).
- **Live mode, phase 1** (owner asked 2026-09-24): a companion with video unlocked goes live
  (one-to-many video, LiveKit SFU, 480p); no 1:1 calls while live (engine refuses BUSY). Callers
  swipe a Reels-style feed (only the visible live joins). **Billing is per minute like 1:1**
  (owner, 2026-09-24; passes were dropped): free preview (live.preview_seconds 10 s, once per
  viewer per live, live.previews_per_day 20), then the viewer opts in ("Keep watching · N
  coins/min", live.coins_per_min **3**) — minute 1 charged on opt-in, then one at the start of
  every minute LiveKit shows them in the room (worker every 10 s; live_ticks PK blocks double
  charges; low-coins warning; removed when they can't pay; balance never negative). Leaving stops
  charging, so no refunds are needed. Companion earns coins × coin.value_paise (already NET per
  coin) × live.companion_share_bps (2500 = 25% of net → the 75% margin target); live gifts use the
  gift share. Chat needs a paid minute; hearts/gifts don't. Controls: empty live warned at 5 min,
  ended at live.empty_end_minutes (10); live.max_minutes 180; live.max_per_day 4 per companion.
  LiveKit Cloud bills per participant-minute + downstream GB (~₹0.09/viewer-minute at 480p);
  analytics margin subtracts analytics.livekit_paise_per_viewer_minute (9). Host phone runs the
  nudity check on its own camera (pauses camera 15 s + flags frame); viewers' phones also check.
  Admin: Engagement → Lives (end with reason, audited); frames in Moderation.
- **Group video, phase 2** (owner decided 2026-09-24): a companion (video unlocked) hosts up
  to **10** paying members; **everyone's camera on** (option C, 480p, LiveKit adaptive quality;
  warn callers it uses more data). **12 coins per member per minute** (group.coins_per_min),
  companion share group.companion_share_bps 2500 (25% of net). Billing like lives/1:1: prepaid
  per minute, server-verified LiveKit presence, ticks table PK, low-coins warning then removal,
  leaving stops charging. **Starts when 3 members are waiting** (no charge while waiting; lobby
  expires after 10 min), **ends when fewer than 2 members remain**, max 120 min. **Instant and
  scheduled**: scheduled groups (next 7 days) take free seat bookings, remind 10 min before,
  cancel if the host doesn't open within 15 min. No 1:1 calls or lives during a group.
  **Built 2026-09-24** (routes/groups.ts, worker sweepGroups every 10 s, app lib/features/group).
  Cost control: adaptive stream + dynacast + simulcast; members publish 360p, host 480p; the
  speaker/host tile is large, others small. Safety: **every participant's phone checks its own
  camera** (pause 15 s + flag frame to Moderation); long-press any tile to report / block, host
  can report + remove; join screen discloses "everyone can see your camera". Analytics LiveKit
  cost counts each group member-minute twice. Admin: Engagement → Group video (end/cancel, audited).
- **Companion profile photos** (owner asked 2026-09-24): companions may upload their own photo;
  it shows only after an admin approves it (compared side by side with the KYC selfie), and is
  used everywhere the avatar shows (cards, lives, groups). Server strips EXIF and re-encodes;
  photos are served only to signed-in users. **Callers stay avatar-only.** The illustrated
  avatars (ids 1–3 by gender) remain the fallback.
- **Live tab** (owner, 2026-09-24): caller bottom nav is Home · Online · **Live** · Wallet · Profile
  (Live replaced Calls; call history moved to Profile → Call history). 2-column grid of live
  cards with server-side sort (For you = favourites, own language, busiest / Popular / New),
  Favourites filter, language chips, name/title search and paging (20 at a time); a red dot on
  the tab while anyone is live; Home keeps a top-10 "Live now" row with "See all N". Tapping a
  card opens the swipe feed in the same order and it keeps loading more. Card picture = a
  **snapshot from the host's phone** (one checked-clean camera frame about once a minute,
  re-encoded 360×480, signed URL, served only while live, deleted by retention) — never live
  video previews on cards (LiveKit minutes + data); falls back to the host photo/avatar.
- **Callers tab for companions** (owner, 2026-09-24): companion bottom nav is Home · **Callers** ·
  Earnings · Profile. It lists every caller with the app open (Redis `presence:app`; no opt-out),
  with name, avatar, language and badges — Ready to call (coins ≥ `invite.can_pay_minutes` × her
  voice rate), VIP, New (joined ≤7 days), In a call — plus "Talked N× · last …" and whether he
  favourited her; fans and regulars first. **She can't call him — she invites**: he gets a
  `call_invite` event + notification ("Priya wants to talk") and starts the call himself, so
  billing is unchanged. Limits: she must be online and free; one invite per caller per hour;
  `invite.per_companion_hour` (30) and `invite.per_caller_hour` (5).
- **Online tab** (caller bottom nav): everyone online in any language, with search, language
  chips, free-now / video / favourites filters and sort; the Random button is a FAB there.
- **Growth features** (owner chose 2026-09-25; all numbers admin-editable placeholders):
  - **Leaderboards — badges only, no cash.** Weekly (IST, Mon–Sun) Top companions (gift coins
    received) and Top fans (gift coins sent), across calls, lives, groups and voice rooms (VIEW
    `all_gifts`). The worker gives the top `leaderboard.badge_top_n` (10) a badge for the next week
    (`user_badges`); the best active badge shows on companion cards and caller rows.
  - **Festival events:** admin → Engagement → Events (name, theme, dates). While one runs, Home
    shows its banner and it has its own leaderboard; when it ends, the top 10 get event badges.
  - **Caller levels:** 8 levels by lifetime coins spent (`users.coins_spent`, kept by a ledger
    trigger; refunds subtract); level-up notification; companions see the level in the Callers tab.
    Admin → Engagement → Caller levels (kept in order).
  - **Companion invites companion** uses the existing referral code: the inviter gets
    `referral.companion_invite_paise` (₹100) once the new companion completes
    `referral.companion_invite_hours` (10) paid talk hours.
  - **PK battles** (routes/pk.ts): a live host challenges another live host (30 s to accept);
    **5 minutes** (`pk.seconds`) side by side, **gift coins decide** (gifts to each host from either
    live during the window); viewers pick a side when gifting (`toHostId`, only the opponent of an
    active battle); winner gets a 24 h "PK winner" badge; tie = draw. Nobody pays extra: viewers
    keep paying only their own live, and the other side's video is a listen-only second LiveKit
    room (identity `<user>:pk`, not billed). Ends early if either live ends or a host ends it.
  - **Faster payouts:** via RazorpayX (owner will connect the account); not built yet.

## Designs
`design/screens/*.dc.html` — 31 screens (mobile 390×844, admin 1440×900).
They are **visual reference markup only** (they need a canvas runtime to render),
so read them for layout, copy, colours, spacing and states, then build natively
in Flutter / Next.js. `design/canvas.json` lists titles and order.
Live canvas (owner only): https://claude.ai/artifact/8hWRCDf4kSCdqwkgEGtrGc

Caller: Main (sign up), Otp, Language, Home, InCall, Wallet, Profile, Gifts,
FirstRecharge, Favourites, Schedule, Vip, Chat, Notifications, CheckIn, RateCall,
Referral, Report, CallDetails, Rooms, RoomLive, ShareCard.
Companion: CompanionHome, Incoming, Earnings, KycSelfie, Rewards, Training.
Admin: AdminDashboard, AdminPayouts, AdminPricing.
**Still to design:** KycSelfie needs an "Upload Aadhaar ZIP + share code" step
before the selfie; admin **KYC review queue** screen.

Design tokens:
- Dark app background `#0A0A18` with purple/pink radial glows; cards `rgba(22,20,44,0.78)`,
  border `rgba(255,255,255,0.08)`, radius 20.
- Brand gradient `linear-gradient(90deg, #7C3AED, #DB2777 55%, #EA580C)` on primary buttons.
- Companion side uses green `#10B981 → #0E7490`. VIP uses gold `#FDE68A → #D97706`.
- Text white; secondary `#C9C5DD`. Success `#34D399`, warning `#F59E0B`, danger `#E11D48`.
- Fonts: Plus Jakarta Sans (headings), Figtree (body), Caveat (handwritten accents),
  Noto Sans Tamil/Telugu/Kannada/Malayalam/Devanagari/Bengali for scripts.
- Admin: light theme `#F7F6FB`, white cards, border `#E7E4F0`, accent `#6D28D9`.

## Open decisions (ask the owner — don't invent)
Final app name (working name "Hello Dude!"); coin pack sizes and prices; per-minute rates per language and call
type; companion share per minute and per gift; minimum withdrawal; whether chat should be
paid (built free for now). Sample values in designs (10 coins/min voice, 25 video,
₹3/min companion) are placeholders.

## Working rules
- TypeScript strict; no `any` in money code. Write tests for every billing path
  (connect, each minute, insufficient balance, grace refund, duplicate webhook,
  worker crash/retry, sweeper) before wiring the UI.
- Migrations are forward-only and reviewed; never edit ledger rows.
- Secrets in env vars only. Never log OTPs, Aadhaar data, tokens or UPI IDs in full.
- Prefer managed services over hand-rolled infra until traffic proves otherwise.
