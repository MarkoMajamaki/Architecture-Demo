import 'package:flutter_guid/flutter_guid.dart';

class Customer {
  final Guid id;
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final int age;

  Customer({this.id, this.firstName, this.lastName, this.birthday, this.age});

  Customer.fromJson(Map<String, dynamic> json)
      : id = Guid(json['id']),
        firstName = json['firstName'],
        lastName = json['lastName'],
        birthday = DateTime.parse(json['birthday']),
        age = json['age'];

  Map toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthday': birthday,
      'age': age,
    };
  }
}
