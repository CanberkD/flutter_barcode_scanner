import 'package:flutter/material.dart';

Future<void> showSimpleApproveDialog({
    required BuildContext context,
    required String title,
    required String description,
    required String approveButtonText,
    required String declineButtonText,
    required Function onPressedApprove,
    required Function onPressedDecline,
    
  }) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(description),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(declineButtonText, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            onPressed: () {
              onPressedDecline();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(approveButtonText, style: const TextStyle(color: Colors.red)),
            onPressed: () {
              onPressedApprove();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}