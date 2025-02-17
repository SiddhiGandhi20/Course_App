import 'package:flutter/material.dart';
import '../screens/my_courses_dashboard.dart'; // Import your screen

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[50],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildMenuItem(Icons.dashboard_outlined, 'Dashboard', onTap: () {}),
          _buildMenuItem(
            Icons.school_outlined, 
            'My Courses', 
            showBadge: true, 
            badgeColor: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyCoursesDashboard()),
              );
            },
          ),
          _buildMenuItem(Icons.trending_up, 'Progress', onTap: () {}),
          _buildMenuItem(Icons.settings_outlined, 'Settings', showBadge: true, badgeColor: Colors.red, onTap: () {}),
          _buildMenuItem(Icons.help_outline, 'Help Center', onTap: () {}),
          _buildMenuItem(Icons.feedback_outlined, 'Send Feedback', onTap: () {}),
          _buildMenuItem(Icons.description_outlined, 'Terms & Conditions', onTap: () {}),
          const Divider(height: 1),
          _buildMenuItem(Icons.logout, 'Logout', textColor: Colors.red, iconColor: Colors.red, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.school, size: 24, color: Colors.blue),
              SizedBox(width: 8),
              Text('LearnHub', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              CircleAvatar(radius: 20, backgroundImage: NetworkImage("https://example.com/avatar.png")),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Alex Johnson', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                    Text('alex.johnson@mail.com', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search courses...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool showBadge = false, Color badgeColor = Colors.blue, Color? textColor, Color? iconColor, required VoidCallback onTap}) {
    return ListTile(
      leading: Stack(
        children: [
          Icon(icon, color: iconColor ?? Colors.grey[800]),
          if (showBadge)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
      title: Text(title, style: TextStyle(color: textColor ?? Colors.grey[800])),
      onTap: onTap, // Handle navigation
    );
  }
}
