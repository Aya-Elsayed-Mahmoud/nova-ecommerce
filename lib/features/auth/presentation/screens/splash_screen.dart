import 'package:flutter/material.dart';

import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // loading bar

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controller.forward().then((_) {
      if (!mounted) {
        return;
      } //end
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()),);
    });

    Future.delayed(const Duration(seconds: 3), () {});
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
              ?Colors.indigo[900],
              ?Colors.indigo[900],
              Colors.black,
            ],
          ),
        ),

        child: Container(
          color: Color(0x80888B95),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return SizedBox(
                    width: 131,
                    child: LinearProgressIndicator(
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
              SizedBox(height: 3),
              Text(
                "NOVA",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
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
