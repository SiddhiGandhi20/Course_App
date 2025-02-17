import 'package:flutter/material.dart';

class ActiveCourseCard extends StatelessWidget {
  const ActiveCourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Introduction to Python',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  child: const Text('Continue'),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/course1.jpg', // ✅ Visible course image
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            const LinearProgressIndicator(
              value: 0.65,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 8),
            const Text(
              '65% complete',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: const Text('Programming'),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                ),
                Chip(
                  label: const Text('Design'),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
