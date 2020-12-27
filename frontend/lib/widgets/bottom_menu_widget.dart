import 'package:flutter/material.dart';
import 'package:frontend/core/localization.dart';
import 'package:frontend/services/maintab_navigation_service.dart';
import 'package:frontend/services/servicelocator.dart';

class BottomMenuWidget extends StatefulWidget {
  final Function onMainTabSelected;
  BottomMenuWidget({Key key, this.onMainTabSelected}) : super(key: key);

  @override
  _BottomMenuWidgetState createState() => _BottomMenuWidgetState();
}

class _BottomMenuWidgetState extends State<BottomMenuWidget> {
  MainTabNavigationService _navigationService =
      serviceLocator<MainTabNavigationService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "orders_tab_name".localize(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "customers_tab_name".localize(),
          ),
        ],
        currentIndex: _navigationService.selectedMainTabIndex,
        onTap: widget.onMainTabSelected,
      ),
    );
  }
}
