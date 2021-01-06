import 'package:flutter/widgets.dart';
import 'package:frontend/models/customer.dart';
import 'package:frontend/services/customers_service.dart';
import 'package:frontend/services/servicelocator.dart';

class CustomersViewModel extends ChangeNotifier {
  static String route = "CustomersView";

  CustomerService _customerService = serviceLocator<CustomerService>();

  Future<List<Customer>> getCustomers() async {
    return await _customerService.getCustomers();
  }
}
