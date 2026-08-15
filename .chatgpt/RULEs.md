# Project Rules

## Change Control

- Do not modify application source or build configuration without user approval.
- Prioritize reproducible builds from a clean Git checkout.
- Never commit `android/local.properties`, `.dart_tool/`, build output, or IDE-specific files.
- Pin the Flutter version with a project-level version manager or explicit setup documentation.
- Document required Java, Android SDK, Xcode, and CocoaPods versions.
- When dependencies change, review `pubspec.lock` and verify the effective Flutter/Dart requirements.

## README Language

- Keep English as the primary language at the top of `README.md`.
- Keep a Burmese translation section at the bottom of `README.md`.
- Every material README update must modify both language sections in the same commit.
- The Burmese section must preserve the meaning of the English instructions, warnings, commands, paths, and configuration names.
- Do not place English-only sections after the Burmese section.

## Firebase and Secrets

- Define one team-wide provisioning method for `lib/firebase_options.dart`, Android `google-services.json`, and Apple `GoogleService-Info.plist` files.
- If generated Firebase configuration is not committed, generate it or retrieve it from secure storage before local and CI builds.
- Keep the generated output path consistent with application imports.
- Never place access tokens, signing keys, service-account credentials, or other secrets in source or logs.
- If Firebase client configuration is committed, separately enforce Firebase Security Rules, API-key restrictions, and environment isolation.

## Build and Quality Gates

- A change is not complete until `flutter pub get`, `flutter analyze`, `flutter test`, and the relevant target-platform debug build pass.
- Run Android builds on a clean CI runner; run iOS builds on a macOS runner.
- Keep tests aligned with current features; do not restore the obsolete Flutter counter-template test.
- Do not suppress analyzer errors or warnings merely to pass checks.
- Declare directly imported packages as direct dependencies in `pubspec.yaml`.
- Initialize platform-specific services only after confirming that the current platform is supported.

## Release and Security

- Never ship Android releases signed with the debug key. Supply release signing credentials through secure storage.
- Use environment-based configuration for staging and production API endpoints.
- Do not log authorization headers, bearer tokens, personal data, or complete production API responses.
- Request only required platform permissions and verify both manifest declarations and runtime flows.
- Firebase, notification, and exact-alarm failures must not terminate startup through unhandled exceptions.

## Work Order

- Fix build blockers first. Address naming, deprecated APIs, and style issues in separate passes.
