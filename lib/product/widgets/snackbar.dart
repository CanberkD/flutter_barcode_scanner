import 'package:flutter/material.dart';

void showSimpleSnackbar(BuildContext context, Widget content){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: content,
    )
  );
}
