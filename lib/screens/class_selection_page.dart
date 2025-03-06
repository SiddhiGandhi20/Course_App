import 'package:flutter/material.dart';
import '../screens/class_course_page.dart';

class ClassSelectionPage extends StatelessWidget {
  const ClassSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFBBDEFB), Color.fromARGB(255, 97, 110, 255)], // Soft to medium blue
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 120), // Added margin above the text
                const Text(
                  'Select Class',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 255, 255, 255), // Ensuring good contrast
                  ),
                ),
                const SizedBox(height: 30), // Space before cards
                _classSelectionCard(context, '5th Class', Icons.school),
                _classSelectionCard(context, '6th Class', Icons.menu_book),
                _classSelectionCard(context, '7th Class', Icons.cast_for_education),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _classSelectionCard(BuildContext context, String className, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClassCoursesPage(className: className),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3), // Softer glass effect
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 33, 159, 243).withOpacity(0.15), // Soft blue shadow
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(3, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:Color.fromARGB(255, 255, 255, 255).withOpacity(0.3), // Soft blue tint
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 30,
                color: Color(0xFF1A237E), // Darker blue for better visibility
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                className,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 255, 255, 255), // Ensuring clarity
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.blueGrey, size: 18),
          ],
        ),
      ),
    );
  }
}
