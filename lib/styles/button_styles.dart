import 'package:flutter/material.dart';

final ButtonStyle buyButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blue, // ✅ Replaces 'primary'
  foregroundColor: Colors.white, // ✅ Replaces 'onPrimary'
  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  textStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
);
