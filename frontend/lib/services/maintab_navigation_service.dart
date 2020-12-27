import 'package:flutter/material.dart';

class MainTabNavigationService {
  List<GlobalKey<NavigatorState>> _mainTabNavigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];

  ///
  /// Selected main tab
  ///
  int selectedMainTabIndex = 0;

  ///
  /// Navigate to new screen
  ///
  Future<dynamic> navigate(String routeName, {dynamic arguments}) {
    return _mainTabNavigatorKeys[selectedMainTabIndex]
        .currentState
        .pushNamed(routeName, arguments: arguments);
  }

  ///
  /// Navigate to previous screen
  ///
  void goBack({dynamic arguments}) {
    return _mainTabNavigatorKeys[selectedMainTabIndex]
        .currentState
        .pop(arguments);
  }

  ///
  /// Could navigate back
  ///
  Future<bool> canGoBack() {
    return _mainTabNavigatorKeys[selectedMainTabIndex].currentState.maybePop();
  }

  ///
  /// Get navigation key for main tab by index
  ///
  GlobalKey<NavigatorState> getNavigationKey(int mainTabIndex) {
    return _mainTabNavigatorKeys[mainTabIndex];
  }
}
