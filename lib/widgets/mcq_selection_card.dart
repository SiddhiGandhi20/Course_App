import 'package:flutter/material.dart';
import '../styles/mcq_selection_styles.dart';

class MCQSelectionCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String questionCount;
  final bool isFree;

  const MCQSelectionCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.questionCount,
    required this.isFree,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: titleTextStyle),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isFree ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                      isFree ? 'Free' : 'Premium',
                      style: badgeTextStyle.copyWith(
                        color: isFree ? Colors.blue : Colors.purple, // ✅ Set color based on isFree
                      ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(description, style: descriptionTextStyle),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.quiz, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(questionCount, style: questionTextStyle),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: buttonStyle(isFree),
                    child: const Text('Enroll Now', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
