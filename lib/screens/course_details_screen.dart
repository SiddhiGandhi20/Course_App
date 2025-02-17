import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import '../styles/course_styles.dart';
import '../widgets/video_player_widget.dart';

import '../models/course.dart';

class CourseDetailsScreen extends StatelessWidget {
  final Course course;

  const CourseDetailsScreen({super.key, required this.course});

  void _openFile(String filePath) {
    OpenFile.open(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title, style: const TextStyle(fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildCourseStats(),
            _buildDescription(), // ✅ Added Description Section
            _buildWhatYoullLearn(),
            _buildTags(), // ✅ Added Tags Section
            _buildVideos(),
            _buildNotes(),
          ],
        ),
      ),
    );
  }

  // 🔹 Header Section
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(),
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

  // 🔹 Image Handling
  Widget _buildImage() {
    if (course.imagePath != null && course.imagePath!.startsWith('http')) {
      return Image.network(course.imagePath!,
          fit: BoxFit.cover, width: double.infinity, height: 200);
    } else if (course.imagePath != null && course.imagePath!.isNotEmpty) {
      return Image.file(File(course.imagePath!),
          fit: BoxFit.cover, width: double.infinity, height: 200);
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

  // 🔹 Course Stats
  Widget _buildCourseStats() {
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

  // 🔹 Course Description
  Widget _buildDescription() {
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

  // 🔹 What You'll Learn
  Widget _buildWhatYoullLearn() {
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

  // 🔹 Course Tags
  Widget _buildTags() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        children: course.tags.map((tag) => Chip(label: Text(tag))).toList(),
      ),
    );
  }

Widget _buildVideos() {
  print("📂 Checking videos: ${course.videoPaths}");

  return FutureBuilder(
    future: Future.delayed(const Duration(milliseconds: 200)), // Delay UI updates slightly
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const Center(child: CircularProgressIndicator());
      }

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
                      print("🎥 Video Path: ${course.videoPaths[index]}");

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: VideoPlayerWidget(videoPath: course.videoPaths[index]),
                      );
                    },
                  ),
          ],
        ),
      );
    },
  );
}




  // 🔹 Course Notes
  Widget _buildNotes() {
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
                    String notePath = course.notesPaths[index];
                    return ListTile(
                      title: Text(
                        notePath.split('/').last,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      leading: const Icon(Icons.file_present, color: Colors.blue),
                      trailing: IconButton(
                        icon: const Icon(Icons.open_in_new, color: Colors.blue),
                        onPressed: () => _openFile(notePath),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
