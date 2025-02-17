import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class MediaPicker extends StatefulWidget {
  final Function(List<String> videoPaths, List<String> notesPaths) onMediaSelected;

  const MediaPicker({super.key, required this.onMediaSelected});

  @override
  _MediaPickerState createState() => _MediaPickerState();
}

class _MediaPickerState extends State<MediaPicker> {
  List<String> selectedVideos = [];
  List<String> selectedNotes = [];

 Future<void> _pickMedia() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['mp4', 'avi', 'mov', 'mkv', 'pdf', 'doc', 'docx', 'txt'],
    allowMultiple: true,
  );

  if (result != null) {
    List<String> videos = List.from(selectedVideos);
    List<String> notes = List.from(selectedNotes);

    for (String? path in result.paths) {
      if (path != null) {
        File file = File(path);
        if (file.existsSync()) {
          if ((path.endsWith('.mp4') || path.endsWith('.avi') || path.endsWith('.mov') || path.endsWith('.mkv')) &&
              !videos.contains(path)) {
            videos.add(path);
            print("✅ Added video: $path");
          } else if ((path.endsWith('.pdf') || path.endsWith('.doc') || path.endsWith('.docx') || path.endsWith('.txt')) &&
              !notes.contains(path)) {
            notes.add(path);
            print("✅ Added note: $path");
          }
        } else {
          print("❌ Skipping non-existent file: $path");
        }
      }
    }

    setState(() {
      selectedVideos = videos;
      selectedNotes = notes;
    });

    widget.onMediaSelected(videos, notes);
  }
}



  void _removeFile(String filePath) {
    setState(() {
      selectedVideos.remove(filePath);
      selectedNotes.remove(filePath);
    });
    widget.onMediaSelected(selectedVideos, selectedNotes);
  }

  Widget _buildFileList(List<String> files, IconData icon, String title) {
    if (files.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        ...files.map((file) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon, color: Colors.blue),
            title: Text(
              file.split('/').last,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => _removeFile(file),
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Course Media (Videos & Notes)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _pickMedia,
          icon: const Icon(Icons.upload_file),
          label: const Text('Upload Media'),
        ),
        const SizedBox(height: 10),
        _buildFileList(selectedVideos, Icons.video_library, "Videos:"),
        _buildFileList(selectedNotes, Icons.description, "Notes:"),
      ],
    );
  }
}
