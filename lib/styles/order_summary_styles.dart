import 'package:flutter/material.dart';

class OrderSummaryStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static TextStyle hintStyle = TextStyle(color: Colors.grey[600]);

  static const TextStyle totalTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const BoxDecoration couponBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  static const BoxShadow paymentBoxShadow = BoxShadow(
    color: Colors.grey,
    blurRadius: 4,
    offset: Offset(0, -2),
  );

  static ButtonStyle payButtonStyle = ElevatedButton.styleFrom(
    minimumSize: const Size(double.infinity, 48),
    backgroundColor: Colors.blue,
  );
}
