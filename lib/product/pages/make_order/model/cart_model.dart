import '../../../service/product_model.dart';

class CartModel{
  static List<String> productBarcodes = List.empty(growable: true);
  static List<double> productPrices = List.empty(growable: true);
  static List<int> pieces = List.empty(growable: true);
  

  static void addProductToList(ProductModel pm){
    //If product is already in cart, adds one more.
    if(productBarcodes.contains(pm.barcode)){
      pieces[productBarcodes.indexOf(pm.barcode)]++;
    }
    //First time adding this product to cart.
    else{
      productBarcodes.add(pm.barcode);
      productPrices.add(pm.price);
      pieces.add(1);
    }
  }

  static double calculateSum(){
    double sum = 0;
    for(int i = 0; i < productBarcodes.length; i++){
      sum += productPrices[i]*pieces[i];
    }
    return sum;
  }


}