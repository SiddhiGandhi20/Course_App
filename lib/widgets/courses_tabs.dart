import 'package:flutter/material.dart';

class CoursesTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedTab;
  final Function(int) onTabSelected;

  const CoursesTabs({super.key, required this.tabs, required this.selectedTab, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: () => onTabSelected(index),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedTab == index ? Colors.blue : Colors.grey[200],
                foregroundColor: selectedTab == index ? Colors.white : Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(tabs[index]),
            ),
          );
        },
      ),
    );
  }
}
