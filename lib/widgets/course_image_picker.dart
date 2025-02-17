import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class CourseImagePicker extends StatefulWidget {
  final Function(String) onImageSelected;

  const CourseImagePicker({super.key, required this.onImageSelected});

  @override
  _CourseImagePickerState createState() => _CourseImagePickerState();
}

class _CourseImagePickerState extends State<CourseImagePicker> {
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  /// ✅ Request correct permissions based on Android version
  Future<void> _requestPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.photos.request();

      // if (status.isDenied || status.isPermanentlyDenied) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text("Permission is required to pick an image."),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      // }
    }
  }

  /// 📷 Pick image from gallery
  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });

        widget.onImageSelected(pickedFile.path);
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to pick an image. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _selectedImage!, // ✅ Load as FILE, not as asset
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.image, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Tap to select an image', style: TextStyle(color: Colors.grey)),
                ],
              ),
      ),
    );
  }
}
