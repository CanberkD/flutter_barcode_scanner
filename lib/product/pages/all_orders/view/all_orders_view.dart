import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_app/product/pages/connection_error/view/connection_error_view.dart';
import 'package:flutter_barcode_app/product/pages/make_order/model/order_model.dart';
import 'package:flutter_barcode_app/product/service/mysql_service.dart';
import 'package:flutter_barcode_app/product/widgets/appbar.dart';
import 'package:flutter_barcode_app/product/widgets/result_text.dart';

class AllOrderView extends StatefulWidget {
  const AllOrderView({super.key});

  @override
  State<AllOrderView> createState() => _AllOrderViewState();
}

class _AllOrderViewState extends State<AllOrderView> {
  bool isLoading = true;
  List<OrderModel>? orderList = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    MysqlConnect.setConn().then((value) {
      if(value){
        MysqlConnect().getAllOrders().then((value) {
          setState(() {
            orderList = value;
            isLoading = false;
          });
        });
      }
      else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ConnectionErrorView(),));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: projectAppBar,
        body: isLoading ? const Center(child: CircularProgressIndicator()):
        (orderList != null) ? (orderList!.isNotEmpty) ? Column(
          mainAxisSize: MainAxisSize.max,

          children:[
            Expanded(
              child: ListView.builder(
                itemCount: orderList!.length,
                itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(
                                children: [
                                  ResultTextItem(text: orderList![index].orderBarcode, title: 'Sipariş Barkodu: ', isCentered: true),
                                  ResultTextItem(isCentered: false, title: 'Ürünler: ',text: orderList![index].productsBarcodes[index],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        height: 50,
                                         child: CachedNetworkImage(
                                          imageUrl: orderList![index].imgUrls[0],
                                          placeholder: (context, url) => const SizedBox(width:50,height: 50,child: CircularProgressIndicator(),),
                                          errorWidget: (context, url, error) => const Center(child: Text('X',style: TextStyle(color: Colors.red),)),
                                                                         ),
                                       ),
                                       SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: CachedNetworkImage(
                                          imageUrl: orderList![index].imgUrls[1],
                                          placeholder: (context, url) => const SizedBox(width:50,height: 50,child: CircularProgressIndicator(),),
                                          errorWidget: (context, url, error) => const Center(child: Text('X',style: TextStyle(color: Colors.red),)),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: CachedNetworkImage(
                                          imageUrl: orderList![index].imgUrls[2],
                                          placeholder: (context, url) => const SizedBox(width:50,height: 50,child: CircularProgressIndicator(),),
                                          errorWidget: (context, url, error) => const Center(child: Text('X',style: TextStyle(color: Colors.red),)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ResultTextItem(text: orderList![index].price.toString(), title: 'Toplam Tutar: ', isCentered: true),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                    ),
                    const Divider(thickness: 1,)
                  ],
                );
              },),
            )
          ],
        ) : 
        Center(child: Text('Kayıtlı ürün bulunamadı.', style: Theme.of(context).textTheme.titleLarge,)) : 
        Center(child: Text('Kayıtlı ürün bulunamadı.', style: Theme.of(context).textTheme.titleLarge,)),
      );
  }
}