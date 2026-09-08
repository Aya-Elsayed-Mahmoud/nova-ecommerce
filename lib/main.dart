import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/onboarding/data/onboarding_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  await AppTheme.initTheme(prefs);

  final onboardingRepository = OnboardingRepository(prefs);

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => NovaApp(onboardingRepository: onboardingRepository),
    ),
  );
}

class NovaApp extends StatelessWidget {
  final OnboardingRepository onboardingRepository;

  const NovaApp({super.key, required this.onboardingRepository});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'NOVA',
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          themeMode: currentMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const SplashScreen(),
        );
      },
    );
  }
}