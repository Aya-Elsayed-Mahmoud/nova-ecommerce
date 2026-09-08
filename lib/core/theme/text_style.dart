import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nova_ecommerce/core/theme/font_weight_helper.dart';

import 'app_colors.dart';

class AppTextStyles {
  static final TextStyle styleBold48 = GoogleFonts.hankenGrotesk(
    fontSize: 48,
    fontWeight: FontWeightHelper.bold,
    color: AppColors.black,
  );
  static final TextStyle styleSemiBold24 = GoogleFonts.hankenGrotesk(
    fontSize: 24,
    fontWeight: FontWeightHelper.semiBold,
    color: AppColors.white,
  );

  static final TextStyle styleRegular18 = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeightHelper.regular,
    color: AppColors.lightGrey,
  );
  static final TextStyle styleSemiBold12 = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeightHelper.semiBold,
    color: AppColors.black,
  );
}
