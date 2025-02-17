import 'dart:io';
import 'package:flutter/material.dart';
import '../models/course.dart';
// Assuming this is where styles like `PricingStyles` are defined
import '../widgets/pricing_widgets.dart'; // Assuming this file contains the widgets you provided
import '../screens/order_summary_screen.dart'; // Import OrderSummaryScreen

class CoursePricingScreen extends StatefulWidget {
  final Course course;

  const CoursePricingScreen({super.key, required this.course});

  @override
  _CoursePricingScreenState createState() => _CoursePricingScreenState();
}

class _CoursePricingScreenState extends State<CoursePricingScreen> {
  // State to manage the selected pricing plan
  bool isRegularSelected = true;

  // Function to toggle the selected pricing plan
  void togglePricingTab(bool isRegular) {
    setState(() {
      isRegularSelected = isRegular;
    });
  }

  // Function to get the displayed price based on the selected plan
  double get displayedPrice {
    return isRegularSelected ? widget.course.price : widget.course.price * 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 📌 Course Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: widget.course.imagePath != null && File(widget.course.imagePath!).existsSync()
                    ? Image.file(
                        File(widget.course.imagePath!),
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/default_course.jpg',
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
              ),

              const SizedBox(height: 16),

              /// 📌 Course Title (Displaying Course Name)
              Text(
                widget.course.title,  // Display course name here
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              /// 📌 Instructor Name
              Text(
                "Instructor: ${widget.course.instructor}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),

              /// 📌 Price (Dynamic)
              Text(
                displayedPrice == 0
                    ? "Free"
                    : "₹${displayedPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),

              /// 📌 Pricing Tabs (Regular / Premium)
              buildPricingTabs(),
              const SizedBox(height: 20),

              /// 📌 Features Section
              buildFeatureSection(
                'Course Features',
                [
                  buildFeatureRow('Lifetime Access', true, true),
                  buildFeatureRow('Certificate Included', widget.course.hasCertificate, true),
                  buildFeatureRow('Premium Support', false, true),
                  buildFeatureRow('Online Status', widget.course.isOnline, false),
                ],
              ),

              const SizedBox(height: 20),

              /// 📌 Bottom Buttons (Price and Buy Now)
              const SizedBox(height: 20),

              /// 📌 Buy Now Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the Order Summary Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderSummaryScreen(
                          selectedPlan: isRegularSelected ? 'Regular' : 'Premium Plan', // Pass selected plan
                          selectedPrice: displayedPrice, 
                          finalPrice: displayedPrice, 
                          course: widget.course, // Pass the correct price
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4.0,
                  ),
                  child: const Text(
                    "Buy Now",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPricingTabs() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Regular Plan Tab
          Expanded(
            child: GestureDetector(
              onTap: () => togglePricingTab(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isRegularSelected ? Colors.blue.shade700 : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: isRegularSelected ? Colors.blue.withOpacity(0.4) : Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'Regular',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isRegularSelected ? Colors.white : Colors.blue,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8), // Space between tabs

          /// Premium Plan Tab
          Expanded(
            child: GestureDetector(
              onTap: () => togglePricingTab(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isRegularSelected ? Colors.white : Colors.blue.shade700,
                  gradient: isRegularSelected
                      ? null
                      : LinearGradient(
                          colors: [Colors.blue.shade700, Colors.blue.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.4),
                      blurRadius: 4,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Premium Plan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isRegularSelected ? Colors.blue : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
