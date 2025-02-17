import 'package:flutter/material.dart';

class PricingStyles {
  static const TextStyle sectionTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle priceTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static BoxDecoration regularTabDecoration = BoxDecoration(
    color: Colors.grey[200],
    borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
  );

  static BoxDecoration premiumTabDecoration = BoxDecoration(
    color: Colors.blue,
    borderRadius: const BorderRadius.horizontal(right: Radius.circular(2)),
  );

  static ButtonStyle buyButtonStyle = ElevatedButton.styleFrom(
    minimumSize: const Size(double.infinity, 48),
    backgroundColor: Colors.blue,
  );
}
