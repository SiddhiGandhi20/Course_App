import 'package:course_app/screens/student_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ParentsDashboardScreen extends StatefulWidget {
  const ParentsDashboardScreen({super.key});

  @override
  _ParentsDashboardScreenState createState() => _ParentsDashboardScreenState();
}

class _ParentsDashboardScreenState extends State<ParentsDashboardScreen> {
  final TextEditingController parentMobileController = TextEditingController();
  final TextEditingController studentMobileController = TextEditingController();

  List<Map<String, dynamic>> studentsData = [];
  bool isLoading = false;

  final String baseUrl = "http://192.168.29.33:5000/api"; // Base API URL

  /// Fetch student details by mobile number
  Future<void> fetchStudentByMobile() async {
    final String mobileNumber = studentMobileController.text.trim();
    if (mobileNumber.isEmpty) {
      showSnackbar("⚠️ Please enter a student mobile number");
      return;
    }
    setLoading(true);
    try {
      final response = await http.get(Uri.parse('$baseUrl/register/mobile/$mobileNumber'));
      handleResponse(response, onSuccess: (data) {
        setState(() {
          studentsData = [data];
        });
      }, errorMessage: "❌ Student not found");
    } finally {
      setLoading(false);
    }
  }

  /// Fetch purchased tests for a student by user_id
  Future<void> fetchPurchasedTests(String userId) async {
    setLoading(true);
    try {
      final response = await http.get(Uri.parse('$baseUrl/get-purchased-tests/$userId'));
      
      handleResponse(response, onSuccess: (data) {
        if (data['purchased_tests'] != null) {
          List<dynamic> purchasedTests = data['purchased_tests'];
          
          if (purchasedTests.isEmpty) {
            showSnackbar("❌ No purchased tests found for this user.");
          } else {
            showPurchasedTestsDialog(purchasedTests);
          }
        } else {
          showSnackbar("❌ No purchased tests found.");
        }
      }, errorMessage: "❌ Failed to fetch purchased tests.");
    } catch (error) {
      showSnackbar("❌ An error occurred while fetching purchased tests: $error");
    } finally {
      setLoading(false);
    }
  }

 Future<void> linkStudent() async {
  final String parentMobile = parentMobileController.text.trim();
  final String studentMobile = studentMobileController.text.trim();
  
  if (parentMobile.isEmpty || studentMobile.isEmpty) {
    showSnackbar("⚠️ Enter both parent and student mobile numbers");
    return;
  }
  if (!isValidMobileNumber(parentMobile) || !isValidMobileNumber(studentMobile)) {
    showSnackbar("⚠️ Please enter valid 10-digit mobile numbers.");
    return;
  }

  setLoading(true);
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/parent/link-student"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"parent_mobile": parentMobile, "student_mobile": studentMobile}),
    );

    handleResponse(response, onSuccess: (data) {
      String studentName = data['student_name'] ?? "Student"; // Ensure a default name if missing
      showStudentLinkedDialog(studentName); // Show the success dialog
    });
  } finally {
    setLoading(false);
  }
}
void showStudentLinkedDialog(String studentName) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Student Linked"),
        content: Text("✅ $studentName has been linked successfully!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}


  /// Unlink a student from the parent
  Future<void> unlinkStudent(String studentMobile, String studentName) async {
  final String parentMobile = parentMobileController.text.trim();
  
  if (parentMobile.isEmpty) {
    showSnackbar("⚠️ Enter the parent mobile number first");
    return;
  }

  // Show confirmation dialog before unlinking
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Unlink Student"),
        content: Text("Are you sure you want to unlink $studentName?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close dialog
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog before calling API
              await unlinkStudentConfirmed(parentMobile, studentMobile, studentName);
            },
            child: const Text("Unlink", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}
Future<void> unlinkStudentConfirmed(String parentMobile, String studentMobile, String studentName) async {
  setLoading(true);
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/parent/unlink-student"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"parent_mobile": parentMobile, "student_mobile": studentMobile}),
    );

    handleResponse(response, onSuccess: (data) {
      showSnackbar("✅ $studentName has been unlinked successfully!");
      fetchLinkedStudents();
    });
  } finally {
    setLoading(false);
  }
}


  /// Fetch all linked students for the parent
  Future<void> fetchLinkedStudents() async {
  final String parentMobile = parentMobileController.text.trim();
  if (parentMobile.isEmpty) {
    showSnackbar("⚠️ Enter a parent mobile number");
    return;
  }
  setLoading(true);
  try {
    final response = await http.get(Uri.parse("$baseUrl/parent/get-linked-students/$parentMobile"));

    handleResponse(response, onSuccess: (data) {
      List<Map<String, dynamic>> linkedStudents = [];

      if (data['linked_students'] != null) {
        linkedStudents = List<Map<String, dynamic>>.from(data['linked_students']);
      }

      setState(() {
        studentsData = linkedStudents;
      });

      // Debugging: Print the fetched students
      print("Fetched linked students: $studentsData");
    }, errorMessage: "❌ No linked students found");
  } finally {
    setLoading(false);
  }
}


  /// Handles API response
  void handleResponse(http.Response response, {required Function(Map<String, dynamic>) onSuccess, String? errorMessage}) {
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData != null) {
        onSuccess(responseData);
      } else {
        showSnackbar(errorMessage ?? "❌ No data found");
      }
    } else {
      showSnackbar(errorMessage ?? "❌ Request failed");
    }
  }

  void setLoading(bool value) {
    setState(() => isLoading = value);
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars(); // Clear previous snackbars
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Show purchased tests in a dialog
  void showPurchasedTestsDialog(List<dynamic> tests) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Purchased Tests"),
          content: tests.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: tests.map((test) {
                    return ListTile(
                      title: Text(test['test_name']),
                      subtitle: Text("📆 Date: ${test['purchase_date']}"),
                    );
                  }).toList(),
                )
              : const Text("No purchased tests available"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  /// Validates the mobile number (10 digits)
  bool isValidMobileNumber(String mobileNumber) {
    final regex = RegExp(r'^[0-9]{10}$');  // For 10-digit numbers
    return regex.hasMatch(mobileNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent Dashboard", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField(parentMobileController, "Parent Mobile Number", Icons.person),
            const SizedBox(height: 12),
            buildTextField(studentMobileController, "Student Mobile Number", Icons.phone),
            const SizedBox(height: 20),
            buildActionButtons(),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (studentsData.isNotEmpty) buildStudentList(),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        prefixIcon: Icon(icon, color: Colors.blueAccent),
      ),
      keyboardType: TextInputType.phone,
    );
  }

  Widget buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildButton("Fetch", fetchStudentByMobile, Colors.blue, Icons.search),
        const SizedBox(width: 10),
        buildButton("Link", linkStudent, Colors.green, Icons.link),
        const SizedBox(width: 10),
        buildButton("View Linked", fetchLinkedStudents, Colors.orange, Icons.list),
      ],
    );
  }

  Widget buildButton(String text, VoidCallback onPressed, Color color, IconData icon) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget buildStudentList() {
    return Flexible(
      child: ListView.builder(
        itemCount: studentsData.length,
        itemBuilder: (context, index) {
          return buildStudentCard(studentsData[index]);
        },
      ),
    );
  }

 Widget buildStudentCard(Map<String, dynamic> student) {
  String fullName = student['full_name'] ?? 'Unknown Student';
  String mobileNumber = student['mobile_number'] ?? 'N/A';
  String userId = student['user_id']?.toString() ?? 'N/A'; // Ensure user_id is always displayed

  return Padding(
    padding: const EdgeInsets.only(top: 10.0),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          fullName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          "📞 Mobile: $mobileNumber\n🆔 User ID: $userId",
          style: const TextStyle(fontSize: 14),
        ),
        onTap: () {
          // Navigate to StudentDetailsScreen on card tap
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentDetailsScreen(
                userId: userId,
                fullName: fullName,
                mobileNumber: mobileNumber,
              ),
            ),
          );
        },
        trailing: IconButton(
          icon: const Icon(Icons.link_off, color: Colors.red),
          onPressed: () => unlinkStudent(mobileNumber, fullName),
        ),
      ),
    ),
  );
}

}
