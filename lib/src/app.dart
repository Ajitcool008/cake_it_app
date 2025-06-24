import 'package:cake_it_app/src/features/cake_details_view.dart';
import 'package:cake_it_app/src/features/cake_list_view.dart';
import 'package:cake_it_app/src/localization/app_localizations.dart';
import 'package:flutter/material.dart';

import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'app',

          // Localization setup
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,

          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: _generateRoute,
          onUnknownRoute: _handleUnknownRoute,

          // Performance optimizations
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: MediaQuery.of(context).textScaler.clamp(
                      minScaleFactor: 0.8,
                      maxScaleFactor: 1.3,
                    ),
              ),
              child: child!,
            );
          },
        );
      },
    );
  }

  Route<dynamic> _generateRoute(RouteSettings routeSettings) {
    late Widget page;

    switch (routeSettings.name) {
      case SettingsView.routeName:
        page = SettingsView(controller: settingsController);
        break;
      case CakeDetailsView.routeName:
        page = const CakeDetailsView();
        break;
      case CakeListView.routeName:
      default:
        page = const CakeListView();
        break;
    }

    return PageRouteBuilder<dynamic>(
      settings: routeSettings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Add smooth page transitions
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Handles unknown routes gracefully
  Route<dynamic> _handleUnknownRoute(RouteSettings routeSettings) {
    return MaterialPageRoute<void>(
      settings: routeSettings,
      builder: (BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.pageNotFound),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.pageNotFound,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!
                      .pageNotFoundMessage(routeSettings.name ?? ''),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.of(context).pushNamedAndRemoveUntil(
                    CakeListView.routeName,
                    (route) => false,
                  ),
                  icon: const Icon(Icons.home),
                  label: Text(AppLocalizations.of(context)!.goHome),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
