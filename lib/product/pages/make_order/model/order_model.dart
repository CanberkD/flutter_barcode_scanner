
class OrderModel{
  String orderBarcode;
  List<String> productsBarcodes;
  double price;
  List<String> imgUrls;

  OrderModel({
    required this.orderBarcode,
    required this.productsBarcodes,
    required this.price,
    required this.imgUrls,
  });
}