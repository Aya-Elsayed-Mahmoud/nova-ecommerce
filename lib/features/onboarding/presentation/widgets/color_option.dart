import 'package:flutter/material.dart';

import '../../data/models/color_option_model.dart';

class ColorOptionSwatch extends StatelessWidget {
  final ColorOptionModel option;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorOptionSwatch({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLightColor = option.color.computeLuminance() > 0.6;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: option.color,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 2.5 : 1,
          ),
        ),
        child: isSelected
            ? Icon(
                Icons.check,
                size: 24,
                color: isLightColor ? Colors.black : Colors.white,
              )
            : null,
      ),
    );
  }
}
