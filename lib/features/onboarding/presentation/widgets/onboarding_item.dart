import 'package:flutter/material.dart';
import 'package:nova_ecommerce/core/theme/text_style.dart';

import '../../../../core/helpers/spacing.dart';
import '../../data/models/onboarding_page_model.dart';

class OnboardingItem extends StatelessWidget {
  final OnboardingPageModel page;

  const OnboardingItem({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                page.imagePath,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          verticalSpace(28),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.styleBold48.copyWith(fontSize: 22),
          ),
          verticalSpace(10),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
