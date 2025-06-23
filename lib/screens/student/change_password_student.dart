import 'package:flutter/material.dart';
import 'package:homescreeen/providers/change_password.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String authToken;

  const ChangePasswordScreen({super.key, required this.authToken});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isCurrentVisible = false;
  bool isNewVisible = false;
  bool isConfirmVisible = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Widget buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    required bool isVisible,
    required VoidCallback toggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: toggleVisibility,
        ),
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Future<void> _handleChangePassword(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final provider =
        Provider.of<ChangePasswordProvider>(context, listen: false);

    final error = await provider.changePassword(
      currentPassword: currentPasswordController.text,
      newPassword: newPasswordController.text,
      authToken: widget.authToken,
    );

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully!')),
      );
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<ChangePasswordProvider>(context).isLoading;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text('Change Password'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                buildPasswordField(
                  controller: currentPasswordController,
                  label: 'Current Password',
                  icon: Icons.lock_outline,
                  isVisible: isCurrentVisible,
                  toggleVisibility: () {
                    setState(() {
                      isCurrentVisible = !isCurrentVisible;
                    });
                  },
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter current password' : null,
                ),
                const SizedBox(height: 16),
                buildPasswordField(
                  controller: newPasswordController,
                  label: 'New Password',
                  icon: Icons.lock_open,
                  isVisible: isNewVisible,
                  toggleVisibility: () {
                    setState(() {
                      isNewVisible = !isNewVisible;
                    });
                  },
                  validator: (value) => value!.length < 6
                      ? 'Password must be at least 6 characters'
                      : null,
                ),
                const SizedBox(height: 16),
                buildPasswordField(
                  controller: confirmPasswordController,
                  label: 'Confirm New Password',
                  icon: Icons.check,
                  isVisible: isConfirmVisible,
                  toggleVisibility: () {
                    setState(() {
                      isConfirmVisible = !isConfirmVisible;
                    });
                  },
                  validator: (value) => value != newPasswordController.text
                      ? 'Passwords do not match'
                      : null,
                ),
                const SizedBox(height: 30),
                isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _handleChangePassword(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Change Password'),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
