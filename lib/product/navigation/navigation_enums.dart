enum Routes {home, savedProducts, conError, orders, cart} 
extension RoutesExtension on Routes {
  String get name {
    switch(this){
      case Routes.home:
        return "/";
      case Routes.savedProducts:
        return "/savedProduct";
      case Routes.conError:
        return "/conError";
      case Routes.orders:
        return "/orders";
      case Routes.cart:
        return "/cart";
    }
  }
}