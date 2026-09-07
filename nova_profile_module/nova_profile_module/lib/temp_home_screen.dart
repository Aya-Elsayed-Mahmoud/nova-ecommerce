// temp_home_screen.dart
// ⚠️ ملف مؤقت للاختبار فقط — احذفه عند دمج الكود مع باقي الفريق.
// الهدف منه إتاحة شريط سفلي بسيط (Bottom Nav) بنفس شكل التصميم المرفق
// (Home / Explore / Wishlist / Profile) عشان تقدر توصل لشاشة الـ Profile
// وتختبرها بمعزل عن باقي شاشات الفريق.

import 'package:flutter/material.dart';
import 'screens/profile_screen.dart';
import 'theme/nova_theme.dart';

class TempHomeScreen extends StatefulWidget {
  const TempHomeScreen({super.key});

  @override
  State<TempHomeScreen> createState() => _TempHomeScreenState();
}

class _TempHomeScreenState extends State<TempHomeScreen> {
  int _currentIndex = 3; // نفتح على تاب الـ Profile مباشرة للاختبار

  final List<Widget> _tabs = const [
    _PlaceholderTab(label: 'Home'),
    _PlaceholderTab(label: 'Explore'),
    _PlaceholderTab(label: 'Wishlist'),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: NovaColors.background,
        selectedItemColor: NovaColors.primaryText,
        unselectedItemColor: NovaColors.secondaryText,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String label;
  const _PlaceholderTab({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NovaColors.background,
      body: Center(
        child: Text(
          '$label — من مسؤولية باقي الفريق',
          style: const TextStyle(color: NovaColors.secondaryText),
        ),
      ),
    );
  }
}
