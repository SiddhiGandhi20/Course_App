import 'package:flutter/material.dart';

class TestStyles {
  static const EdgeInsets pagePadding = EdgeInsets.all(16.0);
  static const double borderRadius = 12.0;

  static final BoxDecoration cardDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        blurRadius: 6,
        spreadRadius: 2,
      ),
    ],
  );

  static final TextStyle headerTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static final TextStyle sectionTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static TextStyle boldTextStyle({Color color = Colors.black}) {
    return TextStyle(fontWeight: FontWeight.bold, color: color);
  }

  static TextStyle smallTextStyle({Color color = Colors.grey}) {
    return TextStyle(color: color, fontSize: 14);
  }
}
