import 'dart:convert';
import 'dart:io';

import 'package:flutter_guid/flutter_guid.dart';
import 'package:frontend/core/api.dart';
import 'package:frontend/models/customer.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart';

class CustomerService {
  // Allow all sertificates
  bool _certificateCheck(X509Certificate cert, String host, int port) => true;

  ///
  /// Get all customers
  ///
  Future<List<Customer>> getCustomers() async {
    // Create HttpClient which allows all certs
    HttpClient client = new HttpClient();
    client.badCertificateCallback = _certificateCheck;

    var ioClient = new IOClient(client);

    // Get custpmers
    Response response = await ioClient.get(API.customer + "/customer");

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);

      // If the server did return a 200 OK response, then parse the JSON.
      return list.map((model) => Customer.fromJson(model)).toList();
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load customers');
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

    // Get custpmers
    Response response =
        await ioClient.get(API.customer + "/customer" + "/" + id.toString());

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Customer.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load customers');
    }
  }
}
