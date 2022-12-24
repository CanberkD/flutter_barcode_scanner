class ProductModel {
  late final String barcode;
  late final String name;
  late final String manufacturer;
  late final int stock;
  late final double price;
  late final String? imgUrl;

  ProductModel({
    required this.barcode,
    required this.name,
    required this.manufacturer,
    required this.stock,
    required this.price,
    required this.imgUrl
  });

 ProductModel.fromJson(Map<String, dynamic> json) {
    barcode = json['barcode'];
    name = json['name'];
    manufacturer = json['manufacturer'];
    stock = json['stock'];
    price = json['price'];
    imgUrl = json['imgUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['barcode'] = barcode;
    data['name'] = name;
    data['manufacturer'] = manufacturer;
    data['stock'] = stock;
    data['price'] = price;
    data['imgUrl'] = imgUrl;
    return data;
  }
  
}