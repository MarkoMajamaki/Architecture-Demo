// Service locator instance
import 'package:get_it/get_it.dart';
import 'package:producer/services/navigation_service.dart';
import 'package:producer/viewmodels/customer_viewmodel.dart';
import 'package:producer/viewmodels/customers_viewmodel.dart';
import 'package:producer/viewmodels/order_viewmodel.dart';
import 'package:producer/viewmodels/orders_viewmodel.dart';

// Services
import 'maintab_navigation_service.dart';

// ViewModels

GetIt serviceLocator = GetIt.instance;

/// Initialize service locator
///
void setupServiceLocator() {
  // Services
  serviceLocator.registerLazySingleton(() => MainTabNavigationService());
  serviceLocator.registerLazySingleton(() => NavigationService());

  // View models
  serviceLocator.registerFactory<CustomerViewModel>(() => CustomerViewModel());
  serviceLocator
      .registerFactory<CustomersViewModel>(() => CustomersViewModel());
  serviceLocator.registerFactory<OrderViewModel>(() => OrderViewModel());
  serviceLocator.registerFactory<OrdersViewModel>(() => OrdersViewModel());
}
