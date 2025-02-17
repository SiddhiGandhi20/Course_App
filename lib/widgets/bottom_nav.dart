import 'package:flutter/material.dart';
import '../screens/test_screen.dart';
import '../screens/courses_screen.dart';
import '../screens/select_batch_screen.dart'; // ✅ Import Batches Screen

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  void _onItemSelected(BuildContext context, int index) {
    if (index == selectedIndex) return; // Prevent unnecessary navigation

    Widget nextScreen;
    switch (index) {
      case 1:
        nextScreen = const TestScreen();
        break;
      case 2: // ✅ Handle the Batches screen
        nextScreen = const SelectBatchScreen();
        break;
      case 3:
        nextScreen = const CoursesScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );

    onItemSelected(index); // ✅ Call the callback to update state
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => _onItemSelected(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Study'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Test'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Batches'), // ✅ Corrected Index
        BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Courses'),
        BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Store'),
      ],
    );
  }
}
