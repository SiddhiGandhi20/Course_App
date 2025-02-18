import 'package:flutter/material.dart';
import '../models/batch.dart';
import '../widgets/batch_card.dart';
import '../widgets/bottom_nav.dart';

class BatchesScreen extends StatefulWidget {
  final String category;

  const BatchesScreen({super.key, required this.category});

  @override
  _BatchesScreenState createState() => _BatchesScreenState();
}

class _BatchesScreenState extends State<BatchesScreen> {
  List<Batch> batches = [
    Batch(title: "Math Batch 1", category: "5th Class", instructor: "Instructor A", timing: "9:00 AM - 11:00 AM", date: "2025-02-18", price: "500"),
    Batch(title: "Science Batch 1", category: "6th Class", instructor: "Instructor B", timing: "11:00 AM - 1:00 PM", date: "2025-02-19", price: "600"),
    Batch(title: "History Batch 1", category: "7th Class", instructor: "Instructor C", timing: "2:00 PM - 4:00 PM", date: "2025-02-20", price: "550"),
    // Add more batches as necessary
  ];

  List<Batch> get filteredBatches {
    return batches.where((batch) => batch.category == widget.category).toList();
  }

  int _selectedTab = 0;
  int _selectedIndex = 0; // Track bottom navigation index

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Batches for ${widget.category}',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 8,
        shadowColor: Colors.blue.withOpacity(0.5),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: filteredBatches.isEmpty
            ? Center(
                child: Text(
                  'No batches available',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blueGrey),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: filteredBatches.length,
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: BatchCard(batch: filteredBatches[index]),
                  );
                },
              ),
      ),
      // bottomNavigationBar: BottomNavBar(
      //   selectedIndex: _selectedIndex,
      //   onItemSelected: _onItemSelected,
      //   selectedCategory: widget.category, // Pass class name dynamically
      // ),
    );
  }
}
