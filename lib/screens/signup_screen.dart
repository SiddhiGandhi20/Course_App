import 'package:flutter/material.dart';
import '../styles/signup.dart'; // Import styles
import '../widgets/custom_widgets.dart'; // Import widgets
import '../screens/courses_screen.dart';
import '../screens/teacher_dashboard_screen.dart'; // Import Teacher Dashboard screen

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? selectedRole;
  bool termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double maxWidth = constraints.maxWidth > 600 ? 500 : double.infinity; // Limit width for web

              return SizedBox(
                width: maxWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // ✅ Center align content
                  children: [
                    const SizedBox(height: 24),

                    // 🏷️ Title
                    const Text(
                      'Join LearnApp',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create your account and start learning today',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 16),

                    // 🌆 Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/main.jpeg',
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 👥 Choose Role
                    const Text(
                      'Choose your role',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),

                    // 🏫 Teacher Role Option
                    buildRoleOption(
                      icon: Icons.school,
                      title: 'Teacher',
                      subtitle: 'Create classes and manage',
                      value: 'teacher',
                      selectedRole: selectedRole,
                      onTap: (role) => setState(() => selectedRole = role),
                    ),

                    // 🎓 Student Role Option
                    buildRoleOption(
                      icon: Icons.person,
                      title: 'Student',
                      subtitle: 'Join classes and access materials',
                      value: 'student',
                      selectedRole: selectedRole,
                      onTap: (role) => setState(() => selectedRole = role),
                    ),

                    // 👨‍👩‍👧 Parent Role Option
                    buildRoleOption(
                      icon: Icons.family_restroom,
                      title: 'Parent',
                      subtitle: "Monitor your child's progress",
                      value: 'parent',
                      selectedRole: selectedRole,
                      onTap: (role) => setState(() => selectedRole = role),
                    ),

                    const SizedBox(height: 24),

                    // 📌 Input Fields
                    buildInputField('Full Name'),
                    const SizedBox(height: 16),
                    buildInputField('Mobile Number'),
                    const SizedBox(height: 16),

                    // ✅ Terms & Conditions
                    Row(
                      children: [
                        Checkbox(
                          value: termsAccepted,
                          onChanged: (value) => setState(() => termsAccepted = value ?? false),
                        ),
                        const Expanded(
                          child: Text(
                            'I agree to the Terms of Service and Privacy Policy',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 🔵 Create Account Button
                    ElevatedButton(
                      onPressed: () {
                        if (selectedRole == 'teacher') {
                          // ✅ Navigate to Teacher Dashboard
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TeacherDashboard()),
                          );
                        } else {
                          // ✅ Navigate to Courses Screen for other roles
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CoursesScreen()),
                          );
                        }
                      },
                      style: elevatedButtonStyle, // ✅ Reused style
                      child: const Text('Create Account'),
                    ),
                    const SizedBox(height: 12),

                    // 🔗 Divider with Text
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Or continue with'),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 🌍 Social Login Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildSocialButton(Icons.g_mobiledata, 'Google'),
                        const SizedBox(width: 16),
                        buildSocialButton(Icons.apple, 'Apple'),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ⏩ Sign In & Help
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(foregroundColor: Colors.black),
                        child: const Text('Already have an account? Sign in'),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(foregroundColor: Colors.black),
                        child: const Text('Need help? Contact support'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
