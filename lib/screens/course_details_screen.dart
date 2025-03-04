import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import '../styles/course_styles.dart';
import '../widgets/video_player_widget.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseDetailsScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailsScreen({super.key, required this.courseId});

  @override
  _CourseDetailsScreenState createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  Course? course;
  bool isLoading = true;
  bool isNotFound = false;

  @override
  void initState() {
    super.initState();
    _fetchCourse();
  }

  Future<void> _fetchCourse() async {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final fetchedCourse = await courseProvider.fetchCourseById(widget.courseId);

    if (fetchedCourse != null) {
      setState(() {
        course = fetchedCourse;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        isNotFound = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (isNotFound || course == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course Not Found')),
        body: const Center(child: Text('The course you are looking for does not exist.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(course!.title, style: const TextStyle(fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(course!),
            _buildCourseStats(course!),
            _buildDescription(course!),
            _buildWhatYoullLearn(course!),
            _buildTags(course!),
            _buildVideos(course!),
            _buildNotes(course!),
          ],
        ),
      ),
    );
  }

  // 🔹 UI Helper Functions

  Widget _buildHeader(Course course) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(course.imagePath),
            ),
          ),
          const SizedBox(height: 16),
          Text(course.title, style: CourseStyles.headerTextStyle),
          const SizedBox(height: 8),
          Text('Instructor: ${course.instructor}', style: CourseStyles.subTextStyle),
          const SizedBox(height: 16),
          Row(
            children: [
              buildStatItem(Icons.star, '${course.rating} ★'),
              const SizedBox(width: 16),
              buildStatItem(Icons.access_time, course.duration),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '₹${course.price.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String? imagePath) {
    if (imagePath != null && imagePath.startsWith('http')) {
      return Image.network(imagePath, fit: BoxFit.cover, width: double.infinity, height: 200);
    } else if (imagePath != null && imagePath.isNotEmpty) {
      return Image.file(File(imagePath), fit: BoxFit.cover, width: double.infinity, height: 200);
    } else {
      return Container(
        width: double.infinity,
        height: 200,
        color: Colors.grey[300],
        child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
      );
    }
  }

  Widget buildStatItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 6),
        Text(text, style: CourseStyles.subTextStyle),
      ],
    );
  }

  Widget _buildCourseStats(Course course) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatBox('Class', course.category),
          _buildStatBox('Language', course.language),
          _buildStatBox('Certificate', course.hasCertificate ? 'Yes' : 'No'),
          _buildStatBox('Online', course.isOnline ? 'Yes' : 'No'),
        ],
      ),
    );
  }

  Widget _buildStatBox(String title, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(title, style: CourseStyles.statTextStyle),
      ],
    );
  }

  Widget _buildDescription(Course course) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Course Description', style: CourseStyles.sectionTitleStyle),
          const SizedBox(height: 8),
          Text(course.description, style: CourseStyles.subTextStyle),
        ],
      ),
    );
  }

  Widget _buildWhatYoullLearn(Course course) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('What You\'ll Learn', style: CourseStyles.sectionTitleStyle),
          const SizedBox(height: 16),
          Column(
            children: course.learningPoints.map((point) => buildLearnItem(point)).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildLearnItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: CourseStyles.subTextStyle)),
        ],
      ),
    );
  }

  Widget _buildTags(Course course) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        children: course.tags.map((tag) => Chip(label: Text(tag))).toList(),
      ),
    );
  }

  Widget _buildVideos(Course course) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Course Videos', style: CourseStyles.sectionTitleStyle),
          const SizedBox(height: 10),
          course.videoPaths.isEmpty
              ? const Text('No videos available', style: TextStyle(color: Colors.grey))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: course.videoPaths.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: VideoPlayerWidget(videoPath: course.videoPaths[index]),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildNotes(Course course) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Course Notes', style: CourseStyles.sectionTitleStyle),
          const SizedBox(height: 10),
          course.notesPaths.isEmpty
              ? const Text('No notes available', style: TextStyle(color: Colors.grey))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: course.notesPaths.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(course.notesPaths[index].split('/').last),
                      leading: const Icon(Icons.file_present, color: Colors.blue),
                      trailing: IconButton(
                        icon: const Icon(Icons.open_in_new, color: Colors.blue),
                        onPressed: () => OpenFile.open(course.notesPaths[index]),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
