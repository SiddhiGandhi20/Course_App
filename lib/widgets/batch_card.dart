import 'package:flutter/material.dart';
import '../models/course.dart';

class BatchCard extends StatelessWidget {
  final Course course;

  const BatchCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(course.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Duration
            Text(course.duration, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 16),

            // Start Date
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(course.learningPoints.isNotEmpty ? course.learningPoints[0] : 'No start date', style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),

            // Image
            Image.network(
              course.imagePath ?? 'https://via.placeholder.com/150',  // fallback if no image is set
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
