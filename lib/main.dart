import 'package:flutter/material.dart';
import 'package:homescreeen/providers/auth_login.dart';
import 'package:homescreeen/providers/change_password.dart';
import 'package:homescreeen/providers/profile.dart';
import 'package:homescreeen/providers/theme_provider.dart';
import 'package:homescreeen/screens/login.dart/sign_in.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:homescreeen/providers/block_provider.dart';
// Later navigation

void main() {
  runApp(
    DevicePreview(
      enabled: true, // Disable in production
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => BlockProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: DevicePreview.appBuilder,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      title: 'Campus Fix',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const SignIn(), // Starting screen
    );
  }
}
