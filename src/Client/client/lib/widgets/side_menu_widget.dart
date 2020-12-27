import 'package:flutkit/flutkit.dart';
import 'package:flutter/material.dart';
import 'package:producer/core/localization.dart';

class SideMenuWidget extends StatefulWidget {
  final Function onMainTabSelected;

  SideMenuWidget({Key key, this.onMainTabSelected}) : super(key: key);

  @override
  _SideMenuWidgetState createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          top: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _createMenuButton(context),
              ListTile(
                selected: _selectedIndex == 0,
                title: Text("orders_tab_name".localize(), maxLines: 1),
                leading: Icon(Icons.shopping_bag),
                onTap: () => _itemTapped(0),
              ),
              ListTile(
                selected: _selectedIndex == 1,
                title: Text("customers_tab_name".localize(), maxLines: 1),
                onTap: () => _itemTapped(1),
                leading: Icon(Icons.people),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _itemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      widget.onMainTabSelected(index);
    });
  }

  ///
  /// Create slidemenu button
  ///
  Widget _createMenuButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: MaterialButton(
            child: Icon(Icons.menu),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            onPressed: () {
              SideBar.of(context).isMenuOpen = !SideBar.of(context).isMenuOpen;
            },
          ),
        ),
      ],
    );
  }
}
