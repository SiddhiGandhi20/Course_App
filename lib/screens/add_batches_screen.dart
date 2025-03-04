import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:course_app/models/batch.dart';

class AddBatchesScreen extends StatefulWidget {
  final Function(Batch) onAddBatch;

  const AddBatchesScreen({super.key, required this.onAddBatch});

  @override
  _AddBatchesScreenState createState() => _AddBatchesScreenState();
}

class _AddBatchesScreenState extends State<AddBatchesScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String instructor = '';
  String category = '';
  String startDate = '';
  String duration = '';
  double price = 0.0;

  Future<void> _pickStartDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        startDate = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _saveBatch() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final newBatch = Batch(
        title: title,
        instructor: instructor,
        timing: '4:00 PM - 6:00 PM',
        date: startDate,
        category: category,
        price: price.toString(),
        duration: duration,
      );

      try {
        final response = await http.post(
          Uri.parse('http://192.168.29.32:5000/api/batches'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "title": title,
            "instructor": instructor,
            "timing": "4:00 PM - 6:00 PM",
            "date": startDate,
            "category": category,
            "price": price.toString(),
            "duration": duration,
          }),
        );

        if (response.statusCode == 201) {
          widget.onAddBatch(newBatch);
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add batch: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Batch'),
        backgroundColor: Colors.blue.shade700,
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Batch Title',
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSaved: (value) => title = value ?? '',
                  validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
                ),
                const SizedBox(height: 16),
                
                // Instructor Name Input Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Instructor Name',
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSaved: (value) => instructor = value ?? '',
                  validator: (value) => value!.isEmpty ? 'Please enter an instructor name' : null,
                ),
                const SizedBox(height: 16),
                
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  value: category.isEmpty ? null : category,
                  onChanged: (value) {
                    setState(() {
                      category = value ?? '';
                    });
                  },
                  items: ['5th Class', '6th Class', '7th Class'].map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please select a category'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(text: startDate),
                  onTap: _pickStartDate,
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                    hintText: 'Select a date',
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? 'Please select a start date' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Duration',
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSaved: (value) => duration = value ?? '',
                  validator: (value) => value!.isEmpty ? 'Please enter a duration' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => price = double.tryParse(value ?? '0') ?? 0.0,
                  validator: (value) => value!.isEmpty ? 'Please enter a price' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveBatch,
                  child: Text('Save Batch'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
