import 'package:flutter/material.dart';

final batchCardShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(12),
  side: BorderSide(color: Colors.grey[200]!),
);

const cardPadding = EdgeInsets.all(16);

const titleTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

final subtitleTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.grey[600],
);

const teacherNameTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

final teacherRoleTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.grey[600],
);

const iconTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.grey,
);

final joinButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blue,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  padding: const EdgeInsets.symmetric(vertical: 12),
);

const buttonTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
);
