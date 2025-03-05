import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/test.dart';

class TestProvider with ChangeNotifier {
  List<Test> _tests = [];

  List<Test> get tests => _tests;

  // 🚀 Fetch tests from the backend
Future<void> fetchTests(String userId) async {
  final url = Uri.parse('http://192.168.29.32:5000/api/get-tests/$userId');
  print("Fetching tests for user: $userId");

  try {
    final response = await http.get(url);
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}"); // 👀 Debugging API response

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print("✅ Parsed Data: $data"); // 👀 Check if parsed correctly

      if (data.isNotEmpty) {
        _tests = data.map((item) => Test.fromJson(item)).toList();
        print("✅ Tests loaded: ${_tests.length}");
        notifyListeners();
      } else {
        print("⚠️ No tests found in API response.");
      }
    } else {
      print("❌ Failed to fetch tests: ${response.body}");
    }
  } catch (error) {
    print("🚨 Error fetching tests: $error");
  }
}


  // 🚀 Unlock test after payment
  Future<bool> unlockTest(String userId, String testId, double amount) async {
    final url = Uri.parse('http://192.168.29.32:5000/api/pay-test');

    try {
      print("🔄 Sending payment request: userId=$userId, testId=$testId, amount=$amount");

      final response = await http.post(
        url,
        body: json.encode({'userId': userId, 'testId': testId, 'amount': amount}),
        headers: {'Content-Type': 'application/json'},
      );

      print("🔍 Response Status Code: ${response.statusCode}");
      print("🔍 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // ✅ Unlock test locally
        int index = _tests.indexWhere((test) => test.id == testId);
        if (index != -1) {
          _tests[index] = _tests[index].copyWith(isUnlocked: true);
          notifyListeners();
        }
        return true;
      } else {
        print("❌ Payment failed: ${response.body}");
      }
    } catch (error) {
      print("🚨 Error during payment: $error");
    }

    return false;
  }
}
