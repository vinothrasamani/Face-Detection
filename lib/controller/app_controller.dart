import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum Purpose {
  success,
  failure,
}

Map<Purpose, Color> purposeColors = {
  Purpose.success: Colors.green,
  Purpose.failure: Colors.red,
};

class AppController {
  static String baseUrl = "http://192.168.1.3:8000";
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

  static Future<dynamic> postRequest(String endpoint, dynamic body) async {
    final header = {
      "Content-Type": "application/json",
    };
    final response = await http.post(Uri.parse('$baseUrl/api/$endpoint'),
        headers: header, body: jsonEncode(body));
    if (response.statusCode == 200 ||
        response.statusCode == 409 ||
        response.statusCode == 400) {
      return response.body;
    } else {
      return null;
    }
  }
}
