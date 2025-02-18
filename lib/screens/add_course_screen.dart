import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart'; // Import File Picker
import 'dart:io';

import '../providers/course_provider.dart';
import '../models/course.dart';
import '../widgets/course_image_picker.dart';
import '../widgets/course_form_fields.dart';
import '../widgets/video_picker.dart'; // Import Video Picker

class AddCourseScreen extends StatefulWidget {
  final Course? course; // Make the course parameter nullable

  const AddCourseScreen({super.key, this.course}); // Allow null or pass a course

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
  List<String> learningPoints = [
    'Olympiad',
    'Scholarships',
    'Manthan',
  ];

  @override
  void initState() {
    super.initState();

    // If a course is passed, pre-fill the fields with its data
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

  // Function to Pick Course Notes from Local Storage
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

  void _saveCourse() {
    if (_formKey.currentState!.validate()) {
      String title = _titleController.text.trim();
      String instructor = _instructorController.text.trim();
      String description = _descriptionController.text.trim();
      String courseDuration = _durationController.text.trim();
      String coursePrice = _priceController.text.trim();

      if (selectedImagePath == null || !File(selectedImagePath!).existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select a valid course image."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (selectedVideoPaths.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select at least one video."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (selectedNotesPaths.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select at least one course note."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (instructor.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter an instructor name."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Assuming you have necessary values from user input, here's how you'd create a course
      final course = Course(
        title: title,
        instructor: instructor,
        description: description,
        category: selectedCategory,
        language: selectedLanguage,
        duration: courseDuration,
        price: double.parse(coursePrice),
        isPrivate: isPrivateCourse,
        hasCertificate: certificateAvailable,
        isOnline: isOnlineCourse,
        rating: double.parse(selectedRating),
        tags: tags,
        imagePath: selectedImagePath,
        videoPaths: selectedVideoPaths,
        notesPaths: selectedNotesPaths,
        learningPoints: learningPoints, timing: null, date: null,
      );

      // If the course is being updated, you might want to update instead of adding
      if (widget.course != null) {
        Provider.of<CourseProvider>(context, listen: false).updateCourse(course);
      } else {
        Provider.of<CourseProvider>(context, listen: false).addCourse(course);
      }

      Navigator.pop(context);
    }
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
                ).animate().fade(duration: 500.ms).slideY(begin: 0.3, end: 0.0),
                const SizedBox(height: 20),
                VideoPicker(
                  onVideosSelected: (paths) {
                    setState(() {
                      selectedVideoPaths = paths;
                    });
                  },
                ).animate().fade(duration: 500.ms).slideY(begin: 0.3, end: 0.0),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _pickNotes,
                  icon: const Icon(Icons.note_add),
                  label: const Text("Add Course Notes"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
                if (selectedNotesPaths.isNotEmpty)
                  Column(
                    children: selectedNotesPaths
                        .map((path) => ListTile(
                              title: Text(
                                path.split('/').last,
                                style: const TextStyle(fontSize: 14),
                              ),
                              leading: const Icon(Icons.description, color: Colors.blue),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    selectedNotesPaths.remove(path);
                                  });
                                },
                              ),
                            ))
                        .toList(),
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
                Center(
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        shadowColor: const Color.fromARGB(255, 5, 143, 255),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      ),
                      onPressed: _saveCourse,
                      child: const Text(
                        'Create Course',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ).animate().fade(duration: 700.ms).scale(begin: Offset(0.8, 0.8), end: Offset(1.0, 1.0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
