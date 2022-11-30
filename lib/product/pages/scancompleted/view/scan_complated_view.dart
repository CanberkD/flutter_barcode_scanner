
import 'package:flutter/material.dart';
import 'package:flutter_barcode_app/product/navigation/navigation_enums.dart';
import 'package:flutter_barcode_app/product/pages/homepage/model/barcode_model.dart';
import 'package:flutter_barcode_app/product/service/product_model.dart';
import 'package:flutter_barcode_app/product/service/barcode_service.dart';
import 'package:flutter_barcode_app/product/widgets/appbar.dart';
import 'package:flutter_barcode_app/product/widgets/result_text.dart';

import '../../../consts/colors.dart';
import '../../add_product/view/add_product_view.dart';

class ScanCompletedView extends StatefulWidget {
  final String barcode;

  const ScanCompletedView({super.key, required this.barcode});

  @override
  State<ScanCompletedView> createState() => _ScanCompletedViewState();
}

class _ScanCompletedViewState extends State<ScanCompletedView> {

  @override
  Widget build(BuildContext context) {

    final ProductModel? productModel = BarcodeService().findModelWithBarcode(widget.barcode);
    
    return WillPopScope(
      onWillPop: () async{ Navigator.of(context).popAndPushNamed(Routes.home.name); return true; },
      child: Scaffold(
        appBar: projectAppBar,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Title(),
                ResultContainer(productModel),
              ]
            ), 
            ScanButton()
          ],
        ),
      ),
    );
  }

  Padding ScanButton() {
    return Padding(
          padding: EdgeInsets.only(bottom: ScanCompletedSizes.verticalPadding.value()),
          child: ElevatedButton(onPressed: (){BarcodeScan.scan(context);}, child: const Text('Tarama Başlat')),
        );
  }

  Padding ResultContainer(ProductModel? pm) {
    return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: ProjectColors.mainBlack)),
                child: Column(
                  children: [
                    ResultTextItem(title: 'Barkod: ', text: (widget.barcode != '-1') ? widget.barcode : 'Barkod okunamadı.', isCentered: true,),
                    Divider(color: ProjectColors.mainBlack, thickness: 1),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: ScanCompletedSizes.verticalPadding.value(), horizontal: ScanCompletedSizes.horizontalPadding.value()),
                      child: Align(alignment: Alignment.centerLeft, child: Text('Ürün Hakkında', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 30),)),
                    ),
                    (pm != null) ? 
                      AboutProduct(productModel: pm) : 
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ScanCompletedSizes.horizontalPadding.value()),
                        child: Column(
                          children: [
                            widget.barcode != '-1' ? const Text('Kayıtlı ürün bulunamadı. Eğer bu ürünü kaydetmek istiyorsan aşağıdaki butona bas.', textAlign: TextAlign.center,) :
                            const Text('Barkod okunamadı. Tekrar deneyin.'),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: ScanCompletedSizes.verticalPadding.value()),
                              child: widget.barcode != '-1' ? ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct(barcode: widget.barcode, isEdit: false)));
                                }, child: const Text('Ürün Ekle')) :
                                const SizedBox.shrink(),
                            )
                          ],
                        ),
                      ),
                  ]
                ),
              ),
            );
  }

  Padding Title() {
    return Padding(
              padding: EdgeInsets.symmetric(vertical: ScanCompletedSizes.verticalPadding.value()),
              child: Center(
                child: Text(
                  'Tarama Sonuçları', 
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
            );
  }
}

class AboutProduct extends StatelessWidget {
  const AboutProduct({
    super.key, required this.productModel,
  });

  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: ScanCompletedSizes.horizontalPadding.value()) + const EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: [
          ResultTextItem(title: 'Ürün Adı: ', text: productModel.name, isCentered: false,),
          ResultTextItem(title: 'Üretici: ', text: productModel.manufacturer, isCentered: false,),
          ResultTextItem(title: 'Fiyat: ', text: '${productModel.price.toString()} ₺', isCentered: false,),
          ResultTextItem(title: 'Stok: ', text: productModel.stock.toString(), isCentered: false,),
        ],
      ),
    );
  }
}


enum ScanCompletedSizes{
  verticalPadding,
  horizontalPadding,
}

extension ScanComplatedSizesExtension on ScanCompletedSizes{
  double value(){
    switch(this){
      case ScanCompletedSizes.verticalPadding:
        return 20;
      case ScanCompletedSizes.horizontalPadding:
        return 32;
    }
  }
}