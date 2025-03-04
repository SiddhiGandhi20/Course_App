import 'dart:io';
import 'package:flutter/material.dart';
import '../models/course.dart';
import '../screens/course_details_screen.dart';
import '../screens/course_pricing_screen.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  /// Navigate to Course Details Screen with full course data
  void _onExplore(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailsScreen(courseId: course.id), // ✅ Pass Course object
      ),
    );
  }

  /// Navigate to Course Pricing Screen
  void _onBuyNow(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoursePricingScreen(course: course), // ✅ Pass Course object
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: Colors.black.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 📌 Course Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: course.imagePath != null && File(course.imagePath!).existsSync()
                ? Image.file(File(course.imagePath!), width: double.infinity, height: 180, fit: BoxFit.cover)
                : Image.asset('assets/course4.jpg', width: double.infinity, height: 180, fit: BoxFit.cover),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 📌 Course Title
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.blue.shade300],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Text(
                    course.title.isNotEmpty ? course.title : "No Title",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),

                /// 📌 Instructor Name
                Row(
                  children: [
                    Text(
                      "Instructor: ",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.6)),
                    ),
                    Text(
                      course.instructor.isNotEmpty ? course.instructor : "Unknown Instructor",
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                /// 📌 Rating & Reviews
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text('${course.rating}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),

                /// 📌 Price & Online/Offline Label
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      course.price == 0 ? "Free" : "₹${course.price}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: course.isOnline ? Colors.green.shade100 : Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        course.isOnline ? "Online" : "Offline",
                        style: TextStyle(fontSize: 12, color: course.isOnline ? Colors.green : Colors.orange),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                /// 📌 Buttons: Explore & Buy Now
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Explore Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _onExplore(context), // ✅ Pass selected course
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 5,
                        ),
                        child: const Text("Explore", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 8),

                    /// Buy Now Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _onBuyNow(context), // ✅ Pass selected course
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 5,
                        ),
                        child: const Text("Buy Now", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
