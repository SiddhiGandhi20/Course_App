import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../models/course.dart';
import '../widgets/bottom_nav.dart';

class ClassCoursesPage extends StatefulWidget {
  final String className;

  const ClassCoursesPage({super.key, required this.className});

  @override
  _ClassCoursesPageState createState() => _ClassCoursesPageState();
}

class _ClassCoursesPageState extends State<ClassCoursesPage> {
  int _selectedTab = 0;
  int _selectedIndex = 0; // Track bottom navigation index

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final courses = courseProvider.getCoursesByClass(widget.className);
    final List<String> _tabs = ['All Courses', 'Online', 'Offline'];

    debugPrint("Displaying ${courses.length} courses for ${widget.className}");

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

      return filtered;
    }

    final filteredCourses = _filterCourses(courses);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.className} Courses',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 8,
        shadowColor: Colors.blue.withOpacity(0.5),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Custom Tab Section (Always Visible)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _tabs
                    .asMap()
                    .map((index, tab) {
                      return MapEntry(
                        index,
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTab = index;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: _selectedTab == index
                                      ? Colors.blue.withOpacity(0.6)
                                      : Colors.transparent,
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Text(
                              tab,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _selectedTab == index
                                    ? Colors.blue.shade600
                                    : Colors.blue.shade600,
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                    .values
                    .toList(),
              ),
            ),
            // Course Display
            filteredCourses.isEmpty
                ? Center(
                    child: Text(
                      'No courses available for ${widget.className}.',
                      style: TextStyle(fontSize: 18, color: Colors.blueGrey, fontWeight: FontWeight.w500),
                    ),
                  )
                : Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: filteredCourses.length,
                      itemBuilder: (context, index) {
                        final course = filteredCourses[index];
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CourseCard(course: course),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
        selectedCategory: widget.className, // Pass class name dynamically
      ),
    );
  }
}
