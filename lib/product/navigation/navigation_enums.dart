enum Routes {home, savedProducts,} 
extension RoutesExtension on Routes {
  String get name {
    switch(this){
      case Routes.home:
        return "/";
      case Routes.savedProducts:
        return "/savedProduct";
    }
  }
}