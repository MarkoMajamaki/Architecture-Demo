import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OrdersView extends StatefulWidget {
  static String route = "OrdersView";
  OrdersView({Key key}) : super(key: key);

  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Order"),
      ),
    );
  }
}
