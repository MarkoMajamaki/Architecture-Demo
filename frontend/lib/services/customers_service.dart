import 'dart:convert';
import 'dart:io';

import 'package:frontend/core/guid.dart';
import 'package:frontend/core/api.dart';
import 'package:frontend/models/customer.dart';
import 'package:http/io_client.dart';

class CustomerService {
  // Allow all sertificates
  bool _certificateCheck(X509Certificate cert, String host, int port) => true;

  ///
  /// Get all customers
  ///
  Future<List<Customer>> getCustomers() async {
    try {
      // Create HttpClient which allows all certs
      HttpClient client = new HttpClient();
      client.badCertificateCallback = _certificateCheck;

      var ioClient = new IOClient(client);

      // Get customers
      Uri url = Uri.parse(API.customer + "/customer");
      final response = await ioClient.get(url);

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
    // Create HttpClient which allows all certs
    HttpClient client = new HttpClient();
    client.badCertificateCallback = _certificateCheck;

    var ioClient = new IOClient(client);

    // Get customers
    Uri url = Uri.parse(API.customer + "/customer" + "/" + id.toString());
    final response = await ioClient.get(url);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Customer.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load customers');
    }
  }
}
