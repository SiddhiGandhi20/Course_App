import 'package:flutter/material.dart';
import '../models/batch.dart';

class BatchCard extends StatelessWidget {
  final Batch batch;

  const BatchCard({super.key, required this.batch});

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
            Text(batch.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Instructor
            Text('Instructor: ${batch.instructor}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 8),

            // Timing
            Text('Timing: ${batch.timing}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 8),

            // Date
            Text('Date: ${batch.date}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 8),

            // Category
            Text('Category: ${batch.category}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 8),

            // Price
            Text('Price: ${batch.price}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
