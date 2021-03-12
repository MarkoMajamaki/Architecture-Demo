import 'dart:async';

import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigatorKey =
      new GlobalKey<NavigatorState>();

  ///
  /// Navigate to new screen
  ///
  Future<dynamic> navigate(String routeName, {dynamic arguments}) {
    return _navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  ///
  /// Navigate to previous screen
  ///
  void goBack({dynamic arguments}) {
    return _navigatorKey.currentState!.pop(arguments);
  }

  ///
  /// Could navigate back
  ///
  Future<bool> canGoBack() {
    return _navigatorKey.currentState!.maybePop();
  }

  ///
  /// Get navigator key for login
  ///
  GlobalKey<NavigatorState> getNavigatorKey() {
    return _navigatorKey;
  }
}
