import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomerView extends StatefulWidget {
  static String route = "CustomerView";
  CustomerView({Key? key}) : super(key: key);

  @override
  _CustomerViewState createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Customer"),
      ),
    );
  }
}
