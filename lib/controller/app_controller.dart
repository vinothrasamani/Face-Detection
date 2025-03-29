import 'package:flutter/material.dart';

enum Purpose {
  success,
  failure,
}

Map<Purpose, Color> purposeColors = {
  Purpose.success: Colors.green,
  Purpose.failure: Colors.red,
};

class AppController {
  static void snackBar(BuildContext context, String message,
      {Purpose purpose = Purpose.success}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: purposeColors[purpose],
        content: Text(
          message,
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
