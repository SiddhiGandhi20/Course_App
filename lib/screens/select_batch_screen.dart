import 'package:flutter/material.dart';
import '../models/course.dart';
import '../widgets/batch_card.dart';

class SelectBatchScreen extends StatefulWidget {
  const SelectBatchScreen({super.key});

  @override
  _SelectBatchScreenState createState() => _SelectBatchScreenState();
}

class _SelectBatchScreenState extends State<SelectBatchScreen> {
  String? selectedBoard;

  final List<String> boards = ['11', '12-PCB', '12-PCB-CBSE', 'NEET'];

  final Map<String, List<Map<String, dynamic>>> boardBatches = {
    '11': [
      {
        'title': '11 Batch',
        'instructor': 'Dr. Rajesh Kumar',
        'description': 'Mechanical Engineering',
        'category': '11',
        'language': 'English',
        'duration': '12 weeks left',
        'price': 1000.0,
        'isPrivate': false,
        'hasCertificate': true,
        'isOnline': true,
        'rating': 4.5,
        'tags': ['Engineering', 'GATE'],
        'imagePath': 'https://via.placeholder.com/150',
        'videoPaths': [],
        'notesPaths': [],
        'learningPoints': ['Introduction to Mechanics'],
      },
    ],
    '12-PCB': [
      {
        'title': 'KVS TGT-PGT Batch',
        'instructor': 'Prof. Anjali Verma',
        'description': 'General Awareness • Pedagogy',
        'category': '12-PCB',
        'language': 'English',
        'duration': '10 weeks left',
        'price': 1200.0,
        'isPrivate': false,
        'hasCertificate': true,
        'isOnline': true,
        'rating': 4.8,
        'tags': ['Education', 'Teaching'],
        'imagePath': 'https://via.placeholder.com/150',
        'videoPaths': [],
        'notesPaths': [],
        'learningPoints': ['Teaching Methodologies'],
      },
    ],
    '12-PCB-CBSE': [
      {
        'title': 'PCM IIT-JEE Batch',
        'instructor': 'Dr. Amit Sharma',
        'description': 'Physics • Chemistry • Math',
        'category': '12-PCB-CBSE',
        'language': 'English',
        'duration': '15 weeks left',
        'price': 1500.0,
        'isPrivate': false,
        'hasCertificate': true,
        'isOnline': true,
        'rating': 4.7,
        'tags': ['IIT-JEE', 'Engineering'],
        'imagePath': 'https://via.placeholder.com/150',
        'videoPaths': [],
        'notesPaths': [],
        'learningPoints': ['Introduction to Physics'],
      },
    ],
    'NEET': [
      {
        'title': 'Medical Preparation Batch',
        'instructor': 'Dr. James Matt',
        'description': 'Physics • Chemistry • Biology',
        'category': 'NEET',
        'language': 'English',
        'duration': '5 weeks left',
        'price': 800.0,
        'isPrivate': false,
        'hasCertificate': true,
        'isOnline': true,
        'rating': 4.6,
        'tags': ['NEET', 'Medical'],
        'imagePath': 'https://via.placeholder.com/150',
        'videoPaths': [],
        'notesPaths': [],
        'learningPoints': ['Medical Terminology'],
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Select Your Batch',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: selectedBoard,
              hint: const Text('Select a Board'),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: boards.map((board) {
                return DropdownMenuItem<String>(
                  value: board,
                  child: Text(board),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBoard = value;
                });
              },
            ),
          ),

          // Only display batches if a board is selected
          if (selectedBoard != null && boardBatches[selectedBoard] != null)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: boardBatches[selectedBoard]!.length,
                itemBuilder: (context, index) {
                  final batch = boardBatches[selectedBoard]![index];
                  final course = Course(
                    title: batch['title'],
                    instructor: batch['instructor'],
                    description: batch['description'],
                    category: batch['category'],
                    language: batch['language'],
                    duration: batch['duration'],
                    price: batch['price'],
                    isPrivate: batch['isPrivate'],
                    hasCertificate: batch['hasCertificate'],
                    isOnline: batch['isOnline'],
                    rating: batch['rating'],
                    tags: List<String>.from(batch['tags']),
                    imagePath: batch['imagePath'],
                    videoPaths: List<String>.from(batch['videoPaths']),
                    notesPaths: List<String>.from(batch['notesPaths']),
                    learningPoints: List<String>.from(batch['learningPoints']),
                  );
                  // Pass the course to BatchCard
                  return BatchCard(course: course);
                },
              ),
            ),

          // Show message if no board is selected
          if (selectedBoard == null)
            const Expanded(
              child: Center(
                child: Text('Select a board to see available batches'),
              ),
            ),
        ],
      ),
    );
  }
}
