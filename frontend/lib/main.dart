import 'package:flutter/material.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/services/servicelocator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend/views/main_view.dart';

import 'core/localization.dart';
import 'core/routes.dart';
import 'core/theme.dart';

void main() {
  setupServiceLocator();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: getTheme(),
    navigatorKey: serviceLocator<NavigationService>().getNavigatorKey(),
    initialRoute: MainView.route,
    routes: getRoutes(),
    supportedLocales: [
      Locale("fi", "FI"),
      Locale("en", "US"),
    ],
    localizationsDelegates: [
      // A class which loads the translations from JSON files
      Localization.delegate,
      // Built-in localization of basic text for Material widgets
      GlobalMaterialLocalizations.delegate,
      // Built-in localization for text direction LTR/RTL
      GlobalWidgetsLocalizations.delegate,
    ],
    // Returns a locale which will be used by the app
    localeResolutionCallback: (locale, supportedLocales) {
      // Check if the current device locale is supported
      for (var supportedLocale in supportedLocales) {
        if (locale != null &&
            supportedLocale.languageCode == locale.languageCode &&
            supportedLocale.countryCode == locale.countryCode) {
          return supportedLocale;
        }
      }
      // If the locale of the device is not supported, use the first one
      // from the list (English, in this case).
      return supportedLocales.first;
    },
  ));
}
