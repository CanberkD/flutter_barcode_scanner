import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../scancompleted/view/scan_complated_view.dart';

class BarcodeScan {
  static void scan (BuildContext context) async{
    await FlutterBarcodeScanner.scanBarcode("#FF6666", 'İptal', true, ScanMode.BARCODE).then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ScanCompletedView(barcode: value,),));
    });
  }
}