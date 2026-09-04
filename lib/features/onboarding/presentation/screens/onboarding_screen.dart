import 'package:flutter/material.dart';
import 'package:nova_ecommerce/core/theme/app_colors.dart';
import '../../../../core/helpers/spacing.dart';
import '../../data/models/onboarding_page_model.dart';
import '../../data/onboarding_repository.dart';
import '../widgets/onboarding_item.dart';
import '../widgets/page_indicator.dart';
import '../../../../core/widgets/primary_button.dart';
import 'preferences_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final OnboardingRepository repository;

  const OnboardingScreen({super.key, required this.repository});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentIndex = 0;

  static const _pages = [
    OnboardingPageModel(
      imagePath: 'assets/images/onboarding_1.jpg',
      title: 'Shopping, but personal.',
      description:
          'Discover products selected around your interests, style, and preferences.',
    ),
    OnboardingPageModel(
      imagePath: 'assets/images/onboarding_2.jpg',
      title: 'Discover what feels like you.',
      description:
          'NOVA learns your style and brings you products you\'ll actually love.',
    ),
    OnboardingPageModel(
      imagePath: 'assets/images/onboarding_3.jpg',
      title: 'Smarter shopping starts here.',
      description: 'Get recommendations that get better every time you shop.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentIndex == _pages.length - 1) {
      _goToPreferences();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToPreferences() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => PreferencesScreen(repository: widget.repository),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentIndex == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextButton(
                  onPressed: _goToPreferences,
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: AppColors.lightGrey),
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) =>
                    OnboardingItem(page: _pages[index]),
              ),
            ),

            verticalSpace(8),
            PageIndicator(
              pageCount: _pages.length,
              currentIndex: _currentIndex,
            ),
            verticalSpace(24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PrimaryButton(
                label: isLastPage ? 'Get Started' : 'Next',
                onPressed: _goToNextPage,
              ),
            ),
            verticalSpace(24),
          ],
        ),
      ),
    );
  }
}
