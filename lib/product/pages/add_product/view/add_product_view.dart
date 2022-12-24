import 'package:flutter/material.dart';
import 'package:flutter_barcode_app/product/navigation/navigation_enums.dart';
import 'package:flutter_barcode_app/product/pages/connection_error/view/connection_error_view.dart';
import 'package:flutter_barcode_app/product/service/mysql_service.dart';
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

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    MysqlConnect.setConn().then((value) {
      if(!value){
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ConnectionErrorView(),));
      }
      else {
        setState(() {
          isLoading = false;          
        });
      }
    });

  }

  TextEditingController tcName = TextEditingController();
  TextEditingController tcManifacturer = TextEditingController();
  TextEditingController tcStock = TextEditingController();
  TextEditingController tcPrice = TextEditingController();
  TextEditingController tcImgUrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  MysqlConnect service = MysqlConnect();

  StorageService storageService = StorageService();
  late List<ProductModel> savedProductList = storageService.getListFromStorage() ?? List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    
    if(widget.productModel != null){
      tcName.text = widget.productModel!.name;
      tcManifacturer.text = widget.productModel!.manufacturer;
      tcStock.text = widget.productModel!.stock.toString();
      tcPrice.text = widget.productModel!.price.toString();
      tcImgUrl.text = widget.productModel!.imgUrl.toString();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: projectAppBar,
      body: isLoading ? const Center(child: CircularProgressIndicator(),) : 
        Column(
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
                input('Resim Url', tcImgUrl),
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
                textInputAction: title != 'Resim Url' ? TextInputAction.next : TextInputAction.done,
                controller: controller,
                maxLength: title == 'Resim Url' ? 128 : 24,
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

  Future<void> saveProduct() async {

    isLoading = true;

    if(_formKey.currentState!.validate()){
      ProductModel pm = ProductModel(
        barcode: widget.barcode, 
        name: tcName.text, 
        manufacturer: tcManifacturer.text, 
        stock: int.parse(tcStock.text), 
        price: double.parse(tcPrice.text), 
        imgUrl: tcImgUrl.text.toString(),
      );

      //For Local Strage ---------------------------------
      //savedProductList.add(pm);
      //storageService.saveListToStorage(savedProductList);
      //For Local Strage ---------------------------------
      
      Errors request = await service.saveProductModelToServer(pm);

      if (!mounted) return;
      if(request == Errors.noError){
        showSimpleSnackbar(context, const Text('Ürün başarılı bir şekilde eklendi.'));
        isLoading = false;
        Navigator.of(context).popAndPushNamed(Routes.savedProducts.name);
      }
      else if(request == Errors.connectionError){
        showSimpleSnackbar(context, const Text('Ürün eklenemedi. Bağlantınızı kontrol edin.'));
        isLoading = false;
        Navigator.of(context).popAndPushNamed(Routes.conError.name);
      }
      else if(request == Errors.alreadyExist){
        showSimpleSnackbar(context, const Text('Ürün eklenemedi. Bağlantınızı kontrol edin.'));
        isLoading = false;
        Navigator.pop(context);
      }
    }
  }

  void updateProduct(){
     ProductModel pm = ProductModel(
        barcode: widget.barcode, 
        name: tcName.text, 
        manufacturer: tcManifacturer.text, 
        stock: int.parse(tcStock.text), 
        price: double.parse(tcPrice.text),
        imgUrl: tcImgUrl.text.toString()
      );

      
      MysqlConnect().updateProductWithProductModel(pm).then((value) {
        if(value == Errors.noError){
          Navigator.of(context).popAndPushNamed(Routes.savedProducts.name);
        }
        else if(value == Errors.connectionError){
          Navigator.popAndPushNamed(context, Routes.conError.name);
        }
      });

      //For Local Storage.
      //storageService.updateProductList(widget.barcode, pm);
      //showSimpleSnackbar(context, const Text('Ürün başarıyla güncellendi.'));
      //Navigator.of(context).popAndPushNamed(Routes.savedProducts.name);

  }

}

