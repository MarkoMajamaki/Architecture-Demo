import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OrderView extends StatefulWidget {
  static String route = "OrderView";
  OrderView({Key key}) : super(key: key);

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Order"),
      ),
    );
  }
}
