# Pesu

Companion voice & video calling app. Product and technical decisions live in
[CLAUDE.md](CLAUDE.md); screen designs are in [design/screens](design/screens).

## Layout
```
apps/mobile      Flutter app (not started)
apps/admin       Next.js 16 admin panel (Tailwind, shadcn/ui, TanStack Query + Table, Framer Motion, Recharts)
services/api     REST API + billing engine (Fastify, TypeScript)
services/worker  BullMQ workers (not started)
db/migrations    forward-only SQL migrations
docs/            reference material (original billing draft)
```

## Run locally
Requires Docker Desktop and Node 20+.

```sh
docker compose up -d --wait          # Postgres :55432, Redis :56379, LiveKit :7880 (dev)
cd services/api
npm install
npm test                             # creates pesu_test, migrates, runs all tests
cp ../../.env.example .env           # fill JWT_SECRET (32+ chars), then:
npm run migrate
npm run dev                          # API on http://127.0.0.1:9000, docs at /docs
npm run worker                       # billing loop + sweeper (second terminal)
npm run openapi                      # writes openapi.json for the Dart client
```

In dev OTP mode no SMS is sent and **every number accepts `123456`**.
`npm run seed:dev` puts 4 demo companions online (24 h, logins 6000000001–4), creates 5 demo callers
(Arjun, Karthik, Vijay, Suresh, Rahul — logins 6100000001–5) and tops every caller up to 500 test coins.

### Admin panel
```sh
cd services/api && npm run make-admin -- 9999900000   # any number; dev admin already exists
cd apps/admin && npm install && npm run dev            # http://127.0.0.1:9001 (OTP 123456 in dev)
```
Tokens live in httpOnly cookies; the browser talks only to `/api/v1/admin/*` on the panel,
which forwards to the API. Every admin change is written to the append-only `audit_log`.

### Test a call (one phone + this PC)
With `npm run dev` **and** `npm run worker` running, open
http://127.0.0.1:9000/dev/companion in the PC browser (dev mode only), sign in as a demo
companion and press **Go online**. Call that companion from the phone and answer in the browser.
Local LiveKit config: `infra/livekit.dev.yaml` (git-ignored; its key/secret match services/api/.env).

### Test companion KYC (dev)
`npm run test-aadhaar -- "Priya Raman" 15-08-1998 F` makes a signed test ZIP (share code 1234)
under services/api/.data/; copy it to the phone's Download folder with `adb push`. Only the local
test certificate in `.data/dev-uidai/` trusts it — production uses UIDAI's certificate.

### Phone (Android, USB)
Push notifications need two Firebase files that are **not in git**: download
`google-services.json` (Android app `com.hellodude.app`) into `apps/mobile/android/app/`, and a
service-account key saved outside the repo, pointed to by `FIREBASE_SERVICE_ACCOUNT_PATH` in
`services/api/.env`. `npm run push:test -- <10-digit phone> [--call]` sends a test push.

```sh
adb reverse tcp:9000 tcp:9000        # API       } phone's 127.0.0.1 -> this PC
adb reverse tcp:7880 tcp:7880        # LiveKit   } (redo all three after replugging)
adb reverse tcp:7881 tcp:7881        # LiveKit media over TCP
cd apps/mobile && flutter run        # or: flutter build apk --debug && adb install -r ...
```
The Dart API client in `packages/pesu_api` is generated — after API changes run
`npm run openapi` in services/api, then
`npx @openapitools/openapi-generator-cli generate -i services/api/openapi.json -g dart -o packages/pesu_api --additional-properties=pubName=pesu_api,pubLibrary=pesu_api`.

## Status
- [x] Stage 1 — repo, database, migrations, billing engine with tests for every
      billing path (connect, per-minute, insufficient balance, grace refund,
      duplicate webhook, worker crash/retry, sweeper)
- [x] Stage 2 — API: phone OTP auth + sessions, profile, wallet + ledger, online
      companions, calls (start / instant match / accept / reject / end / history /
      details / rating), block + report, companion presence, LiveKit webhooks,
      OpenAPI at /docs (63 tests)
- [x] Stage 3 — Flutter app: sign up → OTP → language → home (online companions,
      instant-match card), Calls / Wallet / Profile tabs; default prices seeded
- [~] Stage 4 — live voice/video calls (LiveKit), realtime WebSocket, in-call screen,
      low-balance warning, rating, dev companion console ✔ · Google Play coin purchases ✗ (needs Play Console)
- [x] Stage 5 — companion side: apply, in-house KYC (Aadhaar offline e-KYC signature check,
      ML Kit blink selfie, PAN, UPI), admin KYC review, online switch + heartbeat, full-screen
      incoming call, earnings + UPI withdrawals (TDS, risk flags, auto-reversal), admin payouts
      · lock-screen ringing needs FCM (Firebase) · real payouts need RazorpayX/Cashfree
- [x] Stage 6 — admin panel: dashboard, pricing (versioned rates, coin packs), reports,
      callers/companions (search, suspend), audit log · KYC review + payouts come with Stage 5
- [x] Stage 7 — MVP gaps: gifts in call, favourites, refunds, report recording port, academy,
      account deletion, first-recharge offer · admin detail pages, table filters/export
- [x] Safety & policy — legal pages (/legal/*), retention jobs, on-device video nudity check +
      admin Moderation queue
- [x] v2 — notifications inbox, daily check-in, referrals + share card, chat (safety filter),
      scheduled calls (coin hold), VIP (admin grant; Play purchase pending), companion levels +
      bonuses, voice rooms, admin Engagement page
- [x] Admin roles (RBAC: Admin / Moderator / Finance + custom) and fraud flags on withdrawals
      (new UPI, short calls, earnings spike, contact sharing, one phone with many accounts)
- [x] Razorpay coin purchases inside the app (order → checkout → server verifies signature + payment,
      webhook fallback, refunds take coins back) — `RAZORPAY_KEY_ID/SECRET`, `RAZORPAY_WEBHOOK_SECRET`
- [x] RazorpayX UPI payouts (webhook + worker check for "processing") — `RAZORPAYX_ACCOUNT_NUMBER`
      (simulator without it; refused in production)
- [x] S3 / R2 storage for KYC files (encrypted before upload) — `S3_BUCKET` etc. (local disk without it)
- [x] Deploy: Dockerfiles (API/worker, admin), `infra/docker-compose.prod.yml` + Caddy HTTPS,
      GitHub Actions CI (API tests, admin build, Flutter analyze/test, image builds)
- [ ] Needs Play Console — Play Billing + the User Choice Billing choice screen, reporting Razorpay
      sales to Google (external transactions API), VIP subscriptions
- [ ] Needs accounts — MSG91 (admin OTP), LiveKit Cloud, live Razorpay/RazorpayX keys, S3/R2 bucket
