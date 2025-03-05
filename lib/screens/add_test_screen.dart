import 'dart:io';
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
  List<File> _selectedImages = [];
  List<File> _selectedDocuments = [];

  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (mounted) {
      setState(() {
        _selectedImages = pickedFiles.map((e) => File(e.path)).toList();
      });
    }
  }

  Future<void> _pickDocuments() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      allowMultiple: true,
    );

    if (result != null && mounted) {
      setState(() {
        _selectedDocuments = result.paths.map((path) => File(path!)).toList();
      });
    }
  }

  Future<void> _uploadTest() async {
    var uri = Uri.parse("http://192.168.29.32:5000/api/add-test");
    var request = http.MultipartRequest('POST', uri);

    request.fields['title'] = _titleController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['price'] = _priceController.text;

    try {
      for (var image in _selectedImages) {
        request.files.add(await http.MultipartFile.fromPath(
          'images',
          image.path,
          filename: basename(image.path),
        ));
      }

      for (var doc in _selectedDocuments) {
        request.files.add(await http.MultipartFile.fromPath(
          'documents',
          doc.path,
          filename: basename(doc.path),
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
          backgroundColor: Colors.white, // ✅ Ensures white background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             
              SizedBox(height: 10),
              Icon(Icons.check_circle, color: Colors.green, size: 50), // ✅ Icon below GIF
              SizedBox(height: 10),
              Text(
                "Success",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(color: Colors.green),
              SizedBox(height: 10),
              Text(
                "Test Uploaded Successfully!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // ✅ Close dialog
                },
                child: Text(
                  "OK",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
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
  title: Text(
    "Add New Test",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white, // White text color
    ),
  ),
  backgroundColor: Colors.blueAccent,
  leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Colors.white), // White back icon
    onPressed: () {
      Navigator.of(context).pop(); // Navigate back
    },
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

                Text("Upload Images", style: _sectionTitleStyle),
                SizedBox(height: 8),
             OutlinedButton.icon(
  onPressed: _pickImages,
  icon: Icon(Icons.image, color: Colors.blueAccent),
  label: Padding(
    padding: EdgeInsets.symmetric(horizontal: 8), // Added spacing between icon and text
    child: Text("Pick Images"),
  ),
  style: OutlinedButton.styleFrom(
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Added padding for proper spacing
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    side: BorderSide(color: Colors.blueAccent),
  ),
),
SizedBox(height: 20),

Text("Upload Documents", style: _sectionTitleStyle),
SizedBox(height: 8),

OutlinedButton.icon(
  onPressed: _pickDocuments,
  icon: Icon(Icons.upload_file, color: Colors.blueAccent),
  label: Padding(
    padding: EdgeInsets.symmetric(horizontal: 8), // Added spacing between icon and text
    child: Text("Pick Documents"),
  ),
  style: OutlinedButton.styleFrom(
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Added padding for proper spacing
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    side: BorderSide(color: Colors.blueAccent),
  ),
),

                _buildDocumentPreview(),
                SizedBox(height: 30),

               Center(
  child: ElevatedButton.icon(
    onPressed: _uploadTest,
    icon: Icon(Icons.cloud_upload, color: Colors.white), // White icon color
    label: Text(
      "Upload Test",
      style: TextStyle(color: Colors.white), // White text color
    ),
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.blueAccent,
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_selectedImages.isEmpty) return SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _selectedImages.map((img) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(img, width: 80, height: 80, fit: BoxFit.cover),
        );
      }).toList(),
    );
  }

  Widget _buildDocumentPreview() {
    if (_selectedDocuments.isEmpty) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _selectedDocuments.map((doc) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(Icons.insert_drive_file, color: Colors.blueAccent),
              SizedBox(width: 8),
              Expanded(child: Text(basename(doc.path), overflow: TextOverflow.ellipsis)),
            ],
          ),
        );
      }).toList(),
    );
  }

  final TextStyle _sectionTitleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent);
  final ButtonStyle _buttonStyle = OutlinedButton.styleFrom(
    padding: EdgeInsets.symmetric(vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    side: BorderSide(color: Colors.blueAccent),
  );
}
