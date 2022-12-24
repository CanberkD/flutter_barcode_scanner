import 'package:flutter/material.dart';
import 'package:flutter_barcode_app/product/pages/all_orders/view/all_orders_view.dart';
import 'package:flutter_barcode_app/product/pages/connection_error/view/connection_error_view.dart';
import 'package:flutter_barcode_app/product/pages/homepage/view/homepage_view.dart';
import 'package:flutter_barcode_app/product/pages/order_cart/view/cart_view.dart';
import 'package:flutter_barcode_app/product/pages/saved_products/view/saved_product_view.dart';

import 'navigation_enums.dart';

class NavigationRoutes {
  final Map<String, Widget Function(BuildContext)> routes = {
        Routes.home.name : (context) => const HomePageView(),
        Routes.savedProducts.name : (context) => const SavedProductsView(), 
        Routes.orders.name : (context) => const AllOrderView(), 
        Routes.cart.name : (context) => const CartView(), 
  };

  final Map<String, Widget Function(BuildContext)> errorRoute = {
        Routes.conError.name : (context) => const ConnectionErrorView(), 
  };
}


