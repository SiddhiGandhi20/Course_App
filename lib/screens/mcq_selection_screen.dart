import 'package:course_app/screens/test_details_screen.dart';
import 'package:flutter/material.dart';

class MCQSelectionScreen extends StatefulWidget {
  const MCQSelectionScreen({super.key});

  @override
  _MCQSelectionScreenState createState() => _MCQSelectionScreenState();
}

class _MCQSelectionScreenState extends State<MCQSelectionScreen> {
  String selectedFilter = "All"; // ✅ Default filter

  final List<Map<String, dynamic>> tests = [
    {
      'title': 'HSC BOARDS',
      'description': 'This test is for HSC Board students.',
      'imageUrl': 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-xMeXZP8Zj54Uw05JlofP5tcjq9B7DR.png',
      'questionCount': '25 MCQ Questions',
      'isFree': true,
    },
    {
      'title': 'NEET ASPIRANTS',
      'description': 'This test is for NEET aspirants.',
      'imageUrl': 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-xMeXZP8Zj54Uw05JlofP5tcjq9B7DR.png',
      'questionCount': '25 MCQ Questions',
      'isFree': false,
    },
    {
      'title': 'JEE Practice',
      'description': 'JEE preparation test.',
      'imageUrl': 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-xMeXZP8Zj54Uw05JlofP5tcjq9B7DR.png',
      'questionCount': '30 MCQ Questions',
      'isFree': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredTests = tests.where((test) {
      if (selectedFilter == "All") return true;
      return selectedFilter == "Free" ? test['isFree'] : !test['isFree'];
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select MCQ TEST'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ✅ Filter Buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterButton("All"),
                _buildFilterButton("Free"),
                _buildFilterButton("Premium"),
              ],
            ),
          ),

          // ✅ Display Filtered Test Cards
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: filteredTests.map((test) {
                    return Column(
                      children: [
                        _buildTestCard(
                          title: test['title'],
                          description: test['description'],
                          imageUrl: test['imageUrl'],
                          questionCount: test['questionCount'],
                          isFree: test['isFree'],
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Build Test Card
  Widget _buildTestCard({
    required String title,
    required String description,
    required String imageUrl,
    required String questionCount,
    required bool isFree,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), // ✅ Soft shadow for depth
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        color: Colors.white, // ✅ Card background color
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Image Section
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Title and Badge Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isFree
                              ? [Colors.blue.shade300, Colors.blue.shade700] // ✅ Gradient for Free
                              : [Colors.purple.shade300, Colors.purple.shade700], // ✅ Gradient for Premium
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isFree ? 'Free' : 'Premium',
                        style: const TextStyle(
                          color: Colors.white, // ✅ White text for readability
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ✅ Description
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 12),

                // ✅ Quiz Details
                Row(
                  children: [
                    Icon(Icons.quiz, size: 18, color: Colors.blue.shade700),
                    const SizedBox(width: 6),
                    Text(
                      questionCount,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ✅ Button Row (Explore + Enroll)
                Row(
                  children: [
                    // ✅ Explore Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TestDetailsScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue, // ✅ Text color
                          side: const BorderSide(color: Colors.blue, width: 2), // ✅ Blue outline
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Explore',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12), // ✅ Space between buttons

                    // ✅ Enroll Now Button (Fixed)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement enroll functionality
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // ✅ Blue background
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 4, // ✅ Slight button elevation
                          shadowColor: Colors.blueAccent,
                        ),
                        child: const Text(
                          'Enroll Now',
                          style: TextStyle(
                            color: Colors.white, // ✅ White text
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

  /// ✅ Filter Button Widget
  Widget _buildFilterButton(String label) {
    bool isSelected = selectedFilter == label;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ElevatedButton(
        onPressed: () => setState(() => selectedFilter = label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue.shade700 : Colors.grey.shade200,
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87)),
      ),
    );
  }
}
