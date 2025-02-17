import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class VideoPicker extends StatefulWidget {
  final Function(List<String>) onVideosSelected;

  const VideoPicker({super.key, required this.onVideosSelected});

  @override
  _VideoPickerState createState() => _VideoPickerState();
}

class _VideoPickerState extends State<VideoPicker> {
  List<String> selectedVideos = [];

  Future<void> _pickVideos() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        selectedVideos = result.paths.whereType<String>().toList();
      });
      widget.onVideosSelected(selectedVideos);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Course Videos",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _pickVideos,
          icon: const Icon(Icons.video_library),
          label: const Text("Pick Videos"),
        ),
        const SizedBox(height: 10),
        selectedVideos.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: selectedVideos
                    .map((video) => Text(
                          video.split('/').last,
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          overflow: TextOverflow.ellipsis,
                        ))
                    .toList(),
              )
            : const Text(
                "No videos selected",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
      ],
    );
  }
}
