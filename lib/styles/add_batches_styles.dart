import 'package:flutter/material.dart';

class AddBatchesStyles {
  static const padding = EdgeInsets.symmetric(vertical: 10, horizontal: 16);
  static const labelTextStyle = TextStyle(color: Colors.grey, fontSize: 16);
  static final imageBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.grey.shade300),
  );
  static final buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    padding: EdgeInsets.symmetric(vertical: 15),
  );
  static final buyNowButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    padding: EdgeInsets.symmetric(vertical: 15),
  );
  static const buttonTextStyle = TextStyle(color: Colors.white, fontSize: 16);
}
