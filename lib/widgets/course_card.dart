import 'dart:io';
import 'package:flutter/material.dart';
import '../models/course.dart';
import '../screens/course_details_screen.dart';
import '../screens/course_pricing_screen.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  /// Navigate to Course Details Screen
  void _onExplore(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailsScreen(course: course),
      ),
    );
  }

  /// Handle Buy Now action
  void _onBuyNow(BuildContext context) {
    // TODO: Implement purchase functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Purchased: ${course.title}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 📌 Course Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: course.imagePath != null && File(course.imagePath!).existsSync()
                ? Image.file(File(course.imagePath!), width: double.infinity, height: 120, fit: BoxFit.cover)
                : Image.asset('assets/course4.jpg', width: double.infinity, height: 120, fit: BoxFit.cover),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 📌 Course Title
                Text(
                  course.title.isNotEmpty ? course.title : "No Title",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                /// 📌 Instructor Name
                Text(
                  course.instructor.isNotEmpty ? course.instructor : "Unknown Instructor",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 6),

                /// 📌 Rating & Reviews
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text('${course.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),

                /// 📌 Price & Online/Offline Label
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      course.price == 0 ? "Free" : "₹${course.price}",
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: course.isOnline ? Colors.green.shade100 : Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        course.isOnline ? "Online" : "Offline",
                        style: TextStyle(fontSize: 12, color: course.isOnline ? Colors.green : Colors.orange),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                /// 📌 Buttons: Explore & Buy Now
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Explore Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _onExplore(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Explore", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 8), // Spacing between buttons

                    /// Buy Now Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to CoursePricingScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CoursePricingScreen(course: course,)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 74, 160, 235),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
