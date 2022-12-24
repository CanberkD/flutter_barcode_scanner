import 'package:flutter/material.dart';
import 'package:flutter_barcode_app/product/consts/colors.dart';
import 'package:flutter_barcode_app/product/pages/connection_error/view/connection_error_view.dart';
import 'package:flutter_barcode_app/product/pages/scancompleted/view/scan_complated_view.dart';
import 'package:flutter_barcode_app/product/service/mysql_service.dart';
import 'package:flutter_barcode_app/product/service/product_model.dart';
import 'package:flutter_barcode_app/product/widgets/appbar.dart';
import 'package:flutter_barcode_app/product/widgets/result_text.dart';

class MakeOrderView extends StatefulWidget {
  const MakeOrderView({super.key, required this.productModel});
  final ProductModel productModel;

  @override
  State<MakeOrderView> createState() => _MakeOrderViewState();
}

class _MakeOrderViewState extends State<MakeOrderView> {
  final TextEditingController controller1 = TextEditingController();
  double price = 0;

  @override
  void initState() {
    super.initState();
    controller1.text = '1';
    price = widget.productModel.price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: projectAppBar,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
        child: Column(
          children: [
            ResultContainer(widget.productModel, context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 32.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top:16.0),
                      child: IconButton(icon: const Icon(Icons.remove), onPressed: () {
                        setState(() {
                          controller1.text = (int.parse(controller1.text.toString()) - 1).toString();   
                          price = (int.parse(controller1.text)) * widget.productModel.price;                       
                        });
                      },),
                    ),
                  ),
                  Expanded(child: input('Adet', controller1, widget.productModel.price)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: IconButton(icon: const Icon(Icons.add), onPressed: () {
                        setState(() {
                          controller1.text = (int.parse(controller1.text.toString()) + 1).toString();  
                          price = (int.parse(controller1.text)) * widget.productModel.price;                       
                        });
                      },),
                    ),
                  )
                  
                ],
              ),
            ),
            Text('TOPLAM TUTAR: ${price.toString()} ₺', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
            ElevatedButton( 
              onPressed: () {

                int piece = int.parse(controller1.text);

                MysqlConnect.setConn().then((value) {
                  if(value){
                    ProductModel newPm = ProductModel(
                      barcode: widget.productModel.barcode, 
                      name: widget.productModel.name, 
                      manufacturer: widget.productModel.manufacturer, 
                      stock: widget.productModel.stock + int.parse(controller1.text), 
                      price: widget.productModel.price, 
                      imgUrl: widget.productModel.imgUrl,
                    );
                    MysqlConnect().updateProductWithProductModel(newPm).then((value) {
                      if(value == Errors.noError){
                        //For old order model
                        //MysqlConnect().makeAndOrderWithOrderModel(OrderModel(productModel: newPm, piece: piece, price: price,)).then((value) {
                        //  if(value == Errors.noError){
                        //    showSimpleSnackbar(context, const Text('Sipariş başarılı bir şekilde eklendi.'));
                        //    Navigator.pushNamed(context, Routes.home.name);
                        //    MysqlConnect.conn.close();
                        //  }
//
                        //});
                      }
                      else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ConnectionErrorView(),));
                      }
                    });
                  }
                  else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ConnectionErrorView(),));
                  }
                });
              }, child: const Text('Sipariş Oluştur'),)
          ]
        ),
      ),
    );
  }

  Column input(String title, TextEditingController controller, double productPrice) {
    return Column(
          children: [
            Align(alignment: Alignment.center, child: Text(title,)),
            TextFormField(
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.done,
              controller: controller,
              maxLength: 24,
              onChanged: (value){
                setState(() {
                  price = (int.parse(value)) * productPrice;
                });
              },
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'Boş bırakılamaz.';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                counterText: ''
              ),
            ),
          ],
        );
  }

   Container ResultContainer(ProductModel pm, BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: ProjectColors.mainBlack)),
      child: Column(
        children: [
          ResultTextItem(title: 'Barkod: ', text: pm.barcode , isCentered: true,),
          Divider(color: ProjectColors.mainBlack, thickness: 1),
          Padding(
            padding: EdgeInsets.symmetric(vertical: ScanCompletedSizes.verticalPadding.value(), horizontal: ScanCompletedSizes.horizontalPadding.value()),
            child: Align(alignment: Alignment.centerLeft, child: Text('Ürün Hakkında', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 30),)),
          ),
            Column(
              children: [
                AboutProduct(productModel: pm),
              ],
            )
        ]
      ),
    );
  }
}