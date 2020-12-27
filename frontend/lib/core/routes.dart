import 'package:frontend/views/customer_view.dart';
import 'package:frontend/views/customers_view.dart';
import 'package:frontend/views/main_view.dart';
import 'package:frontend/views/order_view.dart';
import 'package:frontend/views/orders_view.dart';

getRoutes() {
  return {
    '/': (context) => MainView(),
    MainView.route: (context) => MainView(),
    OrderView.route: (context) => OrderView(),
    OrdersView.route: (context) => OrdersView(),
    CustomerView.route: (context) => CustomerView(),
    CustomersView.route: (context) => CustomersView(),
  };
}
