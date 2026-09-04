import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/color_option_model.dart';
import 'models/style_option_model.dart';

class OnboardingRepository {
  static const _onboardingCompletedKey = 'onboarding_completed';

  final SharedPreferences _prefs;

  OnboardingRepository(this._prefs);

  bool hasCompletedOnboarding() {
    return _prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(_onboardingCompletedKey, true);
  }

  Future<List<StyleOptionModel>> fetchStyleOptions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      StyleOptionModel(
        id: 'minimalist',
        label: 'Minimalist',
        imagePath: 'assets/images/style_minimalist.jpg',
      ),
      StyleOptionModel(
        id: 'streetwear',
        label: 'Streetwear',
        imagePath: 'assets/images/style_streetwear.jpg',
      ),
      StyleOptionModel(
        id: 'classic',
        label: 'Classic',
        imagePath: 'assets/images/style_classic.jpg',
      ),
      StyleOptionModel(
        id: 'bold',
        label: 'Bold',
        imagePath: 'assets/images/style_bold.jpg',
      ),
    ];
  }

  Future<List<ColorOptionModel>> fetchColorOptions() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return const [
      // Neutrals
      ColorOptionModel(
        id: 'black',
        color: Color(0xFF1A1A1A),
        groupLabel: 'Neutrals',
      ),
      ColorOptionModel(
        id: 'white',
        color: Color(0xFFFFFFFF),
        groupLabel: 'Neutrals',
      ),
      ColorOptionModel(
        id: 'grey',
        color: Color(0xFF8C8C8C),
        groupLabel: 'Neutrals',
      ),
      ColorOptionModel(
        id: 'lightGrey',
        color: Color(0xFFD9D9D9),
        groupLabel: 'Neutrals',
      ),

      // Earth & Jewel
      ColorOptionModel(
        id: 'brown',
        color: Color(0xFF5A3E2B),
        groupLabel: 'Earth & Jewel',
      ),
      ColorOptionModel(
        id: 'green',
        color: Color(0xFF2F5233),
        groupLabel: 'Earth & Jewel',
      ),
      ColorOptionModel(
        id: 'maroon',
        color: Color(0xFF6E1E2C),
        groupLabel: 'Earth & Jewel',
      ),
      ColorOptionModel(
        id: 'navy',
        color: Color(0xFF16296B),
        groupLabel: 'Earth & Jewel',
      ),

      // Soft Tones
      ColorOptionModel(
        id: 'blush',
        color: Color(0xFFE3B7AE),
        groupLabel: 'Soft Tones',
      ),
      ColorOptionModel(
        id: 'skyBlue',
        color: Color(0xFFB7CDE0),
        groupLabel: 'Soft Tones',
      ),
      ColorOptionModel(
        id: 'sage',
        color: Color(0xFFCBD3B0),
        groupLabel: 'Soft Tones',
      ),
      ColorOptionModel(
        id: 'tan',
        color: Color(0xFFE0C7A6),
        groupLabel: 'Soft Tones',
      ),
    ];
  }

  Future<void> savePreferences({
    required String? styleId,
    required List<String> colorIds,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }
}
