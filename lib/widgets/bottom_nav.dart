import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/batches_screen.dart';
import '../screens/test_screen.dart';
import '../screens/class_selection_page.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final String selectedCategory;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.selectedCategory,
  });

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _hoveredIndex = -1;
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserId(); // Load user ID from SharedPreferences
  }

  // 🚀 Load User ID from SharedPreferences
  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('userId');

    if (mounted) {
      setState(() {
        _userId = storedUserId ?? '';
      });
    }
    debugPrint("🔍 Loaded User ID: $_userId");
  }

  // ✅ Handle Bottom Navigation Click
  void _onItemSelected(BuildContext context, int index) {
    if (index == widget.selectedIndex) return;

    Widget nextScreen;

    switch (index) {
      case 0: // Study
        nextScreen = const ClassSelectionPage();
        break;

      case 1: // Test
        if (_userId.isNotEmpty ) {
          nextScreen = TestsScreen(userId: _userId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('⚠️ User ID or Category is missing!')),
          );
          return;
        }
        break;

      case 2: // Batches
        nextScreen = BatchesScreen(category: widget.selectedCategory);
        break;

      default:
        return;
    }

    // 🛠 Navigate to the selected screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );

    // 🔄 Notify Parent Widget about selection change
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> navItems = [
      {"icon": Icons.book, "label": "Study"},
      {"icon": Icons.assignment, "label": "Test"},
      {"icon": Icons.people, "label": "Batches"},
    ];

    return BottomNavigationBar(
      currentIndex: widget.selectedIndex,
      onTap: (index) => _onItemSelected(context, index),
      items: navItems
          .asMap()
          .entries
          .map((entry) => _buildNavBarItem(entry.value["icon"], entry.value["label"], entry.key))
          .toList(),
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
      elevation: 10,
      selectedFontSize: 14,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
    );
  }

  // 🎨 Helper Method for Nav Bar Items (with Hover Effect)
  BottomNavigationBarItem _buildNavBarItem(IconData icon, String label, int index) {
    bool isHovered = _hoveredIndex == index;
    bool isSelected = widget.selectedIndex == index;

    return BottomNavigationBarItem(
      icon: MouseRegion(
        onEnter: (_) => setState(() => _hoveredIndex = index),
        onExit: (_) => setState(() => _hoveredIndex = -1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            icon,
            size: isHovered || isSelected ? 35 : 30,
            color: isSelected ? Colors.blueAccent : (isHovered ? Colors.blueAccent : Colors.grey),
          ),
        ),
      ),
      label: label,
    );
  }
}
