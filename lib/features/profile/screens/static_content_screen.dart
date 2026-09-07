import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class StaticContentScreen extends StatelessWidget {
  const StaticContentScreen({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 17,
            color: AppColors.black,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              content.trim().isEmpty
                  ? 'Content is currently unavailable.'
                  : content,
              style: const TextStyle(
                color: AppColors.darkGrey,
                fontSize: 13,
                height: 1.65,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
