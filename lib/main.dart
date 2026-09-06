import 'package:flutter/material.dart';
import 'views/screens.dart'; // تأكد إنك مستورد ملف الشاشات

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // هنا خلينا أول شاشة تفتح هي شاشة الترحيب وتخصيص @LL المذكورة في التصميم
      home: const PersonalizationScreen(),
    );
  }
}