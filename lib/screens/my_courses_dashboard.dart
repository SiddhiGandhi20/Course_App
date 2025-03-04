import 'dart:io';
import 'package:course_app/screens/course_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../models/course.dart';

class MyCoursesDashboard extends StatefulWidget {
  const MyCoursesDashboard({super.key});

  @override
  _MyCoursesDashboardState createState() => _MyCoursesDashboardState();
}

class _MyCoursesDashboardState extends State<MyCoursesDashboard> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    await courseProvider.fetchMyCourses("user_id_here"); // Replace with actual user ID
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Consumer<CourseProvider>(
        builder: (context, courseProvider, child) {
          final myCourses = courseProvider.myCourses;

          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (myCourses.isEmpty) {
            return const Center(
              child: Text(
                "No courses enrolled yet.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: myCourses.length,
            itemBuilder: (context, index) {
              final Course course = myCourses[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Image handling
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
                            builder: (context) => CourseDetailsScreen(courseId:course.id),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
