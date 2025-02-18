// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:course_app/screens/add_course_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:course_app/screens/add_batches_screen.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../models/batch.dart';  // Make sure you have the Batch model

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  void _addBatch(Batch batch) {
    // Handle the added batch data here (e.g., save to the provider or database)
    print('Batch added: ${batch.title}, ${batch.category}, ${batch.date}');
  }

  @override
  Widget build(BuildContext context) {
    final courses = Provider.of<CourseProvider>(context).courses;

    return Scaffold(
      body: Stack(
        children: [
          // 🌈 Background Decoration
          const SizedBox(height: 20),
          Container(
            height: 120,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 56, 125, 222), Color(0xFF2575FC)], // Purple-Blue Gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeader(),
                  const SizedBox(height: 24),
                  buildActionButtons(context),
                  const SizedBox(height: 24),
                  buildCourseCatalog(courses),
                  const SizedBox(height: 24),
                  buildRecentActivities(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔘 Action Buttons (Stylish Grid)
  Widget buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // First Row with two buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildActionButton(
              icon: Icons.add_circle_outline,
              label: 'Create Test',
              color: Colors.blue.shade400,
              onTap: () {},
            ),
            buildActionButton(
              icon: Icons.library_books,
              label: 'Add Course',
              color: Colors.purple.shade400,
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddCourseScreen()),
              );

              },
            ),
          ],
        ),
        const SizedBox(height: 16), // Adds space between the rows

        // Second button below
        buildActionButton(
          icon: Icons.library_books,
          label: 'Add Batch',
          color: Colors.green.shade400,  // Adjust the color as needed
          onTap: () {
            Navigator.push(
              context,
              // ignore: avoid_types_as_parameter_names
              MaterialPageRoute(builder: (context) => AddBatchesScreen(onAddBatch: _addBatch)),
            );
          },
        ),
      ],
    );
  }

  // 📘 Course Catalog with Card UI
  Widget buildCourseCatalog(List<Course> courses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionHeader('My Courses', 'View All', () {}),
        const SizedBox(height: 12),
        courses.isNotEmpty
            ? Column(
                children: courses.map((course) => buildCourseItem(course)).toList(),
              )
            : Center(
                child: Column(
                  children: [
                    const Icon(Icons.book, size: 50, color: Colors.grey),
                    const SizedBox(height: 10),
                    const Text('No courses available', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ),
      ],
    );
  }

  // 🎨 Course Item Card
  Widget buildCourseItem(Course course) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: (course.imagePath != null && File(course.imagePath!).existsSync())
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(File(course.imagePath!), width: 50, height: 50, fit: BoxFit.cover),
              )
            : Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.book, size: 30, color: Colors.grey),
              ),
        title: Text(
          course.title.isNotEmpty ? course.title : "Untitled Course",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          '${course.category} • ${course.isOnline ? "Online" : "Offline"}',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      ),
    );
  }

  // 🏷 Stylish Dashboard Header
  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Teacher Dashboard',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'Springfield High School',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.blue, size: 28),
          ),
        ],
      ),
    );
  }

  // 🔔 Recent Activities with Decorated UI
  Widget buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionHeader('Recent Activities', null, null),
        const SizedBox(height: 12),
        buildActivityItem('New Course Added', 'Data Science Bootcamp', 'Just now', Icons.add, Colors.blue),
        buildActivityItem('Test Scheduled', 'Math Quiz - 12th Grade', '1 hour ago', Icons.timer, Colors.green),
      ],
    );
  }

  // 📢 Activity Item with Modern Style
  Widget buildActivityItem(String title, String subtitle, String time, IconData icon, Color color) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
        trailing: Text(time, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }

  // 🏷 Section Header with Decorative Style
  Widget buildSectionHeader(String title, String? actionLabel, VoidCallback? action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        if (actionLabel != null)
          TextButton(
            onPressed: action,
            child: Text(actionLabel, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }

  // 🎨 Action Button UI (Decorative)
  Widget buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 140,
        height: 100,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}
