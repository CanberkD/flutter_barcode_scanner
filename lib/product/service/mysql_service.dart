import 'dart:math';

import 'package:flutter_barcode_app/product/pages/make_order/model/cart_model.dart';
import 'package:flutter_barcode_app/product/pages/make_order/model/order_model.dart';
import 'package:flutter_barcode_app/product/service/product_model.dart';
import 'package:mysql1/mysql1.dart';

class MysqlConnect {
  static late MySqlConnection conn;

  //Set connection.
  static Future<bool> setConn() async {
    try {
      conn = await MySqlConnection.connect(ConnectionSettings(
          host: '192.168.1.35',
          port: 3306,
          user: 'root',
          db: 'flutter_test',
          timeout: const Duration(seconds: 10)));
      return true;
    } catch (e) {
      return false;
    }
  }

  //Get all rows in product table
  Future<List<ProductModel>?> getAllProducts() async {
    var results = await conn.query('select * from products');

    List<ProductModel>? productList = List.empty(growable: true);

    for (var row in results) {
      productList.add(ProductModel(
          barcode: row[0],
          name: row[1],
          manufacturer: row[2],
          stock: row[3],
          price: row[4],
          imgUrl: row[5]));
    }

    return productList;
  }

  //Save a product with productModel to product table.
  Future<Errors> saveProductModelToServer(ProductModel productModel) async {
    var isAlreadyExist = await findProductWithBarcode(productModel.barcode);

    if (isAlreadyExist == null) {
      try {
        var results = await conn.query(
            'insert into products (barcode, name, manufacturer, stock, price, imgUrl) values (?, ?, ?, ?, ?, ?)',
            [
              productModel.barcode,
              productModel.name,
              productModel.manufacturer,
              productModel.stock,
              productModel.price,
              productModel.imgUrl
            ]);
        return Errors.noError;
      } catch (e) {
        return Errors.connectionError;
      }
    } else {
      return Errors.alreadyExist;
    }
  }

  //Find a product with barcode in product table.
  Future<ProductModel?> findProductWithBarcode(String barcode) async {
    try {
      var results =
          await conn.query('select * from products where barcode=$barcode');
      if (results.isNotEmpty) {
        return ProductModel(
            barcode: results.first[0],
            name: results.first[1],
            manufacturer: results.first[2],
            stock: results.first[3],
            price: results.first[4],
            imgUrl: results.first[5]);
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Errors> removeProductWithBarcode(String barcode) async {
    try {
      var results =
          await conn.query('delete from products where barcode=$barcode');
      if (results.affectedRows == 1) {
        return Errors.noError;
      }
      return Errors.connectionError;
    } catch (e) {
      print(e.toString());
      return Errors.connectionError;
    }
  }

  Future<Errors> updateProductWithProductModel(
      ProductModel productModel) async {
    try {
      var results = await conn.query(
          'UPDATE products SET barcode = ?, name = ?, manufacturer = ?, stock = ?, price = ?, imgUrl = ? WHERE barcode = ?',
          [
            productModel.barcode,
            productModel.name,
            productModel.manufacturer,
            productModel.stock,
            productModel.price,
            productModel.imgUrl,
            productModel.barcode,
          ]);
      if (results.affectedRows == 1) {
        return Errors.noError;
      }
      return Errors.connectionError;
    } catch (e) {
      print(e.toString());
      return Errors.connectionError;
    }
  }

  Future<Errors> makeAndOrderWithOrderModel(OrderModel orderModel) async {
    //For old order model.
    //try {
    //  var results = await conn.query(
    //      'INSERT INTO `orders` (`id`, `product_barcode`, `product_name`, `piece`, `price`, `imgUrl`) VALUES (?, ?, ?, ?, ?, ?)',
    //      [
    //        0,
    //        orderModel.productModel.barcode,
    //        orderModel.productModel.name,
    //        orderModel.piece,
    //        orderModel.price,
    //        orderModel.productModel.imgUrl
    //      ]);
    //  print('NOError');
    //  return Errors.noError;
    //} catch (e) {
    //  print(e.toString());
    //  return Errors.connectionError;
    //}
    return Errors.noError;
  }

  //For old order model.
  //Future<List<OrderModel>?> getAllOrders() async {
//
  //  var results = await conn.query('select * from orders');
  //  List<OrderModel>? orderList = List.empty(growable: true);
//
  //  for (var row in results) {
  //    orderList.add(OrderModel(
  //        productModel: ProductModel(
  //            barcode: row[1],
  //            name: row[2],
  //            manufacturer: 'M',
  //            price: 1,
  //            stock: 1,
  //            imgUrl: row[5]),
  //        piece: row[3],
  //        price: row[4]));
  //  }
//
    //return orderList;
  //}

//ORDER++++++++++++++++++++++++++++++++++++++++++

Future<List<OrderModel>?> getAllOrders() async {
    var results = await conn.query('select * from t_order');

    String orderBarcode = '';
    List<OrderModel>? orderList = List.empty(growable: true);
    List<String>? barcodeList = List.empty(growable: true);
    List<String>? imgList = List.empty(growable: true);
    double sum = 0;

    for (var row in results) {
      var results2 = await conn.query('select * from order_items where orderBarcode = ${row[1]}');
      for (var row2 in results2){
        orderBarcode = row2[1];
        barcodeList.add(row2[2]);
        sum = sum + int.parse(row2[4].toString());
        imgList.add(row2[5]);
      }

    }

     orderList.add(OrderModel(
          orderBarcode: orderBarcode, 
          productsBarcodes:barcodeList, 
          price: sum, 
          imgUrls: imgList));

    return orderList;
  }

  Future<String> getImgUrl(String barcode) async {
    var results = await conn.query('select imgUrl from products where barcode = $barcode') ;
    return results.first[0];
  }

  void approveOrder() {
    var barcode = "";
    var randomnumber = Random();
    //chnage i < 15 on your digits need
    for (var i = 0; i < 13; i++) {
      barcode = barcode + randomnumber.nextInt(9).toString();
    }

    try {
      var results = conn.query(
          'insert into t_order (id, order_barcode) values (?, ?)',
          [
            0,
            barcode,
          ]);
      
        for(var i = 0; i< CartModel.productBarcodes.length; i++){
          try{
          var results = conn.query(
          'insert into order_items (id, order_barcode, productBarcode, piece, sum, imgUrl) values (?, ?, ?, ?, ?, ?)',
          [
            0,
            barcode,
            CartModel.productBarcodes[i],
            CartModel.pieces[i],
            CartModel.productPrices[i]*CartModel.pieces[i],
            CartModel.imgUrls[i]
          ]);
          }
          catch(e) {print(e);}
          
        }
        

    } catch (e) {print(e);}
  }
}

//ORDER------------------------------------------

enum Errors { noError, connectionError, alreadyExist }
