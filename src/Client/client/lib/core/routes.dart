import 'package:producer/views/customer_view.dart';
import 'package:producer/views/customers_view.dart';
import 'package:producer/views/main_view.dart';
import 'package:producer/views/order_view.dart';
import 'package:producer/views/orders_view.dart';

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
