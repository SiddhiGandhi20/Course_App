import 'package:flutter/material.dart';
import '../styles/course_styles.dart';

Widget buildStatItem(IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.only(right: 16),
    child: Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: CourseStyles.statTextStyle),
      ],
    ),
  );
}

Widget buildLearnItem(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.blue),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: CourseStyles.bodyTextStyle)),
      ],
    ),
  );
}

class RelatedCourseCard extends StatelessWidget {
  const RelatedCourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: CourseStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(
              'https://picsum.photos/200/120',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Web Design Basics', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    Text(' 4.5 • '),
                    Text('2h 30m'),
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
