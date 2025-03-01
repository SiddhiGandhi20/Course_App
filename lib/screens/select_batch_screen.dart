import 'package:flutter/material.dart';
import '../models/batch.dart'; // Import the Batch model
import '../widgets/batch_card.dart'; // Import the BatchCard widget

class SelectBatchScreen extends StatefulWidget {
  const SelectBatchScreen({super.key});

  @override
  _SelectBatchScreenState createState() => _SelectBatchScreenState();
}

class _SelectBatchScreenState extends State<SelectBatchScreen> {
  String? selectedBoard;

  // final List<String> boards = ['5th Class', '6th Class', '7th Class'];

  final Map<String, List<Batch>> boardBatches = {
    // '5th Class': [
    //   Batch(
    //     title: '5th Grade Science Batch',
    //     instructor: 'Mrs. Priya Singh',
    //     timing: '10:00 AM to 12:00 PM',
    //     date: 'Monday, Wednesday, Friday',
    //     price: '5000',
    //     category: '5th Class'
    //   ),
    // ],
    // '6th Class': [
    //   Batch(
    //     title: '6th Grade Math Batch',
    //     instructor: 'Mr. Ravi Kumar',
    //     timing: '1:00 PM to 3:00 PM',
    //     date: 'Tuesday, Thursday',
    //      price: '5000',
    //     category: '6th Class'
    //   ),
    // ],
    // '7th Class': [
    //   Batch(
    //     title: '7th Grade History Batch',
    //     instructor: 'Dr. Suresh Verma',
    //     timing: '3:00 PM to 5:00 PM',
    //     date: 'Monday, Wednesday',
    //      price: '5000',
    //     category: '7th Class'
    //   ),
    // ],
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
          'Select Your Class',
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
            // child: DropdownButtonFormField<String>(
            //   value: selectedBoard,
            //   hint: const Text('Select a Grade'),
            //   decoration: InputDecoration(
            //     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            //   ),
            //   items: boards.map((board) {
            //     return DropdownMenuItem<String>(
            //       value: board,
            //       child: Text(board),
            //     );
            //   }).toList(),
            //   onChanged: (value) {
            //     setState(() {
            //       selectedBoard = value;
            //     });
            //   },
            // ),
          ),

          // Only display batches if a board is selected
          if (selectedBoard != null && boardBatches[selectedBoard] != null)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: boardBatches[selectedBoard]!.length,
                itemBuilder: (context, index) {
                  final batch = boardBatches[selectedBoard]![index];
                  // Pass the batch to BatchCard widget
                  return BatchCard(batch: batch);
                },
              ),
            ),

          // Show message if no board is selected
          if (selectedBoard == null)
            const Expanded(
              child: Center(
                child: Text('Select a grade to see available batches'),
              ),
            ),
        ],
      ),
    );
  }
}
