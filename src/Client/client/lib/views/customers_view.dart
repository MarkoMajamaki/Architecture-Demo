import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomersView extends StatefulWidget {
  static String route = "CustomersView";
  CustomersView({Key key}) : super(key: key);

  @override
  _CustomersViewState createState() => _CustomersViewState();
}

class _CustomersViewState extends State<CustomersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Customers"),
      ),
    );
  }
}
