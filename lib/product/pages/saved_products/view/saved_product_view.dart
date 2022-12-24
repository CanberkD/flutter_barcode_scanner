import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_app/product/pages/add_product/view/add_product_view.dart';
import 'package:flutter_barcode_app/product/pages/connection_error/view/connection_error_view.dart';
import 'package:flutter_barcode_app/product/pages/make_order/model/cart_model.dart';
import 'package:flutter_barcode_app/product/service/mysql_service.dart';
import 'package:flutter_barcode_app/product/service/product_model.dart';
import 'package:flutter_barcode_app/product/widgets/alert.dart';
import 'package:flutter_barcode_app/product/widgets/result_text.dart';
import 'package:flutter_barcode_app/product/widgets/snackbar.dart';

import '../../../navigation/navigation_enums.dart';

class SavedProductsView extends StatefulWidget {
  const SavedProductsView({super.key});

  @override
  State<SavedProductsView> createState() => _SavedProductsViewState();
}

class _SavedProductsViewState extends State<SavedProductsView> {

  //For Local Storage.
  //final StorageService storageService = StorageService();
  //late List<ProductModel>? savedProductList = storageService.getListFromStorage();
  late List<ProductModel>? savedProductList;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    
    MysqlConnect.setConn().then((value) {
      if(value){
        
        MysqlConnect().getAllProducts().then((value) {        
          setState(() {
            savedProductList = value;
            isLoading = false;
            MysqlConnect.conn.close();
          });
        });

      }
      else{
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ConnectionErrorView(),));
      }

    });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPressed(context),
      child: Scaffold(
        appBar: AppBar(
        title: const Text('BARKOD TARAYICI'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.cart.name);
          }, icon: const Icon(Icons.shopping_cart)),
        ],
      ),
        body: isLoading ? const Center(child: CircularProgressIndicator()):
        (savedProductList != null) ? (savedProductList!.isNotEmpty) ? Column(
          mainAxisSize: MainAxisSize.max,
          children:[
            Expanded(
              child: ListView.builder(
                itemCount: savedProductList!.length,
                itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              ResultTextItem(isCentered: true, title: 'Ürün Adı: ',text: savedProductList![index].name,),
                              ResultTextItem(isCentered: false, title: 'Üretici: ',text: savedProductList![index].manufacturer,),
                              ResultTextItem(isCentered: false, title: 'Barkod: ',text: savedProductList![index].barcode,),
                              ResultTextItem(isCentered: false, title: 'Stok: ',text: savedProductList![index].stock.toString(),),
                              ResultTextItem(isCentered: false, title: 'Fiyat: ',text: savedProductList![index].price.toString(),),
                              SizedBox(width: 200, height: 200,
                              child: CachedNetworkImage(
                                    imageUrl: savedProductList![index].imgUrl!,
                                    placeholder: (context, url) => const Center(heightFactor: 1, widthFactor:1, child: SizedBox(width:50,height: 50,child: CircularProgressIndicator(),)),
                                    errorWidget: (context, url, error) => const Center(child: Text('X',style: TextStyle(color: Colors.red),)),
                                  ),
                                )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: EditButtons(savedProductList![index]),
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
      ),
    );
  }

  Align EditButtons(ProductModel productModel) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          ElevatedButton(
            onPressed: () {
            
              CartModel.addProductToList(productModel);
              showSimpleSnackbar(context, const Text('Ürün başarılı şekilde eklendi.'));
            }, 
            child: const Text('Sepete Ekle')),
          IconButton(icon: const Icon(Icons.delete_outline), onPressed: () { 
            //Button Delete.

              showSimpleApproveDialog(
                context: context, 
                title: 'Ürün Kaldırılacak', 
                description: '${productModel.name} işimli ürün silinecek. Onaylıyor musunuz?', 
                approveButtonText: 'Evet', 
                declineButtonText: 'İptal', 
                onPressedApprove: (){
                  setState(() {

                    MysqlConnect.setConn().then((value){
                      if(value){
                        MysqlConnect().removeProductWithBarcode(productModel.barcode).then((value) {
                          if(value == Errors.noError){
                            
                              MysqlConnect().getAllProducts().then((value) {
                                setState(() {
                                  savedProductList = value;                                  
                                  MysqlConnect.conn.close();
                                });
                              });
                          }
                        });

                      }
                      else{
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ConnectionErrorView(),));
                      }

                    });
                    
                  //storageService.removeFromProductList(productModel.barcode);
                  //savedProductList = storageService.getListFromStorage();
                  
                  });
                }, 
                onPressedDecline: (){});                
            },

          ),
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () { 
            //Button Edit.
            
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct(
                barcode: productModel.barcode, 
                isEdit: true, 
                productModel: productModel,
                ),
              )
            );
            },
          ),
        ],
      ),
    );
  }
}

  Future<bool> onBackPressed(BuildContext context) async {
    
    Navigator.of(context).popAndPushNamed(Routes.home.name); 
    return true;
  
  }