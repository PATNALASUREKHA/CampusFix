import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/issue_provider.dart';
import 'profile_page.dart';
import 'notify_page.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<String> categories = [
    'Electricity',
    'Plumber',
    'Food',
    'Furniture',
    'WiFi',
    'Other'
  ];
  String? selectedCategory;
  File? _pickedImage;

  int _selectedIndex = 0;

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  Widget _buildHomePage(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 60, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              getGreeting(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2E1A64),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      dropdownColor: Colors.deepPurple,
                      value: selectedCategory,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white38),
                        ),
                      ),
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category,
                              style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                      validator: (val) =>
                          val == null ? 'Please select a category' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Problem Description',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white38),
                        ),
                      ),
                      validator: (val) => val!.length < 10
                          ? 'Please enter at least 10 characters'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Upload Image'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                          ),
                        ),
                        const SizedBox(width: 10),
                        _pickedImage != null
                            ? const Text("✅ Image selected",
                                style: TextStyle(color: Colors.white70))
                            : const Text("No image selected",
                                style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Provider.of<IssueProvider>(context, listen: false)
                              .submitIssue(
                            // Replace with actual selected block if needed
                            roomNumber: roomController.text.trim(),

                            description: descriptionController.text.trim(),
                          );

                          roomController.clear();
                          descriptionController.clear();
                          selectedCategory = null;
                          setState(() => _pickedImage = null);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('✅ Issue Submitted')),
                          );
                        }
                      },
                      child: const Text('Submit'),
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

  @override
  Widget build(BuildContext context) {
    Widget currentScreen;
    if (_selectedIndex == 0) {
      currentScreen = _buildHomePage(context);
    } else if (_selectedIndex == 1) {
      currentScreen = const NotificationPage();
    } else {
      currentScreen = const ProfileScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1B1444),
      body: currentScreen,
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF2E1A64),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none,
                          color: Colors.white),
                      onPressed: () => setState(() => _selectedIndex = 1),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.group_outlined, color: Colors.white),
                      onPressed: () => setState(() => _selectedIndex = 2),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: const Offset(0, -25),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 0),
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.pinkAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Icon(Icons.home_outlined, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
