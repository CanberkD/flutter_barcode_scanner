import 'package:flutter_barcode_app/product/service/product_model.dart';
import 'package:flutter_barcode_app/product/service/storage_service.dart';

class BarcodeService{

  ProductModel? findModelWithBarcode(String barcode){

    StorageService ss = StorageService();

    List<ProductModel> savedProductList = ss.getListFromStorage() ?? List.empty();

    //Barcode scan failed. No requirement for search.
    if(barcode != '-1'){
      for(var item in savedProductList){
        if(item.barcode == barcode){
          return item;
        }
      }
    }

    return null;
  }

}