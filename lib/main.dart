import 'package:flutter/material.dart';
import 'package:homescreeen/providers/change_password.dart';
import 'package:homescreeen/providers/profile.dart';
import 'package:homescreeen/providers/theme_provider.dart';
import 'package:homescreeen/screens/onboarding_screen.dart';
import 'package:homescreeen/servies/category_service.dart';
import 'package:homescreeen/servies/student_service.dart';
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
          ChangeNotifierProvider(create: (_) => CategoryCountProvider()),
          ChangeNotifierProvider(create: (_) => BlockProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
          ChangeNotifierProvider(create: (_) => StudentProfileProvider()),
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
      home: const OnboardingScreen(), // Starting screen
    );
  }
}
