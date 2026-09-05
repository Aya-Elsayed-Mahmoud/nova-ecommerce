import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';

void main() {
  runApp( NovaApp());
}

class NovaApp extends StatelessWidget {
  NovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nova E-Commerce',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ForgotPasswordScreen(),
    );
  }
}