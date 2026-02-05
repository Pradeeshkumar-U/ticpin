# Copilot Instructions for ticpin_partner

## Project Overview
This is a Flutter mobile app for partners, using GetX for navigation and state management. The codebase is organized by feature, with clear separation between UI pages, services, and constants.

## Architecture & Key Components
- **Entry Point:** `lib/main.dart` initializes the app with `GetMaterialApp` and sets `Homepage` as the root.
- **Pages:** All screens are in `lib/pages/`. Example: `homepage.dart` (main logic), `locationpage.dart`, `profilepage.dart`, and nested `login/`.
- **Services:** Business logic and integrations (e.g., QR code, location) are in `lib/services/`.
- **Constants:** API keys, colors, and sizes are in `lib/constants/`.
- **State Management:** Uses GetX (`get` package) for navigation and reactive state.
- **External APIs:** Integrates with Google Maps Geocoding API and device geolocation via `geolocator`.
- **QR Code:** Scanning and cryptography handled in `services/qrcode.dart` using `mobile_scanner` and `cryptography`.

## Developer Workflows
- **Build:**
  - Run: `flutter run` (auto-detects platform)
  - Android: `flutter build apk`
  - iOS: `flutter build ios`
- **Test:**
  - Run all tests: `flutter test`
  - Widget tests in `test/widget_test.dart`
- **Analyze/Lint:**
  - Run: `flutter analyze`
  - Lint rules in `analysis_options.yaml` (inherits from `flutter_lints`)
- **Dependencies:**
  - Managed in `pubspec.yaml`. Use `flutter pub get` to install.

## Project-Specific Patterns
- **Ignore Lints:** Uses `// ignore:` comments for suppressing lints in files (see `homepage.dart`).
- **API Keys:** Store sensitive keys in `lib/constants/apikeys.dart` (do not hardcode elsewhere).
- **Navigation:** Always use GetX (`Get.to(...)`, `GetMaterialApp`).
- **Location:** Use `Geolocator` for permissions and device location. See `homepage.dart` for usage.
- **QR/Encryption:** Use `CryptoHelper` in `services/qrcode.dart` for secure QR code handling.

## Integration Points
- **Google Maps API:** Used for reverse geocoding in `homepage.dart`.
- **Mobile Scanner:** Used for QR code scanning in `services/qrcode.dart`.
- **Platform Assets:** iOS launch images in `ios/Runner/Assets.xcassets/LaunchImage.imageset/`.

## Conventions
- **Feature Folders:** Group related files (pages, services, constants) by feature.
- **No direct platform code:** All platform-specific logic is handled via plugins.
- **Testing:** Widget tests only; no integration/e2e tests present.

## Example: Adding a New Page
1. Create a Dart file in `lib/pages/`.
2. Add your widget and logic.
3. Register navigation via GetX (`Get.to(YourPage())`).

## Useful Commands
- `flutter pub get` — Install dependencies
- `flutter run` — Start app
- `flutter test` — Run tests
- `flutter analyze` — Static analysis

---
For questions or missing details, ask the user for clarification or examples from their workflow.
