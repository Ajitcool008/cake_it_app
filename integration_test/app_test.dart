import 'package:cake_it_app/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('CakeIt App Integration Tests', () {
    testWidgets('complete app flow test', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Test 1: App launches successfully
      expect(find.text('🎂 CakeIt App 🍰'), findsOneWidget);

      // Test 2: Loading state is shown initially
      if (find.byType(CircularProgressIndicator).evaluate().isNotEmpty) {
        expect(find.text('Loading delicious cakes...'), findsOneWidget);

        // Wait for data to load
        await tester.pumpAndSettle(const Duration(seconds: 10));
      }
      // Test 3: Test pull to refresh if cakes are loaded
      final refreshIndicator = find.byType(RefreshIndicator);
      if (refreshIndicator.evaluate().isNotEmpty) {
        await tester.fling(refreshIndicator, const Offset(0, 200), 1000);
        await tester.pump();
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Should still show the app bar after refresh
        expect(find.text('🎂 CakeIt App 🍰'), findsOneWidget);
      }
    });
  });
}
