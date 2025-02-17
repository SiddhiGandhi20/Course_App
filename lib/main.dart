import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'providers/course_provider.dart'; 
import 'providers/goal_provider.dart';
// Import CourseProvider
// import 'screens/signup_screen.dart'; // Import SignUpScreen
import 'screens/splash_screen.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => GoalProvider()), // ✅ Add GoalProvider
 // ✅ Provide CourseProvider globally
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduConnect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: SplashScreen(), // ✅ Ensure SignUpScreen has access to the provider
    );
  }
}
