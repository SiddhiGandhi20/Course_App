import 'package:flutter/material.dart';
import '../styles/signup.dart'; // Import styles

// 📌 Custom Input Field
Widget buildInputField(String label) {
  return TextField(
    decoration: inputFieldDecoration.copyWith(labelText: label),
  );
}

// 🎭 Role Selection Widget
Widget buildRoleOption({
  required IconData icon,
  required String title,
  required String subtitle,
  required String value,
  required String? selectedRole,
  required Function(String) onTap,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8),
    child: InkWell(
      onTap: () => onTap(value),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: selectedRole == value ? Colors.blue : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.blue),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
                  Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
            if (selectedRole == value) Icon(Icons.check_circle, color: Colors.blue),
          ],
        ),
      ),
    ),
  );
}

// 🌍 Social Media Buttons
Widget buildSocialButton(IconData icon, String label) {
  return OutlinedButton.icon(
    onPressed: () {},
    style: outlinedButtonStyle, // ✅ Reused style
    icon: Icon(icon, size: 24),
    label: Text(label),
  );
}
