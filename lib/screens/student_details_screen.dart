import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StudentDetailsScreen extends StatefulWidget {
  final String userId;
  final String fullName;
  final String mobileNumber;

  const StudentDetailsScreen({
    required this.userId,
    required this.fullName,
    required this.mobileNumber,
    super.key,
  });

  @override
  _StudentDetailsScreenState createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  List<dynamic> purchasedTests = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPurchasedTests();
  }

  Future<void> fetchPurchasedTests() async {
    final url =
        'http://192.168.29.33:5000/api/get-purchased-tests/${widget.userId}';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          purchasedTests = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'No purchased tests found';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch purchased tests';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Details - ${widget.fullName}",
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Details Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.fullName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.blueAccent),
                      const SizedBox(width: 8),
                      Text(
                        widget.mobileNumber,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.perm_identity, color: Colors.blueAccent),
                      const SizedBox(width: 8),
                      Text(
                        "User ID: ${widget.userId}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Purchased Tests Title
            const Text(
              'Purchased Tests',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // Purchased Tests List
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                    ? Center(
                        child: Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: purchasedTests.length,
                          itemBuilder: (context, index) {
                            final test = purchasedTests[index];

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              elevation: 3,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                title: Text(
                                  test['title'] ?? 'No Title',
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  test['description'] ?? 'No Description',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Text(
                                  '₹${test['price'] ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
