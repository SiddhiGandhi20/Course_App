import 'dart:io';
import 'package:course_app/screens/course_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../models/course.dart';

class MyCoursesDashboard extends StatelessWidget {
  const MyCoursesDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = Provider.of<CourseProvider>(context).courses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: courses.isEmpty
          ? const Center(
              child: Text(
                "No courses enrolled yet.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final Course course = courses[index];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // Image handling based on URL or file path
                      if (course.imagePath != null && course.imagePath!.startsWith('http'))
                        Image.network(
                          course.imagePath!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        )
                      else if (course.imagePath != null && course.imagePath!.isNotEmpty)
                        Image.file(
                          File(course.imagePath!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        )
                      else
                        Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                        ),

                      // Course details
                      ListTile(
                        title: Text(
                          course.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(course.instructor),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: () {
                          // Navigate to Course Details Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseDetailsScreen(course: course),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
