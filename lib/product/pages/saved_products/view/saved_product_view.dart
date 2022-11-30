import 'package:flutter/material.dart';
import 'package:flutter_barcode_app/product/pages/add_product/view/add_product_view.dart';
import 'package:flutter_barcode_app/product/service/product_model.dart';
import 'package:flutter_barcode_app/product/service/storage_service.dart';
import 'package:flutter_barcode_app/product/widgets/alert.dart';
import 'package:flutter_barcode_app/product/widgets/appbar.dart';
import 'package:flutter_barcode_app/product/widgets/result_text.dart';

import '../../../navigation/navigation_enums.dart';

class SavedProductsView extends StatefulWidget {
  const SavedProductsView({super.key});

  @override
  State<SavedProductsView> createState() => _SavedProductsViewState();
}

class _SavedProductsViewState extends State<SavedProductsView> {
  final StorageService storageService = StorageService();
  late List<ProductModel>? savedProductList = storageService.getListFromStorage();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPressed(context),
      child: Scaffold(
        appBar: projectAppBar,
        body: (savedProductList != null) ? (savedProductList!.isNotEmpty) ? Column(
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
                          ResultTextItem(isCentered: true, title: 'Ürün Adı: ',text: savedProductList![index].name,),
                          ResultTextItem(isCentered: false, title: 'Üretici: ',text: savedProductList![index].manufacturer,),
                          ResultTextItem(isCentered: false, title: 'Barkod: ',text: savedProductList![index].barcode,),
                          ResultTextItem(isCentered: false, title: 'Stok: ',text: savedProductList![index].stock.toString(),),
                          ResultTextItem(isCentered: false, title: 'Fiyat: ',text: savedProductList![index].price.toString(),),
                          EditButtons(savedProductList![index]),
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
                  storageService.removeFromProductList(productModel.barcode);
                  savedProductList = storageService.getListFromStorage();
                  
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