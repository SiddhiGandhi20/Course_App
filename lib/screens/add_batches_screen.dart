import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  String category = '';
  String startDate = '';
  String duration = '';
  double price = 0.0;
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickStartDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        // Format the date to "yyyy-MM-dd"
        startDate = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void _saveBatch() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Creating the batch object
      final newBatch = Batch(
        title: title,
        instructor: 'Instructor Name',  // Placeholder for the instructor name
        timing: '9:00 AM to 11:00 AM',  // Placeholder for the timing
        date: startDate,  // Using the startDate for batch date
        category: category,
        price: price.toString(),  // Converting the price to a string
      );

      // Add batch and return to the previous screen
      widget.onAddBatch(newBatch);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Batch'),
        backgroundColor: Colors.blue.shade700, // Elegant Blue
        elevation: 4.0, // Subtle shadow for the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Picker at the top
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _imageFile == null
                      ? const Icon(
                          Icons.camera_alt,
                          size: 100,
                          color: Colors.grey,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Form to fill batch details
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Field
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Batch Title',
                        labelStyle: TextStyle(color: Colors.blue.shade700),
                        filled: true,
                        fillColor: Colors.blue.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue.shade200),
                        ),
                      ),
                      onSaved: (value) => title = value ?? '',
                      validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
                    ),
                    const SizedBox(height: 16),

                    // Category Dropdown Field
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Category',
                        labelStyle: TextStyle(color: Colors.blue.shade700),
                        filled: true,
                        fillColor: Colors.blue.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue.shade200),
                        ),
                      ),
                      value: category.isEmpty ? null : category,
                      onChanged: (value) {
                        setState(() {
                          category = value ?? '';
                        });
                      },
                      items: [
                        '5th Class',
                        '6th Class',
                        '7th Class'
                      ].map((category) {
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

                    // Start Date Field with Calendar Picker
                    TextFormField(
                      readOnly: true,  // Make it read-only to indicate it's not editable
                      controller: TextEditingController(text: startDate),
                      onTap: _pickStartDate,
                      decoration: InputDecoration(
                        labelText: 'Start Date',
                        labelStyle: TextStyle(color: Colors.blue.shade700),
                        hintText: 'Select a date',
                        filled: true,
                        fillColor: Colors.blue.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue.shade200),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please select a start date' : null,
                    ),
                    const SizedBox(height: 16),

                    // Duration Field
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Duration',
                        labelStyle: TextStyle(color: Colors.blue.shade700),
                        filled: true,
                        fillColor: Colors.blue.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue.shade200),
                        ),
                      ),
                      onSaved: (value) => duration = value ?? '',
                      validator: (value) => value!.isEmpty ? 'Please enter a duration' : null,
                    ),
                    const SizedBox(height: 16),

                    // Price Field
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Price',
                        labelStyle: TextStyle(color: Colors.blue.shade700),
                        filled: true,
                        fillColor: Colors.blue.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue.shade200),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => price = double.tryParse(value ?? '0') ?? 0.0,
                      validator: (value) => value!.isEmpty ? 'Please enter a price' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveBatch,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5, // Adds depth to the button with a subtle shadow
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade600, Colors.blue.shade800],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          alignment: Alignment.center,
                          child: Text(
                            'Save Batch',
                            style: TextStyle(
                              fontSize: 18, // Slightly larger text
                              fontWeight: FontWeight.w600, // Semi-bold font weight
                              color: Colors.white, // White color for contrast
                              letterSpacing: 1.2, // Slight letter spacing for better readability
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
