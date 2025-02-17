import 'package:flutter/material.dart';
import '../screens/my_courses_dashboard.dart';
import '../models/course.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final Course purchasedCourse;

  const PaymentSuccessScreen({super.key, required this.purchasedCourse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Successful'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              "Payment Successful!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Your course has been added to My Courses."),
            const SizedBox(height: 30),
           ElevatedButton(
            onPressed: () {
              // Directly navigate to MyCoursesDashboard (No need to add course again)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyCoursesDashboard(),
                ),
              );
            },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                "Go to Home",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
