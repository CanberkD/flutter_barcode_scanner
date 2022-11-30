import 'package:flutter/material.dart';
import 'package:flutter_barcode_app/product/consts/colors.dart';


class ThemeLight{
  ThemeData themeLight = ThemeData(
    primarySwatch: Colors.grey,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: ProjectColors.mainWhite),
      color: ProjectColors.mainBlack,
      titleTextStyle: TextStyle(color: ProjectColors.mainWhite),
      centerTitle: true
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        backgroundColor: ProjectColors.mainBlack,
        foregroundColor: ProjectColors.mainWhite,
        shape: const ContinuousRectangleBorder(),
        minimumSize: const Size(200, 50)
        
      )
    )
  );
}