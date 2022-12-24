import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_app/product/pages/homepage/view/homepage_view.dart';
import 'package:flutter_barcode_app/product/widgets/appbar.dart';
import 'package:lottie/lottie.dart';

class ConnectionErrorView extends StatelessWidget {
  const ConnectionErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exit(0),
      child: Scaffold(
        appBar: projectAppBar,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset('assets/lottie/lottie_connection_error.json'),
            Text(
              'Bağlantı hatası. Lütfen bağlantınızı kontrol edip tekrar deneyin.', 
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            ElevatedButton(onPressed: () async{ 
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePageView(),));
              }, child: const Text('Tekrar Dene'),)
          ],
        ),
      ),
    );
  }
}