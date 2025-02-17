import 'package:flutter/material.dart';
import '../styles/teacher_dashboard_styles.dart';

Widget buildSectionHeader(String title, String? actionText, VoidCallback? onActionTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: sectionTitleStyle),
      if (actionText != null)
        TextButton(
          onPressed: onActionTap,
          child: Text(actionText, style: const TextStyle(color: Colors.blue)),
        ),
    ],
  );
}

Widget buildActionButton({
  required IconData icon,
  required String label,
  required Color color,
  required VoidCallback onTap,
}) {
  return Material(
    color: color.withOpacity(0.1),
    borderRadius: BorderRadius.circular(8),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ),
  );
}
