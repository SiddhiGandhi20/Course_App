import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/test_provider.dart';
import '../screens/test_details_screen.dart';

class TestsScreen extends StatefulWidget {
  final String userId;
  const TestsScreen({super.key, required this.userId});

  @override
  _TestsScreenState createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTests();
  }

  Future<void> _loadTests() async {
    if (widget.userId.isNotEmpty) {
      try {
        setState(() => _isLoading = true);
        await Provider.of<TestProvider>(context, listen: false)
            .fetchTests(widget.userId);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching tests: $e")),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid user ID!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final testProvider = Provider.of<TestProvider>(context);
    final tests = testProvider.tests;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Tests", style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadTests,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : tests.isEmpty
              ? const Center(child: Text("No tests available", style: TextStyle(fontSize: 16, color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: tests.length,
                  itemBuilder: (context, index) {
                    final test = tests[index];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                            child: Image.asset("assets/test.jpg", height: 160, width: double.infinity, fit: BoxFit.cover),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(test.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 5),
                                Text(test.description,
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("₹${test.price}",
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.blue.shade700)),
                                    test.isUnlocked
                                        ? const Icon(Icons.lock_open, color: Colors.green)
                                        : const Icon(Icons.lock, color: Colors.red),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.blue.shade700,
                                        side: BorderSide(color: Colors.blue.shade700),
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TestDetailsScreen(testId: test.id),
                                          ),
                                        );
                                      },
                                      child: const Text("Explore"),
                                    ),
                                    const SizedBox(width: 10),
                                    if (!test.isUnlocked)
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue.shade600,
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        onPressed: () async {
                                          bool success = await testProvider.unlockTest(widget.userId, test.id, test.price);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(success ? "Test Unlocked!" : "Payment Failed!")),
                                          );
                                        },
                                        child: const Text("Buy Now", style: TextStyle(color: Colors.white)),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
