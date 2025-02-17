import 'package:flutter/material.dart';
import '../widgets/parent_dashboard_header.dart';
import '../widgets/recent_activites.dart';
import '../widgets/child_class.dart';
import '../widgets/attendance_overview.dart';
// import '../widgets/bottom_nav_bar.dart';

class ParentsDashboardScreen extends StatelessWidget {
  const ParentsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const ParentDashboardHeader(),
                  const SizedBox(height: 20),
                  const RecentActivities(),
                  const SizedBox(height: 24),
                  const ChildClasses(),
                  const SizedBox(height: 24),
                  const AttendanceOverview(),
                ],
              ),
            ),
            // const BottomNavBar(),
          ],
        ),
      ),
    );
  }
}
