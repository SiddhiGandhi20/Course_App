import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/parent_dashboard_header.dart';

class ParentsDashboardScreen extends StatefulWidget {
  const ParentsDashboardScreen({super.key});

  @override
  _ParentsDashboardScreenState createState() => _ParentsDashboardScreenState();
}

class _ParentsDashboardScreenState extends State<ParentsDashboardScreen> {
  final TextEditingController _userIdController = TextEditingController();
  List<Map<String, dynamic>> linkedStudents = [];

  /// Base URL for Flask API
  final String baseUrl = "http://192.168.29.32:5000/api"; // Change if deployed

  /// Fetch student details and add to the linked students list
  Future<void> fetchStudentDetails() async {
    String userId = _userIdController.text.trim();
    if (userId.isEmpty) return;

    final response = await http.get(Uri.parse("$baseUrl/student/$userId"));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      Map<String, dynamic> student = decodedData["student"];

      setState(() {
        bool alreadyLinked = linkedStudents.any((s) => s['user_id'] == userId);
        if (!alreadyLinked) {
          linkedStudents.add({
            "user_id": userId,
            "full_name": student["full_name"] ?? "N/A",
            "mobile_number": student["mobile_number"] ?? "N/A",
            "purchased_courses": [],
          });
          saveLinkedStudent(userId);
          fetchPurchasedCourses(userId);
        }
      });
    } else {
      _showSnackBar("Student not found!");
    }

    _userIdController.clear(); // Clear input after linking
  }

  /// Save linked student to the parent's collection in the backend
Future<void> saveLinkedStudent(String studentId) async {
  print("Sending student ID: $studentId"); // Debugging statement

  final response = await http.post(
    Uri.parse("$baseUrl/parent/link-student"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"student_id": studentId}),
  );

  print("Response Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200 || response.statusCode == 201) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Student linked successfully!")),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to save linked student: ${response.body}")),
    );
  }
}


  /// Fetch purchased courses for a specific student
  Future<void> fetchPurchasedCourses(String studentId) async {
    final response = await http.get(Uri.parse("$baseUrl/student/$studentId/purchases"));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      List purchasedCourses = decodedData["purchased_courses"] ?? [];

      setState(() {
        for (var student in linkedStudents) {
          if (student["user_id"] == studentId) {
            student["purchased_courses"] = purchasedCourses;
          }
        }
      });
    }
  }

  /// Retrieve Parent ID from SharedPreferences
  Future<String?> getParentId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("parent_id"); // Ensure this is set during login
  }

  /// Display a SnackBar message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const ParentDashboardHeader(),
                  const SizedBox(height: 20),

                  /// **Student ID Input**
                  TextField(
                    controller: _userIdController,
                    decoration: InputDecoration(
                      labelText: "Enter Student ID",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: fetchStudentDetails,
                    child: Text("Link Student"),
                  ),
                  const SizedBox(height: 24),

                  /// **Show All Linked Students**
                  if (linkedStudents.isNotEmpty) ...[
                    Text(
                      "Linked Students:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...linkedStudents.map((student) => Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Student: ${student['full_name']}",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text("Phone: ${student['mobile_number']}"),
                                const SizedBox(height: 10),

                                /// **Purchased Courses**
                                Text(
                                  "Purchased Courses:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                student["purchased_courses"].isNotEmpty
                                    ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: student["purchased_courses"].map<Widget>((course) {
                                          return Text("• ${course["course_id"] ?? "Unknown Course"}");
                                        }).toList(),
                                      )
                                    : Text("No purchased courses."),
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
