import 'package:flutter_barcode_app/product/service/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPrefInstance {
  //SharedPreference instance singleton.
  static late SharedPreferences instance;

  static Future<SharedPreferences> init() async => instance = await SharedPreferences.getInstance();
}

class StorageService{

  late List<ProductModel> productList = List.empty(growable: true);

  StorageService(){
    productList = getListFromStorage() ?? [];
  }

  //Get saved list from storage
  List<ProductModel>? getListFromStorage(){
    final itemsString = SharedPrefInstance.instance.getStringList(StorageKeys.products.name);
    if (itemsString?.isNotEmpty ?? false) {
      return itemsString!.map((element) {
        final json = jsonDecode(element);
        if (json is Map<String, dynamic>) {
          return ProductModel.fromJson(json);
        }
        return ProductModel(barcode: '', name: '', manufacturer: 'manufacturer', stock: 0, price: 0, imgUrl: '');
      }).toList();
    }
    return null;
  }

  //Save new list to storage.
  void saveListToStorage(List<ProductModel> list){

    List<String> jsonRecordedMoodModelList = list.map(
      (element) => jsonEncode(
        element.toJson()
      )
    ).toList();

    SharedPrefInstance.instance.setStringList(StorageKeys.products.name, jsonRecordedMoodModelList);
  }

  //Remove item from productList with barcode.[Check todo]
  void removeFromProductList(String itemsBarcode){
    //TODO:This method not null safety. If you gonna use it another page except save_product, check this out.
    //TODO:Bu metod null safety değil. Eğer save_product haricinde bir yerde kullanacaksan kontrol et.
    List<ProductModel> list = getListFromStorage()!;
    list.removeWhere((item) => item.barcode == itemsBarcode);
    saveListToStorage(list);
  }
  
  //Update item from productList with barcode.[Check todo]
  void updateProductList(String itemsBarcode, ProductModel updatedProductModel){
    //TODO:This method not null safety. If you gonna use it another page except save_product, check this out.
    //TODO:Bu metod null safety değil. Eğer save_product haricinde bir yerde kullanacaksan kontrol et.
    List<ProductModel> list = getListFromStorage()!;
    list[list.indexWhere((element) => element.barcode == itemsBarcode)] = updatedProductModel;
    saveListToStorage(list);
  }

}

enum StorageKeys {
  products
}