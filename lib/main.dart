import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'providers/goal_provider.dart';
import 'providers/test_provider.dart'; // Import TestProvider

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/teacher_dashboard_screen.dart';
import 'screens/class_selection_page.dart';
import 'screens/parents_dashboard_screen.dart';
// import 'screens/tests_screen.dart'; // Uncomment if TestsScreen is available

// ✅ Global ScaffoldMessenger Key (Fixes SnackBar Issues)
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CourseProvider()),
        ChangeNotifierProvider(create: (context) => GoalProvider()),
        ChangeNotifierProvider(create: (context) => TestProvider()), // Added TestProvider
      ],
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey, // ✅ Assigned Global Key
        debugShowCheckedModeBanner: false, // ✅ Removes Debug Banner
        title: 'EduConnect',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(role: ""),
          '/teacher_dashboard': (context) => const TeacherDashboard(),
          '/class_selection': (context) => const ClassSelectionPage(),
          '/parent_dashboard': (context) => const ParentsDashboardScreen(),
          // '/tests': (context) => const TestsScreen(), // Uncomment if TestsScreen exists
        },
      ),
    );
  }
}
