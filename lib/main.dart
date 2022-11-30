import 'package:flutter/material.dart';
import 'package:flutter_barcode_app/product/navigation/navigation_routes.dart';
import 'package:flutter_barcode_app/product/service/storage_service.dart';
import 'package:flutter_barcode_app/product/theme/theme_light.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefInstance.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barkod Tarayıcı',
      theme: ThemeLight().themeLight,
      initialRoute: "/",
      routes: NavigationRoutes().routes,
    );
  }
}