import 'package:flutter/material.dart';
import 'package:flutter_barcode_app/product/pages/homepage/view/homepage_view.dart';
import 'package:flutter_barcode_app/product/pages/saved_products/view/saved_product_view.dart';

import 'navigation_enums.dart';

class NavigationRoutes {
  final Map<String, Widget Function(BuildContext)> routes = {
        Routes.home.name : (context) => const HomePageView(),
        Routes.savedProducts.name : (context) => SavedProductsView(), 
  };
}

