import 'package:flutter/material.dart';
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
    required this.selectedCategory, // Now required
  });

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _hoveredIndex = -1; // To track which item is hovered

  void _onItemSelected(BuildContext context, int index) {
    if (index == widget.selectedIndex) return; // Prevent unnecessary navigation

    Widget nextScreen;

    switch (index) {
      case 1:
        nextScreen = const TestScreen();
        break;
      case 2: // Navigate to BatchesScreen with selectedCategory
        nextScreen = BatchesScreen(category: widget.selectedCategory);
        break;
      case 3:
        nextScreen = const ClassSelectionPage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );

    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.selectedIndex,
      onTap: (index) => _onItemSelected(context, index),
      items: [
        _buildNavBarItem(Icons.book, 'Study', 1),
        _buildNavBarItem(Icons.assignment, 'Test', 2),
        _buildNavBarItem(Icons.people, 'Batches', 3),
      ],
      selectedItemColor: Colors.blueAccent, // Customize selected item color
      unselectedItemColor: Colors.grey, // Customize unselected item color
      showUnselectedLabels: true, // Display labels for unselected items
      backgroundColor: Colors.white, // Custom background color for the navbar
      elevation: 10, // Add elevation for a shadow effect
      selectedFontSize: 14, // Adjust the font size for selected labels
      unselectedFontSize: 12, // Adjust the font size for unselected labels
      type: BottomNavigationBarType.fixed, // Use fixed type for consistent design
    );
  }

  // Helper method to add hover effect with state management
  BottomNavigationBarItem _buildNavBarItem(IconData icon, String label, int index) {
    bool isHovered = _hoveredIndex == index; // Check if the item is hovered
    bool isSelected = widget.selectedIndex == index; // Check if the item is selected

    return BottomNavigationBarItem(
      icon: MouseRegion(
        onEnter: (_) => setState(() => _hoveredIndex = index),
        onExit: (_) => setState(() => _hoveredIndex = -1),
        child: Icon(
          icon,
          size: isHovered || isSelected ? 35 : 30, // Larger icon size on hover or selection
          color: isSelected
              ? Colors.blueAccent // Selected color
              : (isHovered ? Colors.blueAccent : Colors.grey), // Hover and unselected color
        ),
      ),
      label: label,
    );
  }
}
