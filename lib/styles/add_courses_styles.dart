import 'package:flutter/material.dart';

class AddCourseStyles {
  // 🌊 Elegant Gradient Background for Button
  static final BoxDecoration gradientButtonDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(10), // Slightly more rounded for elegance
  // gradient: const LinearGradient(
  //   // colors: [Color(0xFF1976D2), Color(0xFF0D47A1)], // Richer blue shades for depth
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  // ),
  boxShadow: [
    BoxShadow(
      color: Colors.blue.shade800.withOpacity(0.7), // Subtle shadow for depth
      blurRadius: 8,
      spreadRadius: 2,
      offset: const Offset(2, 4), // Soft elevation effect
    ),
  ],
);

  // ✏️ Modern Input Field Styling with a Clean Aesthetic
  static final InputDecoration textFieldDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14), // More refined rounded edges
      borderSide: const BorderSide(color: Color(0xFF3949AB), width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF1A237E), width: 2.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF90CAF9), width: 1.5),
    ),
    fillColor: Colors.white, // Clean white background
    filled: true,
    hintStyle: TextStyle(color: Colors.blueGrey.shade400), // Subtle hint text color
  );
}
