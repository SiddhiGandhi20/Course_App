import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/course.dart';
import '../widgets/course_card.dart';
import '../widgets/bottom_nav.dart';

class ClassCoursesPage extends StatefulWidget {
  final String className;

  const ClassCoursesPage({super.key, required this.className});

  @override
  _ClassCoursesPageState createState() => _ClassCoursesPageState();
}

class _ClassCoursesPageState extends State<ClassCoursesPage> {
  List<Course> _courses = []; // Stores fetched courses
  int _selectedTab = 0; // 0 = All, 1 = Online, 2 = Offline
  int _selectedIndex = 0; // Bottom Navigation Index
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchCourses(); // Fetch courses when page loads
  }

Future<void> _fetchCourses() async {
  final String apiUrl = "http://192.168.29.32:5000/api/courses/by-category?category=${Uri.encodeComponent(widget.className)}";

  debugPrint("Fetching courses from: $apiUrl");

  try {
    final response = await http.get(Uri.parse(apiUrl));

    debugPrint("API Response Status: ${response.statusCode}");
    debugPrint("API Response Body: ${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      if (data.isEmpty) {
        debugPrint("No courses found for category: ${widget.className}");
      } else {
        debugPrint("Courses Data: $data");
      }

      List<Course> classCourses =
          data.map<Course>((json) => Course.fromJson(json)).toList();

      setState(() {
        _courses = classCourses;
        _isLoading = false;
      });

      debugPrint("Fetched ${_courses.length} courses for ${widget.className}");
    } else {
      debugPrint("Failed to load courses: ${response.body}");
    }
  } catch (error) {
    debugPrint("Error fetching courses: $error");
    setState(() => _isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    // ✅ Apply filter based on selected tab
    final filteredCourses = _selectedTab == 1
        ? _courses.where((course) => course.isOnline).toList()
        : _selectedTab == 2
            ? _courses.where((course) => !course.isOnline).toList()
            : _courses;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.className} Courses',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 6,
        shadowColor: Colors.blue.withOpacity(0.3),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // ✅ Show loader while fetching
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  // ✅ Tab Selection Row (All, Online, Offline)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: ['All Courses', 'Online', 'Offline']
                          .asMap()
                          .entries
                          .map((entry) => GestureDetector(
                                onTap: () => setState(() => _selectedTab = entry.key),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _selectedTab == entry.key ? Colors.blue.shade600 : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: _selectedTab == entry.key
                                        ? [BoxShadow(color: Colors.blue.shade300, blurRadius: 4, spreadRadius: 1)]
                                        : [],
                                  ),
                                  child: Text(
                                    entry.value,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: _selectedTab == entry.key ? Colors.white : Colors.blue.shade600,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),

                  // ✅ Display Courses (Grid View)
                  Expanded(
                    child: filteredCourses.isEmpty
                        ? Center(
                            child: Text(
                              'No courses available for ${widget.className}.',
                              style: const TextStyle(fontSize: 18, color: Colors.blueGrey, fontWeight: FontWeight.w500),
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 2, // Responsive layout
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: filteredCourses.length,
                            itemBuilder: (context, index) {
                              return CourseCard(course: filteredCourses[index]);
                            },
                          ),
                  ),
                ],
              ),
            ),

      // ✅ Bottom Navigation Bar
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) => setState(() => _selectedIndex = index),
        selectedCategory: widget.className,
      ),
    );
  }
}
