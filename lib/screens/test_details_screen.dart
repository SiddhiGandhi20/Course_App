import 'dart:convert';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../screens/pfd_viewer_screen.dart';

class TestDetailsScreen extends StatefulWidget {
  final String testId; // Receive only the test ID

  const TestDetailsScreen({super.key, required this.testId});

  @override
  _TestDetailsScreenState createState() => _TestDetailsScreenState();
}

class _TestDetailsScreenState extends State<TestDetailsScreen> {
  late Map<String, dynamic> testDetails;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchTestDetails();
  }

  Future<void> fetchTestDetails() async {
    final apiUrl = "http://192.168.29.32:5000/api/get-test/${widget.testId}";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          testDetails = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Test Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(child: Text("Failed to load test details."))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 📜 Title
                      Text(
                        testDetails['title'],
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      // 📝 Description
                      Text(
                        testDetails['description'],
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),

                      // 🖼️ Display Images (API Returns List of Image URLs)
                      if (testDetails['images'] != null && testDetails['images'].isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Images:",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: testDetails['images'].length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Image.network(
                                      testDetails['images'][index],
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.broken_image, size: 150),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),

                      // 📄 Display Documents (PDFs)
                      if (testDetails['documents'] != null && testDetails['documents'].isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Documents:",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              children: (testDetails['documents'] as List).map((docUrl) {
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  child: ListTile(
                                    leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                                    title: Text(docUrl.split('/').last),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.open_in_new),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PDFViewerScreen(pdfUrl: docUrl, pdfPath: '',),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
    );
  }
}
