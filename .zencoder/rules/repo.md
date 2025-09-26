# Project Overview

This repository contains the Flutter application **Ahlan Feekum**, which manages property listings, rental flows, and user interactions for both hosts and guests.

## Key Technologies
- **Framework**: Flutter (Dart)
- **Platforms**: Android, iOS, Web, Desktop (Windows, macOS, Linux)
- **State & Logic**: Feature-based organization with dependency injection utilities under `lib/core`
- **Styling**: Centralized theming via `lib/theming`

## Repository Structure
- **lib/**: Primary application source code
  - **core/**: Constants, dependency injection, networking, utilities, and error handling layers
  - **features/**: Modular feature folders (authentication, home, rent creation, navigation, search, etc.)
  - **theming/**: App-wide theme, color palette, and text styles
- **assets/**: Fonts, icons, images, and localization files (`assets/translations`)
- **android/, ios/, macos/, linux/, windows/**: Platform-specific Flutter project scaffolding
- **test/**: Widget tests and future testing utilities

## UI & Design Guidelines
- **Theme Access**: Use shared styles from `lib/theming/app_theme.dart`, `colors.dart`, and `text_styles.dart`
- **Widgets**: Keep feature-specific widgets inside their respective `features/<feature_name>/presentation` directories (if present)
- **Assets**: Reference assets defined in `pubspec.yaml`; images and icons are organized under `assets/images` and `assets/icons`

## Development Practices
1. **Null Safety**: All new Dart code should be null-safe.
2. **Localization**: New user-facing strings should be added to both `assets/translations/en.json` and `assets/translations/ar.json`.
3. **Code Style**: Adhere to the lint rules defined in `analysis_options.yaml`.
4. **Dependency Injection**: Register services through the DI modules in `lib/core/di`.

## Build & Run
1. Ensure Flutter SDK is installed and dependencies are fetched with `flutter pub get`.
2. Use `flutter run` with your desired device target. For web or desktop platforms, enable them in Flutter if not already available.
3. Release builds should follow Flutter's platform-specific build commands (e.g., `flutter build apk`, `flutter build ios`).

## Testing
- Execute `flutter test` to run the available tests.
- Add widget or unit tests alongside new functionality when possible.

This document should be updated whenever new architectural patterns, dependencies, or workflows are introduced.