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
    if (enviroment == Enviroments.Development) {
      // Minikube
      /*if (Platform.isAndroid) {
        return "192.168.64.7";
      } else {
        return "https://architecture-demo.info";
      }*/

      // Kind
      if (Platform.isAndroid) {
        return "127.0.0.1";
      } else {
        return "https://localhost";
      }
    } else {
      throw new Exception();
    }
  }
}
