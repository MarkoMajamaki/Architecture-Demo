import 'dart:io';

enum Enviroments { Production, Development }

class API {
  ///
  /// Current app enviroment
  ///
  static Enviroments enviroment = Enviroments.Development;

  ///
  /// Customer microservice api url
  ///
  static String customer = "$baseUrl/customer-api";

  ///
  /// Order microservice api url
  ///
  static String order = "$baseUrl/order-api";

  ///
  /// API base address based on current enviroment
  ///
  static String get baseUrl {
    try {
      if (Platform.isAndroid) {
        return "https://10.0.2.2";
      } else {
        return "https://localhost";
      }
    } catch (e) {
      // Exception is thrown if platform is web
      return "https://localhost";
    }
  }
}
