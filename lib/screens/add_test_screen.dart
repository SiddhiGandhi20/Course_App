import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AddTestScreen extends StatefulWidget {
  const AddTestScreen({super.key});

  @override
  _AddTestScreenState createState() => _AddTestScreenState();
}

class _AddTestScreenState extends State<AddTestScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  
  List<Map<String, dynamic>> _selectedImages = []; // Store images as {name, bytes}
  List<Map<String, dynamic>> _selectedDocuments = []; // Store docs as {name, bytes}
  String? _selectedCategory;
  
  final List<String> _categories = ['5th Class', '6th Class', '7th Class'];

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && mounted) {
      List<Map<String, dynamic>> images = await Future.wait(pickedFiles.map((file) async {
        Uint8List bytes = await file.readAsBytes();
        return {'name': basename(file.path), 'bytes': bytes};
      }));

      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  Future<void> _pickDocuments() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      allowMultiple: true,
      withData: true, // ✅ Required for web compatibility
    );

    if (result != null && mounted) {
      List<Map<String, dynamic>> documents = result.files.map((file) {
        return {'name': file.name, 'bytes': file.bytes};
      }).toList();

      setState(() {
        _selectedDocuments.addAll(documents);
      });
    }
  }

  Future<void> _uploadTest() async {
    var uri = Uri.parse("http://192.168.29.32:5000/api/add-test");
    var request = http.MultipartRequest('POST', uri);

    request.fields['title'] = _titleController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['price'] = _priceController.text;
    request.fields['category'] = _selectedCategory ?? "";

    try {
      for (var image in _selectedImages) {
        request.files.add(http.MultipartFile.fromBytes(
          'images',
          image['bytes'],
          filename: image['name'],
        ));
      }

      for (var doc in _selectedDocuments) {
        request.files.add(http.MultipartFile.fromBytes(
          'documents',
          doc['bytes'],
          filename: doc['name'],
        ));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (!mounted) return;

      if (response.statusCode == 201) {
        _showSuccessDialog();
      } else {
        _showErrorDialog("Upload Failed! Server Response: $responseBody");
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog("Error: ${e.toString()}");
      }
    }
  }

  void _showSuccessDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 50),
                SizedBox(height: 10),
                Text(
                  "Test Uploaded Successfully!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text("OK", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  void _showErrorDialog(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Row(
              children: [
                Icon(Icons.error, color: Colors.red, size: 28),
                SizedBox(width: 10),
                Text(
                  "Error",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(color: Colors.red),
                SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: Text("OK", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Add New Test"),
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(_titleController, "Title", Icons.title),
                SizedBox(height: 12),
                _buildTextField(_descriptionController, "Description", Icons.description),
                SizedBox(height: 12),
                _buildTextField(_priceController, "Price", Icons.currency_rupee, keyboardType: TextInputType.number),
                SizedBox(height: 20),

                Text("Select Category", style: _sectionTitleStyle),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  items: _categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
                  onChanged: (value) => setState(() => _selectedCategory = value),
                ),
                SizedBox(height: 20),

                _buildFilePicker("Upload Images", Icons.image, _pickImages),
                _buildFilePicker("Upload Documents", Icons.upload_file, _pickDocuments),
                SizedBox(height: 30),

                Center(
                  child: ElevatedButton.icon(
                    onPressed: _uploadTest,
                    icon: Icon(Icons.cloud_upload),
                    label: Text("Upload Test"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilePicker(String label, IconData icon, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }

  final TextStyle _sectionTitleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
   Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
