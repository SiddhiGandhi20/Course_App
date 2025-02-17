import 'package:flutter/material.dart';

class RecentQuizzes extends StatelessWidget {
  const RecentQuizzes({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       

        // 📌 List of Quizzes
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _buildQuizCard(index);
          },
        ),
      ],
    );
  }

  // 📌 🎨 Custom Quiz Card
  Widget _buildQuizCard(int index) {
    final List<String> quizTitles = [
      'Python Basics Quiz',
      'JavaScript Fundamentals',
      'Flutter UI Quiz'
    ];

    final List<String> categories = [
      'Programming',
      'Web Development',
      'Mobile Development'
    ];

    final List<int> scores = [85, 72, 90];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // 📌 Icon Representation
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue.withOpacity(0.2),
              child: const Icon(
                Icons.quiz_outlined,
                color: Colors.blue,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // 📌 Quiz Title & Category (Expanded for proper layout)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quizTitles[index],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    categories[index],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // 📌 Progress Indicator & Score Row
                  Row(
                    children: [
                      // ✅ Progress Bar
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: scores[index] / 100,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // ✅ Score Display
                      Text(
                        '${scores[index]}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
