import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/models/customer.dart';
import 'package:frontend/services/servicelocator.dart';
import 'package:frontend/viewmodels/customers_viewmodel.dart';

class CustomersView extends StatefulWidget {
  static String route = "CustomersView";
  CustomersView({Key key}) : super(key: key);

  @override
  _CustomersViewState createState() => _CustomersViewState();
}

class _CustomersViewState extends State<CustomersView> {
  CustomersViewModel _viewModel = serviceLocator<CustomersViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _createCustomersListWidget(),
    );
  }

  Widget _createCustomersListWidget() {
    return FutureBuilder(
      future: _viewModel.getCustomers(),
      builder: (BuildContext build, AsyncSnapshot<List<Customer>> snap) {
        if (snap.hasData) {
          return ListView.builder(
            itemCount: snap.data.length,
            itemBuilder: (context, index) {
              return _createCustomerWidget(snap.data[index]);
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _createCustomerWidget(Customer data) {
    return ListTile(
      title: Text(data.firstName + " " + data.lastName),
      subtitle: Text(data.age.toString()),
    );
  }
}
