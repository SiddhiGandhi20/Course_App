import 'package:flutter/material.dart';

class ParentDashboardHeader extends StatelessWidget {
  const ParentDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Hello, Mr. Johnson',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Parent Dashboard',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const Spacer(),
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage('https://placeholder.com/parent.jpg'),
        ),
      ],
    );
  }
}
