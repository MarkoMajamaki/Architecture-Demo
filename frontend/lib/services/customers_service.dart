import 'dart:convert';
import 'package:frontend/core/guid.dart';
import 'package:frontend/core/api.dart';
import 'package:frontend/models/customer.dart';
import 'package:http/http.dart' as http;

class CustomerService {
  ///
  /// Get all customers
  ///
  Future<List<Customer>> getCustomers() async {
    try {
      Uri url = Uri.parse(API.customer + "/customer");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);

        // If the server did return a 200 OK response, then parse the JSON.
        return list.map((model) => Customer.fromJson(model)).toList();
      } else {
        // If the server did not return a 200 OK response, then throw an exception.
        throw Exception('Failed to load customers');
      }
    } catch (e) {
      print(e);
      return List.empty();
    }
  }

  ///
  /// Get single customer by id
  ///
  Future<Customer> getCustomer(Guid id) async {
    // Get customers
    Uri url = Uri.parse(API.customer + "/customer" + "/" + id.toString());
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Customer.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load customers');
    }
  }
}
