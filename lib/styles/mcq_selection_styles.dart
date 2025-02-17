import 'package:flutter/material.dart';

// Card Styling
final BoxDecoration cardDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(12),
  border: Border.all(color: Colors.grey.shade200),
);

// Text Styles
const TextStyle titleTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

const TextStyle badgeTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 12,
);

final TextStyle descriptionTextStyle = TextStyle(
  color: Colors.grey.shade600,
  fontSize: 14,
);

final TextStyle questionTextStyle = TextStyle(
  color: Colors.grey.shade600,
  fontSize: 12,
);

// Button Style Function
ButtonStyle buttonStyle(bool isFree) {
  return ElevatedButton.styleFrom(
    backgroundColor: isFree ?  const Color.fromARGB(255, 78, 186, 248) : const Color.fromARGB(255, 78, 186, 248),
    padding: const EdgeInsets.symmetric(vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}
