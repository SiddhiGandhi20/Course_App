import 'package:course_app/screens/class_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../screens/teacher_dashboard_screen.dart';
import '../screens/courses_screen.dart';
// import '../screens/my_courses_dashboard.dart';
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
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero)
        .animate(
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

  void _handleLogin() {
    Widget nextScreen;
    if (widget.role == "Login as Teacher") {
      nextScreen = TeacherDashboard();
    } else if (widget.role == "Login as Student") {
      nextScreen = ClassSelectionPage();
    } else {
      nextScreen = ParentsDashboardScreen();
    }
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.white70)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or continue with',
            style: TextStyle(color: Colors.white70),
          ),
        ),
        Expanded(child: Divider(color: Colors.white70)),
      ],
    );
  }

 Widget _buildPhoneInput() {
    return _buildAnimatedTextField(
      controller: _phoneController,
      label: 'Phone Number',
      icon: Icons.phone,
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSocialButton(icon: Icons.g_mobiledata, label: 'Google'),
        _buildSocialButton(icon: Icons.apple, label: 'Apple'),
      ],
    );
  }

  Widget _buildSocialButton({required IconData icon, required String label}) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF5C6BC0),
        side: BorderSide(color: Color(0xFF3949AB)),
      ),
      icon: Icon(icon, size: 24),
      label: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFBBDEFB), Color.fromARGB(255, 44, 55, 176)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 120),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            Icon(Icons.school, size: 50, color: Color(0xFF1A237E))
                                .animate()
                                .scale(duration: 1000.ms)
                                .then()
                                .shake(duration: 500.ms),
                            SizedBox(height: 16),
                            Text(
                              'EduConnect',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A237E),
                              ),
                            ).animate().fade(duration: 600.ms).slide(),
                            SizedBox(height: 10),
                            Text(
                              'Welcome Back!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ).animate().fade(duration: 1700.ms).slide(),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      _buildAnimatedTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Icons.person,
                      ).animate().fade(duration: 800.ms).slide(),
                      SizedBox(height: 20),
                      _buildPhoneInput().animate().fade(duration: 900.ms).slide(),
                      SizedBox(height: 32),
                      _buildContinueButton()
                          .animate()
                          .fade(duration: 1000.ms)
                          .slide(),
                      SizedBox(height: 24),
                      _buildDivider().animate().fade(duration: 1100.ms).slide(),
                      SizedBox(height: 24),
                      _buildSocialButtons()
                          .animate()
                          .fade(duration: 1200.ms)
                          .slide(),
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

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF3949AB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Continue',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: Color(0xFF1A237E)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}
