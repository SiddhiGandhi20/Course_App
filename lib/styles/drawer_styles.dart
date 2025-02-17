import 'package:flutter/material.dart';

class DrawerStyles {
  static Widget buildHeader(String userName, String userEmail, String userAvatar) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school, size: 24, color: Colors.blue),
              SizedBox(width: 8),
              Text('LearnHub', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(radius: 20, backgroundImage: NetworkImage(userAvatar)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userName, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                    Text(userEmail, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search courses...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  static Widget buildIcon(IconData icon, bool isSelected, bool showBadge, Color badgeColor, Color? iconColor) {
    return Stack(
      children: [
        Icon(icon, color: iconColor ?? (isSelected ? Colors.blue : Colors.grey[800])),
        if (showBadge)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  static TextStyle getMenuTextStyle(bool isSelected) {
    return TextStyle(
      color: isSelected ? Colors.blue : Colors.grey[800],
      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
    );
  }
}
