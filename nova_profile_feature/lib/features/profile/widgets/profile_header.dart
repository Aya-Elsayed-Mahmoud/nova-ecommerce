import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../data/models/user_profile_model.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.profile,
    required this.onEdit,
  });

  final UserProfileModel profile;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 41,
              backgroundColor: AppColors.primaryBackground,
              backgroundImage: profile.imageUrl == null
                  ? null
                  : NetworkImage(profile.imageUrl!),
              child: profile.imageUrl == null
                  ? const Icon(
                      Icons.person_outline,
                      size: 40,
                      color: AppColors.darkGrey,
                    )
                  : null,
            ),
            Material(
              color: AppColors.black,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onEdit,
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 14,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          profile.name.isEmpty ? 'User' : profile.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          profile.email,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.lightGrey,
            fontSize: 11,
          ),
        ),
        if (profile.isPremium) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Premium Member',
              style: TextStyle(
                color: AppColors.lightGrey,
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
