// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => '🎂 CakeIt App 🍰';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get themeDescription => 'Choose your preferred theme mode';

  @override
  String get systemDefault => 'System Default';

  @override
  String get lightTheme => 'Light Theme';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get cakeDetails => 'Cake Details';

  @override
  String get loadingCakes => 'Loading delicious cakes...';

  @override
  String get errorTitle => 'Oops! Something went wrong';

  @override
  String get unknownError => 'Unknown error occurred';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get noCakesFound => 'No cakes found';

  @override
  String get pullToRefresh => 'Pull down to refresh or try again later';

  @override
  String get refresh => 'Refresh';

  @override
  String get pageNotFound => 'Page Not Found';

  @override
  String pageNotFoundMessage(String routeName) {
    return 'The requested page \"$routeName\" could not be found.';
  }

  @override
  String get goHome => 'Go Home';

  @override
  String get imageNotAvailable => 'Image not available';

  @override
  String get loadingImage => 'Loading image...';

  @override
  String get noImageAvailable => 'No image available';

  @override
  String get unknownCake => 'Unknown Cake';

  @override
  String get noDescriptionAvailable => 'No description available';
}
