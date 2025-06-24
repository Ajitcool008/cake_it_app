# Waracle Tech Test - Flutter :technologist:

🧁 CakeIt App – Technical Notes & Improvements

🔧 Flutter Environment

Flutter: 3.32.4 (Stable)

Dart: 3.8.1

✅ Major Bug Fixes

1. Incorrect Navigation Data

File: cake_list_view.dart

Fixed by passing the selected cake.toJson() instead of static data.

// Fixed code
arguments: cake.toJson(),

2. Theme Dropdown Mismatch

File: settings_view.dart
The dark theme option was incorrectly linked to ThemeMode.light.

Corrected to use ThemeMode.dark so the selection actually applies the dark mode.

// Corrected
value: ThemeMode.dark,

🧱 Architectural Improvements

1. Stateless UI with Service-Based State

Replaced most StatefulWidgets with StatelessWidgets and used a service pattern with ChangeNotifier.
This reduced widget rebuilds and simplified logic, making the app more testable and performant.

2. Centralized CakeService

- Built a singleton service to:

- Fetch and cache cakes from API

- Handle errors and state updates

- Expose refresh and retry mechanisms


3. Robust Error Handling

Now handles:

- No internet (SocketException)

- Timeout errors

- Bad responses (HttpException)

- JSON format issues

- Image load failures

4. Localization Integration

- All user-facing strings have been moved to localization files using Flutter's intl approach:

- Created app_localizations.dart and locale-specific files like app_localizations_en.dart

- Integrated localization into widgets and error messages

- Used AppLocalizations.of(context) throughout the UI for proper internationalization

🎨 UI/UX Enhancements

Responsive Layouts

- Images scale with correct aspect ratio

- Text truncates gracefully

- Spacing and padding adjust to screen size

- SafeArea used for edge-to-edge devices


Loading States

- Circular indicators and placeholder visuals

- RefreshIndicator for pull-to-refresh support


Error States

- Friendly retry messages

- Fallback visuals for broken images

- Empty state messaging

✨ Features Added

1. Pull-to-Refresh

Added native platform support for refreshing data.

RefreshIndicator(
  onRefresh: cakeService.refreshCakes,
  child: ListView.builder(...),
)

2. Better Image Loading

- Used placeholders during load

- Error fallback images


3. Improved Navigation

- Page transitions are smooth

- Deep link-ready architecture

- Restores previous state where supported

🧼 Code Quality

Exception Handling

All network actions are properly guarded:

try {
  // API call
} on SocketException {
  _setError('No internet...');
} catch (e) {
  debugPrint('Unexpected error: $e');
}

Model Validation

- Null safety enforced

- Clear separation between required/optional fields

- Clean and immutable data models

String Localization

- All hardcoded strings removed from widgets

- Used .arb files for language support

- Consistent use of AppLocalizations.of(context)
  This improves maintainability and makes future translations seamless.

🧪 Some Test cases I wrote to Demonstrate  ( Need to write more )

Coverage

- Unit tests for logic and models

- Widget tests for key UIs

- End-to-end tests for full user flows

📁 Project Structure

cake_it_app/
├── lib/
│   ├── main.dart
│   └── src/
│       ├── app.dart
│       ├── features/
│       │   ├── cake.dart
│       │   ├── cake_service.dart
│       │   ├── cake_list_view.dart
│       │   └── cake_details_view.dart
│       ├── settings/
│       │   ├── settings_controller.dart
│       │   ├── settings_service.dart
│       │   └── settings_view.dart
│       └── localization/
│           ├── app_localizations.dart
│           └── app_localizations_en.dart





🧰 Recommended Libraries (Not Used)

If allowed, I would integrate:


State

- riverpod or bloc for better scalability and testability


Networking

- dio for flexible requests

- retry for retry logic


UI

- cached_network_image

- shimmer for skeleton loaders


Data Modeling

- freezed, equatable, json_annotation for clean and consistent data classes

Storage
- Shared Preferences or anyone for store locally like selected theme

DevOps & Architecture

- Crash reporting + analytics

- CI/CD setup

- Code coverage and health tools

- Domain-driven structure and DI





📱 Device Compatibility

Supported Devices

- iOS 12.0+ (SE to latest)

- Android API 21+

- Designed to work from 4" to 6.7" screen sizes (Device preview package is there to test different sizes)

- Tested in light/dark mode and landscape


🌟 Final Thoughts

This version of the CakeIt app reflects clean, scalable, and production-ready Flutter practices. It features:

- A modern UI built with Material 3

- Service-driven architecture using ChangeNotifier

- Full localization support

- Solid error handling

- Strong performance and testing foundation

The project is easy to maintain, easy to test, and ready for future features or scale.

Time Spend: 3:30 Hr (Including writing notes.md, Test cases)