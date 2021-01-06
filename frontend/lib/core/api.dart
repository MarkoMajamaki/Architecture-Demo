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
      return "https://architecture-demo.info"; // minikube
    } else {
      throw new Exception();
    }
  }
}
