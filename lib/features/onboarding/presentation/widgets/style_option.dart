import 'package:flutter/material.dart';
import 'package:nova_ecommerce/core/theme/text_style.dart';
import '../../data/models/style_option_model.dart';

class StyleOptionCard extends StatelessWidget {
  final StyleOptionModel option;
  final bool isSelected;
  final VoidCallback onTap;

  const StyleOptionCard({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(option.imagePath, fit: BoxFit.cover),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.55)],
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.transparent,
                  width: 3,
                ),
              ),
            ),

            Positioned(
              left: 12,
              bottom: 10,
              child: Text(
                option.label,
                style: AppTextStyles.styleBold48.copyWith(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),

            if (isSelected)
              const Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 11,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.check, size: 14, color: Colors.black),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
