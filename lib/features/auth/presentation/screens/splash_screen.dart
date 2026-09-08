import 'package:flutter/material.dart';

import '../../../home/screens/MainScreens.dart';
import '../../../onboarding/presentation/screens/personalization_ready_screen.dart';
import '../../../profile/services/token_storage.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // 🚀 عند انتهاء الأنيميشن، يتم فحص التوكن للتوجيه المباشر
    _controller.forward().then((_) {
      if (!mounted) return;
      _checkAuthStatus();
    });
  }

  Future<void> _checkAuthStatus() async {
    // 🔍 فحص وجود التوكين في FlutterSecureStorage
    final String? token = await TokenStorage.getToken();

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      // 🔓 التوكن موجود -> الانتقال للتطبيق مباشرة
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const PersonalizationScreen(),
        ),
      );
    } else {
      // 🔒 التوكن غير موجود -> الانتقال لصفحة تسجيل الدخول
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black,
              Colors.indigo[900]!,
              Colors.indigo[900]!,
              Colors.black,
            ],
          ),
        ),
        child: Container(
          color: const Color(0x80888B95),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return SizedBox(
                    width: 131,
                    child: LinearProgressIndicator(
                      value: _controller.value,
                      minHeight: 1.5,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.white70,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.black,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 3),
              const Text(
                "NOVA",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Your world. Curated for you.",
                style: TextStyle(fontSize: 18, color: Colors.grey[800]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}