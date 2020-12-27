import 'package:frontend/core/constants.dart';
import 'package:flutkit/flutkit.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/routes.dart';
import 'package:frontend/core/theme.dart';
import 'package:frontend/services/maintab_navigation_service.dart';
import 'package:frontend/services/servicelocator.dart';
import 'package:frontend/views/customers_view.dart';
import 'package:frontend/views/orders_view.dart';
import 'package:frontend/widgets/bottom_menu_widget.dart';
import 'package:frontend/widgets/side_menu_widget.dart';

class MainView extends StatefulWidget {
  static String route = "MainView";
  MainView({Key key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  // Set navigation service selectedMainTabIndex
  MainTabNavigationService _mainTabNavigationService =
      serviceLocator<MainTabNavigationService>();

  ///
  /// Build shell
  ///
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // let system handle back button if we're on the first route
      onWillPop: () async => !await _mainTabNavigationService.canGoBack(),
      child: (isMobileClient(context)) ? _frontendShell() : _desktopShell(),
    );
  }

  ///
  /// Create main view frontend content with bottom tab navigation
  ///
  Widget _frontendShell() {
    return Scaffold(
      body: _content(),
      bottomNavigationBar: BottomMenuWidget(
        onMainTabSelected: _onMainTabSelected,
      ),
    );
  }

  ///
  /// Create view desktop content with left tabs
  ///
  Widget _desktopShell() {
    return SideBar(
      menuWidth: 250,
      menuNarrowWidth: 60,
      contentBehavior: ContentBehavior.Resize,
      menuOpenMode: MenuOpenMode.Default,
      menuCloseMode: MenuCloseMode.Narrow,
      subMenuOpenMode: SubMenuOpenMode.Floating,
      verticalSeparatorThickness: 1,
      verticalSeparatorColor: Colors.black12,
      menu: SideMenuWidget(
        onMainTabSelected: _onMainTabSelected,
      ),
      content: _content(),
    );
  }

  ///
  /// Create content
  ///
  Widget _content() {
    return Stack(
      children: [
        // Add all children to stack, but only one is rendered
        _buildMainTabNavigator(0),
        _buildMainTabNavigator(1),
      ],
    );
  }

  ///
  /// Update selected main tab index to navigation service
  ///
  void _onMainTabSelected(int index) {
    setState(() {
      _mainTabNavigationService.selectedMainTabIndex = index;
    });
  }

  ///
  /// Control which route is visible
  ///
  Widget _buildMainTabNavigator(int index) {
    return Offstage(
      // Show only if tab is selected
      offstage: _mainTabNavigationService.selectedMainTabIndex != index,
      child: MaterialApp(
        theme: getTheme(),
        debugShowCheckedModeBanner: false,
        navigatorKey: _mainTabNavigationService.getNavigationKey(index),
        initialRoute: getMainTabInitialRoute(index),
        routes: getRoutes(),
      ),
    );
  }

  ///
  /// Get navigation key for main tab by index
  ///
  getMainTabInitialRoute(int mainTabIndex) {
    switch (mainTabIndex) {
      case 0:
        return OrdersView.route;
      case 1:
        return CustomersView.route;
      case 2:
      default:
        throw new Exception();
    }
  }
}
