import 'package:flutter/material.dart';
import 'package:flutter_barcode_app/product/navigation/navigation_enums.dart';
import 'package:flutter_barcode_app/product/service/product_model.dart';
import 'package:flutter_barcode_app/product/service/storage_service.dart';
import 'package:flutter_barcode_app/product/widgets/appbar.dart';
import 'package:flutter_barcode_app/product/widgets/result_text.dart';
import 'package:flutter_barcode_app/product/widgets/snackbar.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key, required this.barcode, required this.isEdit, this.productModel});
  final String barcode;
  final bool isEdit;
  final ProductModel? productModel;

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  TextEditingController tcName = TextEditingController();
  TextEditingController tcManifacturer = TextEditingController();
  TextEditingController tcStock = TextEditingController();
  TextEditingController tcPrice = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  StorageService storageService = StorageService();
  late List<ProductModel> savedProductList = storageService.getListFromStorage() ?? List.empty(growable: true);

  @override
  Widget build(BuildContext context) {

    if(widget.productModel != null){
      tcName.text = widget.productModel!.name;
      tcManifacturer.text = widget.productModel!.manufacturer;
      tcStock.text = widget.productModel!.stock.toString();
      tcPrice.text = widget.productModel!.price.toString();
    } 

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: projectAppBar,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ResultTextItem(text: widget.barcode, title: 'Barkod: ', isCentered: true),
          widget.isEdit ? const ResultTextItem(text: '', title: 'Güncelleme', isCentered: true) : const SizedBox.shrink(),
          Form(
            key: _formKey,
            child: Column(
              children: [
                input('Ürün Adı', tcName),
                input('Üretici', tcManifacturer),
                input('Fiyat', tcPrice),
                input('Stok', tcStock),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: ElevatedButton(
                    onPressed: widget.isEdit? updateProduct: saveProduct, 
                    child: widget.isEdit? const Text('Ürünü Güncelle') :const Text('Ürünü Kaydet')
                  ) ,
                ),
              ],
            ),
          )
          
    
        ]
      ),
    );
  }

  Padding input(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
            children: [
              Align(alignment: Alignment.centerLeft, child: Text(title, style: Theme.of(context).textTheme.titleSmall,)),
              TextFormField(
                textInputAction: title != 'Stok' ? TextInputAction.next : TextInputAction.done,
                controller: controller,
                maxLength: 24,
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'Boş bırakılamaz.';
                  }
                  return null;
                },
                keyboardType: (title == 'Fiyat' || title == 'Stok') ? TextInputType.number : TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  counterText: ''
                ),
              ),
            ],
          ),
    );
  
  }

  void saveProduct(){
    if(_formKey.currentState!.validate()){
      ProductModel pm = ProductModel(
        barcode: widget.barcode, 
        name: tcName.text, 
        manufacturer: tcManifacturer.text, 
        stock: int.parse(tcStock.text), 
        price: double.parse(tcPrice.text),
      );
      savedProductList.add(pm);
      storageService.saveListToStorage(savedProductList);
      
      Navigator.of(context).popAndPushNamed(Routes.savedProducts.name);
    }
  }

  void updateProduct(){
     ProductModel pm = ProductModel(
        barcode: widget.barcode, 
        name: tcName.text, 
        manufacturer: tcManifacturer.text, 
        stock: int.parse(tcStock.text), 
        price: double.parse(tcPrice.text),
      );
      storageService.updateProductList(widget.barcode, pm);

      showSimpleSnackbar(context, const Text('Ürün başarıyla güncellendi.'));

      Navigator.of(context).popAndPushNamed(Routes.savedProducts.name);

  }

}

