import 'package:flutter/material.dart';
import 'package:homescreeen/screens/home_screen.dart';
import 'package:homescreeen/screens/login/forgot_password.dart';
import 'package:homescreeen/servies/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../student/student_home_screen.dart';
import 'package:lottie/lottie.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _rollNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isLoading = false;

  String? _validateRollNo(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your roll number';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    return null;
  }

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final rollNo = _rollNoController.text.trim();
      final password = _passwordController.text.trim();

      final userData = await LoginService.loginUser(rollNo, password);

      setState(() => _isLoading = false);

      if (userData != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', userData['name'] ?? '');
        await prefs.setString('rollNo', userData['roll_no'] ?? '');
        await prefs.setString('blockNo', userData['hostel_block'] ?? '');
        await prefs.setString('roomNo', userData['room_no'] ?? '');
        await prefs.setString('mobileNo', userData['mobile'].toString());
        await prefs.setString('profileImage', userData['profile_image'] ?? '');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );

        if (rollNo == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const StudentHomeScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid roll number or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFC562AF); // Pinkish purple
    const Color secondaryColor = Color(0xFFFEC5F6); // Light pastel pink
    const Color darkText = Color(0xFF3D3D3D);

    return Scaffold(
      backgroundColor: secondaryColor,
      body: Column(
        children: [
          /// Top Section with Animation
          Container(
            height: 260,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFDB8DD0),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Lottie.asset(
                'assets/login_animation.json',
                height: 200,
              ),
            ),
          ),

          /// Login Form Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please login in to continue',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 24),

                    /// Roll Number Field
                    TextFormField(
                      controller: _rollNoController,
                      decoration: InputDecoration(
                        labelText: 'Roll Number',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: _validateRollNo,
                    ),
                    const SizedBox(height: 16),

                    /// Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () =>
                              setState(() => _obscureText = !_obscureText),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: _validatePassword,
                    ),

                    /// Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => ForgotPasswordModal(),
                          );
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
