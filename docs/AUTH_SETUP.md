# Mobile/password authentication

This replaces the previous OTP/demo-login flow. The login screen does not offer guest access or accept a fixed demo code. Register once against the Spring Boot server, then sign in with that mobile number and password.

## Backend

```sh
cd ../shop_springboot_backend
./mvnw spring-boot:run -Dspring-boot.run.profiles=local
```

Server URL: `http://127.0.0.1:8080/api`. Java 17+ is required. Users and sessions persist in the backend `data/` folder; no PostgreSQL installation is required for local testing. See the backend README for PostgreSQL and environment configuration.

## Flutter

From the Flutter project:

```sh
flutter pub get
flutter run
```

Default authentication API URLs:

- Android emulator: `http://10.0.2.2:8080/api` (host machine).
- Web, iOS simulator and desktop: `http://127.0.0.1:8080/api`.

Override for a particular device/deployment:

```sh
flutter run --dart-define=AUTH_API_URL=https://your-api.example/api
```

For a physical Android phone over USB:

```sh
adb reverse tcp:8080 tcp:8080
flutter run --dart-define=AUTH_API_URL=http://127.0.0.1:8080/api
```

The backend must remain running on the development computer and the USB reverse mapping must remain active. For a standalone physical device use an HTTPS backend URL accessible to that device. `localhost` on a phone means the phone itself, not your computer. Cleartext HTTP is permitted only in the Android debug manifest; release builds should use HTTPS.

For local web verification use a permitted CORS origin:

```sh
flutter run -d chrome --web-port=8765
```

If a different port is needed, add its exact origin to backend `CORS_ORIGINS` and restart the backend. Browser secure session storage requires HTTPS or localhost. Native mobile storage uses the existing platform secure-storage plugin; passwords are never saved.

## Flow

1. Register with required name, required mobile, required password and matching confirmation. Email is optional.
2. Backend returns **complete user data + accessToken + refreshToken + both expiry timestamps**. Flutter securely saves the token pair and opens **Home directly**; no second login or mandatory profile setup is needed.
3. Login returns the same response and also opens Home directly. Missing village/crop details can be added later using the Home prompt/Profile screen, which calls `PUT /users/me/profile`.
4. Every protected request sends `Authorization: Bearer <accessToken>`. Before expiry or after one 401, the client calls `/auth/refresh`, atomically stores the rotated pair, and retries the original request once.
5. Concurrent protected calls share a single refresh request. This prevents legitimate parallel calls from accidentally reusing a rotated refresh token.
6. Startup validates through `/auth/me`; an expired access token is renewed using the saved refresh token. A temporary network error retains the tokens for retry. An invalid/expired refresh session clears both tokens and returns to login.
7. Logout from Settings or Profile calls `/auth/logout` with the refresh token, clears secure credentials/navigation and active local data. Offline logout always clears the device, but server revocation cannot be confirmed until connectivity returns.

Access tokens last 15 minutes and refresh sessions 30 days by default. Refresh rotation does not extend the original absolute session expiry. Reusing a consumed refresh token revokes that login family. The server stores only token hashes. A delayed background refresh cannot restore a session after logout because secure-storage writes are serialized and session generations are checked.

Ledger/calendar/history files are scoped by the backend's immutable user UUID. Logging in as another farmer does not show the previous farmer's local records. Logout clears active in-memory data but keeps that farmer's saved local records for their next login. Old unscoped demo data is retained on disk and is not silently assigned to a real account. Ledger/calendar cloud backup is outside this authentication change.

Authentication and farmer-provider APIs are separate: `AUTH_API_URL` selects this authentication backend. `FARMER_API_URL` optionally connects weather/mandi/AI endpoints. Unconfigured farmer tools keep their clearly labeled sample/local behavior. The new authentication backend does not pretend to implement those provider endpoints.

## Tests

```sh
flutter test
```

`test/auth_flow_test.dart` covers credential requests, safe session persistence, server errors, expired/offline sessions, refresh rotation/retry, concurrent refresh, logout races, profile update, account data isolation, login/register validation and registration directly to Home. Backend tests exercise the actual security filter and database rather than mocking password checks.

## Verified build

33 Flutter tests and 18 backend tests passed. Browser verification used the real local Spring Boot server. The Android debug APK in `build/app/outputs/flutter-apk/app-debug.apk` is built with `AUTH_API_URL=http://127.0.0.1:8080/api` for USB forwarding; it requires the local server and `adb reverse` described above. This APK does not contain database/provider credentials. Physical camera/microphone/notification checks are separate from authentication verification.

## Mobile registration contract

Register: `{name,email?,mobile,password,confirmPassword}`. Login: `{mobile,password}`. Blank email is allowed; supplied email is validated. Mobile numbers are unique and normalized to 10 digits. Both successful calls still return the full user object (including email/mobile), access/refresh tokens and expiry timestamps, and navigate straight to Home. No user ID input or OTP is used.
