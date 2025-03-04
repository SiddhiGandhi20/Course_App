import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/course.dart';
import '../widgets/course_image_picker.dart';
import '../widgets/course_form_fields.dart';
import '../widgets/video_picker.dart';

class AddCourseScreen extends StatefulWidget {
  final Course? course;

  const AddCourseScreen({super.key, this.course});

  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _instructorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool isPrivateCourse = false;
  bool certificateAvailable = false;
  bool isOnlineCourse = true;
  String selectedLevel = 'Beginner';
  List<String> tags = ['5th', '6th'];
  String? selectedImagePath;
  List<String> selectedVideoPaths = [];
  List<String> selectedNotesPaths = [];
  String selectedCategory = 'Select Class';
  String selectedLanguage = 'English';
  String selectedRating = '5';
  List<String> learningPoints = ['Olympiad', 'Scholarships', 'Manthan'];

  @override
  void initState() {
    super.initState();
    if (widget.course != null) {
      _titleController.text = widget.course!.title;
      _instructorController.text = widget.course!.instructor;
      _descriptionController.text = widget.course!.description;
      _durationController.text = widget.course!.duration;
      _priceController.text = widget.course!.price.toString();
      selectedCategory = widget.course!.category;
      selectedLanguage = widget.course!.language;
      selectedImagePath = widget.course!.imagePath;
      selectedVideoPaths = widget.course!.videoPaths;
      selectedNotesPaths = widget.course!.notesPaths;
      tags = widget.course!.tags;
    }
  }

  Future<void> _pickNotes() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );

    if (result != null) {
      setState(() {
        selectedNotesPaths = result.paths.whereType<String>().toList();
      });
    }
  }

  Future<void> _saveCourse() async {
    debugPrint("Create Course button pressed.");
    if (_formKey.currentState!.validate()) {
      debugPrint("Validation successful. Proceeding to save course...");

      if (selectedImagePath == null || !File(selectedImagePath!).existsSync()) {
        _showError("Please select a valid course image.");
        return;
      }

      if (selectedVideoPaths.isEmpty) {
        _showError("Please select at least one video.");
        return;
      }

      if (selectedNotesPaths.isEmpty) {
        _showError("Please select at least one course note.");
        return;
      }

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://192.168.29.32:5000/api/courses'),
        );

        request.fields['title'] = _titleController.text.trim();
        request.fields['instructor'] = _instructorController.text.trim();
        request.fields['description'] = _descriptionController.text.trim();
        request.fields['category'] = selectedCategory;
        request.fields['language'] = selectedLanguage;
        request.fields['duration'] = _durationController.text.trim();
        request.fields['price'] = _priceController.text.trim();
        request.fields['is_private'] = isPrivateCourse.toString();
        request.fields['has_certificate'] = certificateAvailable.toString();
        request.fields['is_online'] = isOnlineCourse.toString();
        request.fields['rating'] = selectedRating;
        request.fields['tags'] = tags.join(',');
        request.fields['learning_points'] = learningPoints.join(',');
        request.fields['timing'] = '10:00 AM';
        request.fields['date'] = '2025-02-20';

        request.files.add(await http.MultipartFile.fromPath('image', selectedImagePath!));

        for (String videoPath in selectedVideoPaths) {
          request.files.add(await http.MultipartFile.fromPath('videos', videoPath));
        }

        for (String notePath in selectedNotesPaths) {
          request.files.add(await http.MultipartFile.fromPath('documents', notePath));
        }

        debugPrint("Sending API request...");

        var response = await request.send();
        var responseBody = await response.stream.bytesToString();

        debugPrint("Response Code: ${response.statusCode}");
        debugPrint("Response Body: $responseBody");

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Course added successfully!"), backgroundColor: Colors.green),
          );
          Navigator.pop(context);
        } else {
          _showError("Failed to add course. Response: $responseBody");
        }
      } catch (e) {
        debugPrint("Error during API call: $e");
        _showError("An error occurred: $e");
      }
    } else {
      debugPrint("Form validation failed.");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF0D47A1)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add New Course',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF0D47A1)),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFBBDEFB), Color(0xFFE3F2FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 70),
                CourseImagePicker(
                  onImageSelected: (path) {
                    setState(() {
                      selectedImagePath = path;
                    });
                  },
                ),
                const SizedBox(height: 20),
                VideoPicker(
                  onVideosSelected: (paths) {
                    setState(() {
                      selectedVideoPaths = paths;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _pickNotes,
                  icon: const Icon(Icons.note_add),
                  label: const Text("Add Course Notes"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                ),
                const SizedBox(height: 20),
                CourseFormFields(
                  titleController: _titleController,
                  instructorController: _instructorController,
                  descriptionController: _descriptionController,
                  onDescriptionChanged: (desc) => setState(() => _descriptionController.text = desc),
                  selectedLevel: selectedLevel,
                  isPrivateCourse: isPrivateCourse,
                  certificateAvailable: certificateAvailable,
                  isOnlineCourse: isOnlineCourse,
                  tags: tags,
                  selectedCategory: selectedCategory,
                  selectedLanguage: selectedLanguage,
                  courseDuration: _durationController.text,
                  coursePrice: _priceController.text,
                  selectedRating: selectedRating,
                  onLevelSelected: (level) => setState(() => selectedLevel = level),
                  onPrivateToggle: (value) => setState(() => isPrivateCourse = value),
                  onCertificateToggle: (value) => setState(() => certificateAvailable = value),
                  onOnlineToggle: (value) => setState(() => isOnlineCourse = value),
                  onTagAdded: (tag) => setState(() => tags.add(tag)),
                  onTagRemoved: (tag) => setState(() => tags.remove(tag)),
                  onCategorySelected: (category) => setState(() => selectedCategory = category),
                  onLanguageSelected: (language) => setState(() => selectedLanguage = language),
                  onDurationChanged: (duration) => setState(() => _durationController.text = duration),
                  onPriceChanged: (price) => setState(() => _priceController.text = price),
                  onTitleChanged: (value) {
                    setState(() {
                      _titleController.text = value;
                    });
                  },
                  onInstructorChanged: (instructor) => setState(() => _instructorController.text = instructor),
                  onRatingSelected: (rating) => setState(() => selectedRating = rating),
                  selectedVideoPaths: selectedVideoPaths,
                  selectedNotesPaths: selectedNotesPaths,
                  learningPoints: learningPoints,
                  onLearningPointAdded: (point) => setState(() => learningPoints.add(point)),
                  onLearningPointRemoved: (point) => setState(() => learningPoints.remove(point)),
                    ).animate().fade(duration: 600.ms).slideY(begin: 0.2, end: 0.0),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveCourse,
                  child: const Text('Create Course', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
