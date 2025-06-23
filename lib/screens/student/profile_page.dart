import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:homescreeen/providers/profile.dart';
import 'package:homescreeen/providers/theme_provider.dart';
import 'package:homescreeen/screens/login.dart/sign_in.dart';
import 'package:homescreeen/screens/student/change_password_student.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0.9,
      upperBound: 1.0,
    )..repeat(reverse: true);

    scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final size = MediaQuery.of(context).size;
    final double avatarDiameter = size.width * 0.38;
    final double avatarRadius = avatarDiameter / 2;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipPath(
                clipper: CurvedWaveClipper(),
                child: Container(
                  height: size.height * 0.38,
                  decoration: BoxDecoration(
                    gradient: isDark
                        ? const LinearGradient(
                            colors: [Color(0xFF8ECFE4), Color(0xFF111111)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : const LinearGradient(
                            colors: [Color(0xFF8ECFE4), Color(0xFF56A3B3)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: size.height * 0.07),
                      child: Column(
                        children: [
                          Text(
                            profileProvider.name,
                            style: TextStyle(
                              fontSize: size.width * 0.07,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: size.height * 0.008),
                          Text(
                            profileProvider.role,
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Theme toggle icon
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: Icon(
                    themeProvider.isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    themeProvider.toggleTheme(!themeProvider.isDarkMode);
                  },
                ),
              ),
              // Profile image
              Positioned(
                top: size.height * 0.17,
                left: (size.width - avatarDiameter) / 2,
                child: GestureDetector(
                  onTapDown: (_) => controller.reverse(),
                  onTapUp: (_) => controller.forward(),
                  onTapCancel: () => controller.forward(),
                  onTap: profileProvider.pickImage,
                  child: ScaleTransition(
                    scale: scaleAnimation,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              height: avatarDiameter,
                              width: avatarDiameter,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 15,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: avatarRadius,
                          backgroundImage: profileProvider.imageFile != null
                              ? FileImage(profileProvider.imageFile!)
                              : const NetworkImage(
                                      'https://i.pravatar.cc/150?img=5')
                                  as ImageProvider,
                          backgroundColor: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Edit icon
              // Positioned(
              //   top: size.height * 0.12 + avatarDiameter,
              //   left: (size.width + avatarDiameter * 0.53) / 2,
              //   child: FloatingActionButton(
              //     mini: true,
              //     backgroundColor: Color(0xFF8ECFE4),
              //     onPressed: profileProvider.pickImage,
              //     child: const Icon(Icons.edit, size: 20),
              //   ),
              // ),
            ],
          ),
          SizedBox(height: size.height * 0.05),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
              children: [
                neumorphicMenuItem(Icons.lock_outline, 'Change Password', size,
                    onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ChangePasswordScreen(authToken: '')));
                }),
                neumorphicMenuItem(Icons.logout, 'Log Out', size,
                    isLogout: true, onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const SignIn()));
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget neumorphicMenuItem(IconData icon, String title, Size size,
      {bool isLogout = false, VoidCallback? onTap}) {
    final isDark =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final baseColor = isLogout ? Colors.redAccent : Colors.deepPurpleAccent;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.022,
            horizontal: size.width * 0.05,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black54 : Colors.white,
                offset: const Offset(-6, -6),
                blurRadius: 15,
              ),
              BoxShadow(
                color: isDark ? Colors.black26 : Colors.black.withOpacity(0.12),
                offset: const Offset(6, 6),
                blurRadius: 15,
              ),
            ],
          ),
          child: Row(
            children: [
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [baseColor.withOpacity(0.7), baseColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child:
                    Icon(icon, size: size.width * 0.065, color: Colors.white),
              ),
              SizedBox(width: size.width * 0.06),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: size.width * 0.047,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  size: size.width * 0.04, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}

class CurvedWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.75);
    path.cubicTo(size.width * 0.25, size.height, size.width * 0.75,
        size.height * 0.5, size.width, size.height * 0.75);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
