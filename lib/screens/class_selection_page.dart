import 'package:flutter/material.dart';
import '../screens/class_course_page.dart';

class ClassSelectionPage extends StatelessWidget {
  const ClassSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Class',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _classSelectionCard(
              context,
              '5th Class',
              Icons.class_,
            ),
            _classSelectionCard(
              context,
              '6th Class',
              Icons.class_,
            ),
            _classSelectionCard(
              context,
              '7th Class',
              Icons.class_,
            ),
          ],
        ),
      ),
    );
  }

  Widget _classSelectionCard(BuildContext context, String className, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        onTap: () {
          // Navigate to ClassCoursesPage with the selected class
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClassCoursesPage(className: className),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 30,
                color: Colors.blueAccent,
              ),
              SizedBox(width: 16.0),
              Text(
                className,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
