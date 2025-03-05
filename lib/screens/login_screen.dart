import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../screens/class_selection_page.dart';
import '../screens/teacher_dashboard_screen.dart';
import '../screens/parents_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  final String role;

  const LoginScreen({super.key, required this.role});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);
  final String apiUrl = 'http://192.168.29.32:5000/api/register';

  final Map<String, dynamic> requestData = {
    "full_name": _nameController.text.trim(),
    "mobile_number": _phoneController.text.trim(),
    "role": widget.role
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestData),
    );

    print("🔍 Response Status Code: ${response.statusCode}");
    print("🔍 Response Body: ${response.body}");

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      String userId = responseBody["user_id"];

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("userId", userId);
      await prefs.setString("full_name", _nameController.text.trim());
      await prefs.setString("mobile_number", _phoneController.text.trim());
      await prefs.setString("role", widget.role);
      await prefs.setBool("is_logged_in", true);

      print("✅ User ID stored: $userId");

      // Navigate based on role
      if (widget.role == "Teacher") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TeacherDashboard()));
      } else if (widget.role == "Student") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ClassSelectionPage()));
      } else if (widget.role == "Parent") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ParentsDashboardScreen()));
      } else {
        _showErrorDialog("Invalid role. Please try again.");
      }
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _showErrorDialog(responseBody["error"] ?? "Login failed. Please try again.");
    }
  } catch (error) {
    print("❌ Error: $error");
    _showErrorDialog("Failed to connect to server. Please check your network.");
  } finally {
    setState(() => _isLoading = false);
  }
}



  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error", style: TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFBBDEFB), Color(0xFF1A237E)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      _buildLogoHeader(),
                      const SizedBox(height: 40),
                      AnimatedTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Icons.person,
                        validator: (value) =>
                            value == null || value.isEmpty ? "Please enter your full name" : null,
                      ),
                      const SizedBox(height: 20),
                      AnimatedTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your phone number";
                          } else if (!RegExp(r"^\d{10}$").hasMatch(value)) {
                            return "Enter a valid 10-digit number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ContinueButton(onPressed: _handleLogin),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: const [
          Icon(Icons.school, size: 60, color: Colors.white),
          SizedBox(height: 16),
          Text(
            'EduConnect',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Welcome Back!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const AnimatedTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white70),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}

class ContinueButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ContinueButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3949AB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child: const Text(
          'Continue',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
