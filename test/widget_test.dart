// This is an example Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
//
// Visit https://flutter.dev/docs/cookbook/testing/widget/introduction for
// more information about Widget testing.

import 'package:cake_it_app/src/features/cake_details_view.dart';
import 'package:cake_it_app/src/features/cake_list_view.dart';
import 'package:cake_it_app/src/localization/app_localizations.dart';
import 'package:cake_it_app/src/settings/settings_controller.dart';
import 'package:cake_it_app/src/settings/settings_service.dart';
import 'package:cake_it_app/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CakeListView Widget Tests', () {
    late SettingsController settingsController;

    setUpAll(() async {
      settingsController = SettingsController(SettingsService());
      await settingsController.loadSettings();
    });

    Widget createTestWidget() {
      return MaterialApp(
        title: 'Test App',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
        ],
        home: const CakeListView(),
        onGenerateRoute: (RouteSettings routeSettings) {
          switch (routeSettings.name) {
            case SettingsView.routeName:
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) =>
                    SettingsView(controller: settingsController),
              );
            case CakeDetailsView.routeName:
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) => const CakeDetailsView(),
              );
            default:
              return null;
          }
        },
      );
    }

    testWidgets('should display app bar with correct title',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('🎂 CakeIt App 🍰'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('should show appropriate initial state',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Check for loading state immediately (might be brief)
      final hasLoading =
          find.byType(CircularProgressIndicator).evaluate().isNotEmpty;

      if (hasLoading) {
        // If loading state is present, verify it
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loading delicious cakes...'), findsOneWidget);
      } else {
        // If no loading state, just verify the app structure is intact
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.text('🎂 CakeIt App 🍰'), findsOneWidget);
      }
    });

    testWidgets('should display appropriate UI state after loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Wait for loading to complete
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Check what state we're actually in
      final hasRefreshIndicator =
          find.byType(RefreshIndicator).evaluate().isNotEmpty;
      final hasErrorState =
          find.byIcon(Icons.error_outline).evaluate().isNotEmpty;
      final hasEmptyState =
          find.byIcon(Icons.cake_outlined).evaluate().isNotEmpty;
      final hasLoadingState =
          find.byType(CircularProgressIndicator).evaluate().isNotEmpty;

      // Should be in one of the expected states
      expect(
          hasRefreshIndicator ||
              hasErrorState ||
              hasEmptyState ||
              hasLoadingState,
          true,
          reason:
              'App should be in one of the valid states: data loaded, error, empty, or still loading');

      // If RefreshIndicator is present (cakes loaded successfully), verify it
      if (hasRefreshIndicator) {
        expect(find.byType(RefreshIndicator), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
      }

      // If in error state, should have retry button
      if (hasErrorState) {
        expect(find.text('Try Again'), findsOneWidget);
      }

      // If in empty state, should have refresh button
      if (hasEmptyState) {
        expect(find.text('Refresh'), findsOneWidget);
      }
    });
  });
}
