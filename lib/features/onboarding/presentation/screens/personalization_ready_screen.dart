import 'package:flutter/material.dart';
import 'package:nova_ecommerce/core/theme/app_colors.dart';
import 'package:nova_ecommerce/core/theme/text_style.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../home/screens/MainScreens.dart';

class PersonalizationScreen extends StatelessWidget {
  const PersonalizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              verticalSpace(12),
              Text(
                'Your NOVA is ready ✨',
                style: AppTextStyles.styleBold48.copyWith(fontSize: 22),
              ),
              verticalSpace(8),
              Text(
                "We've created a shopping experience around your style.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.lightGrey),
              ),
              verticalSpace(24),

              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          'assets/images/preview_style.jpg',
                          fit: BoxFit.cover,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    herizontalSpace(12),
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          'assets/images/preview_colors.jpg',
                          fit: BoxFit.cover,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              verticalSpace(24),
              PrimaryButton(
                label: 'Enter NOVA',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainLayout()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
