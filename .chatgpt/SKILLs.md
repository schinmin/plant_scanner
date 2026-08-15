# Project Skills

This file records the technical knowledge needed to inspect, maintain, and later repair `plant_scanner_app`.

## Core Technologies

- Flutter and Dart application development
- Android builds with Gradle, Android Gradle Plugin, Kotlin, and Java 17
- iOS/macOS builds with Xcode and CocoaPods or Swift Package Manager
- Firebase Core and Firebase Cloud Messaging configuration
- BLoC state management and `get_it` dependency injection
- Dio/Retrofit REST integration and JSON serialization
- SQLite and Shared Preferences persistence
- Local notifications, time zones, and exact-alarm scheduling
- Image Picker and platform permission configuration

## Project Structure

- `lib/auth/`: authentication and account flows
- `lib/plant_scan/`: plant scanning and crop-market data
- `lib/plant_simulation/`: farm simulations and scheduled tasks
- `lib/core/`: networking, persistence, dependency injection, constants, and notifications
- Platform directories: Android, iOS, macOS, Linux, Windows, and web build configuration

## Required Review Skills

- Reproduce dependency installation, analysis, tests, and builds from a clean checkout
- Check Flutter/Dart, Java, Gradle, Kotlin, Android SDK, Xcode, and CocoaPods compatibility
- Detect missing or misplaced Firebase-generated files
- Detect machine-specific absolute paths and untracked local configuration
- Review platform permissions and notification setup
- Guard platform-specific packages and startup services
- Separate API endpoints, credentials, and environment configuration
- Review static analysis, tests, and CI coverage

## Documentation Localization

- Write and maintain the primary README content in concise English.
- Add the corresponding Burmese documentation as the final section of `README.md`.
- Keep commands, paths, identifiers, and configuration keys unchanged in both language sections.
- When English README instructions change, update the Burmese section in the same change.
- Check that the Burmese section remains at the bottom of the file and accurately reflects the English instructions.

## Confirmed Baseline

- Inspected with Flutter `3.44.8` and Dart `3.12.2`
- `pubspec.lock` requires Dart `>=3.12.0` and Flutter `>=3.44.0`
- Before the Firebase portability fix, `flutter analyze --no-pub` reported 61 issues, including two missing-options errors
- The generated Firebase options are tracked at `lib/firebase_options.dart`
- Android Firebase initialization uses explicit Dart options and does not require a laptop-local `google-services.json`
- After the fix, analysis reports 59 pre-existing warnings and informational issues with no errors
- The widget smoke test passes and the Android debug APK builds successfully
