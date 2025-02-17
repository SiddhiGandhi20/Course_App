import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';  // Ensure this is your custom CourseCard

class ClassCoursesPage extends StatelessWidget {
  final String className;

  const ClassCoursesPage({super.key, required this.className});

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final courses = courseProvider.getCoursesByClass(className);

    debugPrint("Displaying ${courses.length} courses for $className");

    return Scaffold(
      appBar: AppBar(
title: Text(
  '$className Courses',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white, // Set the text color to white
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
        child: courses.isEmpty
            ? Center(
                child: Text(
                  'No courses available for $className.',
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey, fontWeight: FontWeight.w500),
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 2, // Adjust for mobile vs tablet
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9, // Adjust based on card size preference
                ),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
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
                    child: CourseCard(course: course), // Use your custom CourseCard widget
                  );
                },
              ),
      ),
    );
  }
}
