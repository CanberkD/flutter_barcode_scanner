import 'package:flutter/material.dart';
import 'package:flutter_barcode_app/product/pages/connection_error/view/connection_error_view.dart';
import 'package:flutter_barcode_app/product/pages/make_order/model/cart_model.dart';
import 'package:flutter_barcode_app/product/service/mysql_service.dart';
import 'package:flutter_barcode_app/product/widgets/appbar.dart';
import 'package:flutter_barcode_app/product/widgets/result_text.dart';
import 'package:flutter_barcode_app/product/widgets/snackbar.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: projectAppBar,
      body: Column(
        children: [
          Expanded(
            child: (CartModel.productBarcodes.isNotEmpty)? ListView.builder(
              itemCount: CartModel.productBarcodes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      ResultTextItem(
                          text: '',
                          title: 'Ürün ${index + 1}',
                          isCentered: true),
                      ResultTextItem(
                          text: CartModel.productBarcodes[index],
                          title: 'Ürün Barkod: ',
                          isCentered: false),
                      ResultTextItem(
                          text: CartModel.productPrices[index].toString(),
                          title: 'Adet Fiyat: ',
                          isCentered: false),
                      ResultTextItem(
                          text: CartModel.pieces[index].toString(),
                          title: 'Adet: ',
                          isCentered: false),
                      ResultTextItem(
                          text:
                              '${CartModel.productPrices[index] * CartModel.pieces[index]}',
                          title: 'Toplam Fiyat: ',
                          isCentered: false),
                      const Divider()
                    ],
                  ),
                );
              },
            ) : const Center(child: Text('Sepet Boş')),
          ),
          ResultTextItem(
              text: '${CartModel.calculateSum().toString()}: ',
              title: 'TOPLAM: ',
              isCentered: true),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton(
                onPressed: (CartModel.productBarcodes.isNotEmpty)? () {
                  MysqlConnect.setConn().then((value) {
                    if (value) {
                      MysqlConnect().approveOrder();
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ConnectionErrorView(),
                          ));
                    }
                  });
                  showSimpleSnackbar(context, const Text('Sipariş başarılı bir şekilde onaylandı.'));
                  Navigator.pop(context);
                } : null,
                child: const Text('Siparişi Onayla')),
          )
        ],
      ),
    );
  }
}
