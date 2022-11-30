import 'package:flutter/material.dart';
import 'package:flutter_barcode_app/product/navigation/navigation_enums.dart';
import 'package:flutter_barcode_app/product/pages/homepage/model/barcode_model.dart';
import 'package:flutter_barcode_app/product/widgets/appbar.dart';
import 'package:lottie/lottie.dart';


class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {

  @override
  Widget build(BuildContext context) {

   //TODO: For test. Remove this later.
   //ProductModel pm1 = ProductModel(barcode: '12345678900', name: 'testName1', manufacturer: 'testmanufacturer1', stock: -1, price: -1);
   //ProductModel pm2 = ProductModel(barcode: '23456789001', name: 'testName2', manufacturer: 'testmanufacturer2', stock: -1, price: -1);
   //ProductModel pm3 = ProductModel(barcode: '34567890012', name: 'testName3', manufacturer: 'testmanufacturer3', stock: -1, price: -1);
   //ProductModel pm4 = ProductModel(barcode: '43456789003', name: 'testName4', manufacturer: 'testmanufacturer4', stock: -1, price: -1);
   //ProductModel pm5 = ProductModel(barcode: '56789001234', name: 'testName5', manufacturer: 'testmanufacturer5', stock: -1, price: -1);

    //List<ProductModel> pmList = [pm1, pm2, pm3, pm4, pm5];
    //StorageService().saveListToStorage(pmList);
    //TODO: --------------------------------

    return Scaffold(
      appBar: projectAppBar,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          LottieAnim(),
          Buttons(),
        ]
      ),
    );
  }

  LottieBuilder LottieAnim() {
    return Lottie.asset(      
          'assets/lottie/lottie_barcod.json',
          alignment: Alignment.topCenter,
          height: HomepageSizes.barcodHeight.value(),
          width: double.infinity
        );
  }

  Expanded Buttons() {
    return Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: HomepageSizes.barcodHeight.value()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    BarcodeScan.scan(context);
                  }, 
                  child: const Text('Tarama Başlat')
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, Routes.savedProducts.name);
                  },
                child: const Text('Kayıtlı Ürünler')),
              ],
            ),
          ),
        );
  }

  
}

enum HomepageSizes{barcodHeight}
extension HomepageSizesExtension on HomepageSizes{
  double value(){
    switch(this){
      case HomepageSizes.barcodHeight:
        return 200;
    }
  }
}