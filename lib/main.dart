import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/onboarding/data/onboarding_repository.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final onboardingRepository = OnboardingRepository(prefs);

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) =>
          NovaApp(
            onboardingRepository: onboardingRepository,
          ),
    ),
  );
}

class NovaApp extends StatelessWidget {
  final OnboardingRepository onboardingRepository;

  const NovaApp({
    super.key,
    required this.onboardingRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NOVA',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
        ),
      ),

      home: OnboardingScreen(
        repository: onboardingRepository,
      ),
    );
  }
}
