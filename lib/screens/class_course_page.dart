import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart'; // ✅ Import CourseCard widget

class ClassCoursesPage extends StatelessWidget {
  final String className;

  const ClassCoursesPage({super.key, required this.className});

  @override
  Widget build(BuildContext context) {
    // Get courses from provider and filter based on class name
    final courseProvider = Provider.of<CourseProvider>(context);
    final courses = courseProvider.courses
        .where((course) => course.category == className)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('$className Courses'),
        backgroundColor: Colors.blueAccent,
      ),
      body: courses.isEmpty
          ? Center(child: Text('No courses available for $className.'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // ✅ Adjust based on screen width
                childAspectRatio: 0.9,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return CourseCard(course: course); // ✅ Use CourseCard
              },
            ),
    );
  }
}
