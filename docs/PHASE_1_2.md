# Kisan Daily: Phase 1 and 2 Flutter implementation

Authentication has since been replaced by real mobile/password APIs with access/refresh tokens. See `AUTH_SETUP.md`; registration and login now open Home directly.

## Run

```sh
flutter pub get
flutter run
```

The farmer app is now the default on mobile and web. The existing desktop admin remains available with `--dart-define=ADMIN_DASHBOARD=true`.

For backend integration:

```sh
flutter run --dart-define=FARMER_API_URL=https://your-server.example/api
```

Use an HTTPS base URL without a trailing slash. Provider credentials belong on the server, never in Dart defines or source control.

## Implemented app flows

- Mobile/password registration and login, secure access/refresh sessions, optional farmer profile editing, and returning-session validation. OTP and guest login were removed.
- Farmer profile, selected crops, mandi preference, ledger and price targets persist locally.
- Khata manual entries and actual device speech recognition with an editable transcript before saving. Unsupported or denied microphone access falls back to typing. Hindi digits, sale words, and explicit currency amounts are supported. No amount is invented when parsing fails.
- Weather and mandi sample views, plus a configured backend daily-feed adapter and refresh/status UI. Failed provider fetches are identified as sample data. No live price alert is triggered from sample data.
- Rate alerts can be created, toggled and deleted locally. A configured backend receives these changes and must monitor rates and send push notifications.
- Crop calendar with custom tasks, sowing date, inspection reminders at 7/21/45 days, completion and deletion. These are planning tasks, not automatic agronomic treatment recommendations.
- Daily morning reminder and one-time crop/scheme reminders through Android/iOS local notifications, with permission handling. Other platforms keep the in-app calendar but do not claim phone scheduling support.
- Crop doctor camera/gallery upload, crop and symptoms, explicit AI upload consent, loading/failure states, result history and a local three-successful-results/day cap. The backend must enforce the actual per-user quota. Demo mode shows an explicitly labeled example result, without sending or analyzing the photo.
- Scheme information, official links and farmer-selected follow-up reminders. No government deadline is invented; the reminder picker is not an application deadline feed.
- Local inputs by category, sponsored labels, consented enquiries and enquiry history. Demo shops are visibly marked; enquiries remain local drafts. Configured builds fetch real listings and submit enquiries only after consent.
- Reminder inbox uses actual saved tasks/targets rather than the old hardcoded notification history.

## Not live without external infrastructure

The adjacent `shop_springboot_backend` now implements real mobile/password auth with access/refresh sessions and farmer profile persistence. Weather/Agmarknet/AI/seller/push provider integrations remain separate and were not verified with live provider credentials. Ad networks, partner billing and sponsorship payments are not integrated. These are business/platform integrations, not simulated earnings.

Phone camera, speech recognition and OS notification delivery must be checked on Android/iOS hardware after installation. iOS requires its native build/signing setup. Android reminders use inexact scheduling, so the OS can delay them. Daily repeating notifications currently use the device's offset at scheduling time; reschedule after a timezone change.

Local records are now isolated by authenticated account UUID. Cloud backup, verified eligibility/deadline feeds and analytics remain separate work; auth expiry and refresh are implemented. Phase 3 marketplace/loan/land-record functionality is outside this implementation.

## Backend API contract

All endpoints are relative to `FARMER_API_URL`. Requests use JSON except crop photos. Protected requests include `Authorization: Bearer <token>` from secure storage. Return 2xx for success, 4xx/5xx for errors. JSON endpoints return an object, including mutation endpoints (use `{}` if no response data).

| Endpoint | Request | Response / responsibility |
| --- | --- | --- |
| `POST /auth/register`, `/auth/login`, `/auth/refresh` | See `AUTH_SETUP.md` | Complete user plus access/refresh token pair |
| `GET /daily-feed?district=...&mandi=...` | Authenticated district/mandi query | `{updatedAt, weather, rates}`; use provider timestamps and data sources |
| `POST /rate-alerts` | `{id,cropName,cropHindi,mandiName,targetPrice,isAbove,isActive}` | Idempotently save client ID; monitor current provider rates |
| `POST /rate-alerts/:id` | `{isActive: bool}` or `{deleted: true}` | Mutate only the authenticated farmer's alert |
| `POST /crop-doctor` | Multipart `photo`, `crop`, `symptoms` | `{summary: "...", advice: "..."}`; enforce quota and validate image MIME/content/size |
| `GET /input-listings?district=...` | District query | `{items:[{id,name,category,item,sponsored}]}`; categories `बीज`, `खाद`, `दवाई` |
| `POST /input-leads` | `{listingId,message,consent:true}` | Create lead under authenticated user; share only with chosen seller |

`weather` follows `WeatherAdvisoryModel.fromJson` in `lib/model/weather_advisory_model.dart`: required scalar fields include location, temperature, feelsLike, condition, highTemp, lowTemp, humidity, windSpeed, rainProbability, todaySpraySuitability (`safe`, `caution`, `unsafe`), sprayAdviceTitle/Description, bestSprayWindow and irrigationAdviceTitle/Description. Optional arrays: hourlyForecasts, dailyForecasts, cropSprayTips. Missing arrays remain empty; no fabricated forecasts fill them.

Each rate contains `id,mandiName,district,state,cropName,cropHindi,variety,minPrice,modalPrice,maxPrice,priceChange,arrival,date`. Numeric fields must be JSON numbers. Dates and prices must reflect the provider record, not the request time.

Server responsibilities include user authorization, consent audit, input validation, quotas, signed/secure media handling, provider credentials and a real push device-registration/delivery pipeline. The app does not contain that infrastructure.

## Verification

Run `flutter test` for the existing tests plus `test/daily_flow_test.dart` (voice parsing, local restore, calendar completion/deletion, narrow-phone calendar dialog and doctor submission gating). Build Android with `flutter build apk --debug`, and web with `flutter build web --release`.

## Verified result for this change

Demo/local mode was explicitly selected. All 16 tests passed. Android debug APK and web release builds succeeded. Browser smoke check covered onboarding, demo OTP, profile save, home, calendar and crop doctor layout. Camera, speech and notification delivery have not been exercised on physical hardware.
