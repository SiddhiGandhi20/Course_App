import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../providers/goal_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/courses_tabs.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/drawer_widget.dart';
import '../screens/board_selection_screen.dart';
import '../models/course.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  int _selectedTab = 0;
  int _selectedNavItem = 3; // Courses tab selected
  final List<String> _tabs = ['All Courses', 'Online', 'Offline'];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _selectedBoard = '';  // Store selected board

  /// ✅ Navigate to Board Selection Screen
  void _navigateToBoardSelection() async {
    final selectedBoard = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BoardSelectionScreen()),
    );

    if (selectedBoard != null) {
      setState(() {
        _selectedBoard = selectedBoard;
      });
    }
  }

  /// ✅ Filter Courses Based on Tab & Selected Goal/Board
  List<Course> _filterCourses(List<Course> courses) {
    List<Course> filtered = courses;

    // Filter by selected tab (Online/Offline)
    switch (_selectedTab) {
      case 1:
        filtered = filtered.where((course) => course.isOnline).toList();
        break;
      case 2:
        filtered = filtered.where((course) => !course.isOnline).toList();
        break;
    }

    // Filter by board selection
    if (_selectedBoard.isNotEmpty) {
      filtered = filtered.where((course) => course.category == _selectedBoard).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Courses', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      drawer: const DrawerWidget(),

      /// ✅ Use Consumer to avoid unnecessary rebuilds
      body: Consumer<CourseProvider>(
        builder: (context, courseProvider, child) {
          final courses = courseProvider.courses;
          final filteredCourses = _filterCourses(courses);

          return Column(
            children: [
              /// ✅ Select Your Goal Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: InkWell(
                  onTap: _navigateToBoardSelection,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade300, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade100.withOpacity(0.3),
                          blurRadius: 6,
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedBoard.isNotEmpty
                              ? _selectedBoard
                              : 'Select Your Board',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 18, color: Colors.blue.shade600),
                      ],
                    ),
                  ),
                ),
              ),

              /// ✅ Tabs for Filtering Courses
              CoursesTabs(
                tabs: _tabs,
                selectedTab: _selectedTab,
                onTabSelected: (index) => setState(() => _selectedTab = index),
              ),

              Expanded(
                child: filteredCourses.isNotEmpty
                    ? GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.55,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: filteredCourses.length,
                        itemBuilder: (context, index) {
                          final course = filteredCourses[index];
                          return CourseCard(course: course);
                        },
                      )
                    : Center(
                        child: Text(
                          'No Courses Available',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
              ),
            ],
          );
        },
      ),

      /// ✅ Bottom Navigation Bar
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedNavItem,
        onItemSelected: (index) => setState(() => _selectedNavItem = index),
      ),
    );
  }
}
