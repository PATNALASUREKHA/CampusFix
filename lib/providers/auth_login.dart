import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  // Hardcoded credentials
  final String _adminEmail = 'admin@example.com';
  final String _adminPassword = 'admin123';
  final String _studentEmail = 'student@example.com';
  final String _studentPassword = 'student123';

  bool login(String email, String password) {
    return (email == _adminEmail && password == _adminPassword) ||
        (email == _studentEmail && password == _studentPassword);
  }
}
