import 'package:flutter/material.dart';
import '../models/batch.dart';
import 'add_batches_screen.dart';

class BatchesScreen extends StatefulWidget {
  const BatchesScreen({super.key});

  @override
  _BatchesScreenState createState() => _BatchesScreenState();
}

class _BatchesScreenState extends State<BatchesScreen> {
  List<Batch> batches = [];
  String? selectedCategory;

  // Add a new batch to the list
  void _addBatch(Batch batch) {
    setState(() {
      batches.add(batch);
    });
  }

  // Filter batches based on selected category
  List<Batch> get filteredBatches {
    if (selectedCategory == null || selectedCategory!.isEmpty) {
      return batches;
    }
    return batches.where((batch) => batch.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Batches'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter Dropdown
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              hint: const Text('Select Category'),
              value: selectedCategory,
              items: ['11', '12-PCM', '12-PCB', 'NEET']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
          ),

          // Display Batches
          Expanded(
            child: ListView.builder(
              itemCount: filteredBatches.length,
              itemBuilder: (context, index) {
                final batch = filteredBatches[index];
                return ListTile(
                  title: Text(batch.title),
                  subtitle: Text(batch.category),
                  trailing: Text('\$${batch.price}'),
                  onTap: () {
                    // Handle batch tap if needed
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddBatchesScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBatchesScreen(onAddBatch: _addBatch),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
