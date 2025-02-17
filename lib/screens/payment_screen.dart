import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/payment_success_screen.dart';
import '../providers/course_provider.dart';
import '../models/course.dart';

class PaymentScreen extends StatelessWidget {
  final double amount;
  final Course course; // Course being purchased

  const PaymentScreen({super.key, required this.amount, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _decorativeCard([
              _infoRow(
                'Total Payable Amount:',
                '₹${amount.toStringAsFixed(2)}',
                bold: true,
                highlight: true,
              ),
            ]),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
  // Add the course only in PaymentScreen
              Provider.of<CourseProvider>(context, listen: false).addCourse(course);

              // Navigate to Payment Success Screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentSuccessScreen(purchasedCourse: course),
                ),
              );
            },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Pay Now',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool bold = false, bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: highlight ? Colors.blue : Colors.black,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: highlight ? Colors.blue : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _decorativeCard(List<Widget> children) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }
}
