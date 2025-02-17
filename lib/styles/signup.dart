import 'package:flutter/material.dart';

// Elevated Button Style
final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blue[600], 
  foregroundColor: Colors.black,
  minimumSize: Size(double.infinity, 48),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
);

// Outlined Button Style
final ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
  foregroundColor: Colors.black,
  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
);

// Text Field Input Decoration
final InputDecoration inputFieldDecoration = InputDecoration(
  border: OutlineInputBorder(),
);
