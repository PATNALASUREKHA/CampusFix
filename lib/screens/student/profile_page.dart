import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Profile',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white, size: 40),
          ),
          SizedBox(height: 20),
          Text('Name: Student Name', style: TextStyle(color: Colors.white)),
          Text('Email: student@example.com',
              style: TextStyle(color: Colors.white)),
          Text('Mobile: +91 9876543210', style: TextStyle(color: Colors.white)),
          SizedBox(height: 10),
          Divider(color: Colors.white38),
          Text('Course: B.Tech', style: TextStyle(color: Colors.white)),
          Text('Branch: CSE', style: TextStyle(color: Colors.white)),
          Text('Roll No: 123456', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
