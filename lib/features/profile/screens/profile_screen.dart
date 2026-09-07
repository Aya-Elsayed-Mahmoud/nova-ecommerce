import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../data/repositories/profile_repository.dart';
import '../logic/profile_cubit.dart';
import '../logic/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_section.dart';
import '../widgets/profile_setting_tile.dart';
import 'edit_profile_screen.dart';
import 'privacy_screen.dart';
import 'support_screen.dart';
import 'terms_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    this.repository,
  });

  final ProfileRepository? repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(
        repository ?? ProfileRepository(),
      )..loadProfile()..loadSettings(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: const Icon(
          Icons.menu,
          size: 18,
          color: AppColors.black,
        ),
        title: const Text(
          'NOVA',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 14),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 18,
              color: AppColors.black,
            ),
          ),
        ],
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.errorMessage != null &&
              state.status != ProfileStatus.loading) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ProfileStatus.loading &&
              state.profile == null) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }

          if (state.profile == null) {
            return Center(
              child: TextButton(
                onPressed: context.read<ProfileCubit>().loadProfile,
                child: const Text('Try again'),
              ),
            );
          }

          final profile = state.profile!;
          final settings = state.settings;

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
              children: [
                ProfileHeader(
                  profile: profile,
                  onEdit: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<ProfileCubit>(),
                          child: EditProfileScreen(profile: profile),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                ProfileSection(
                  title: 'App Settings',
                  child: ProfileSettingTile(
                    title: 'Dark Mode',
                    icon: Icons.dark_mode_outlined,
                    trailing: Switch(
                      value: settings?.darkModeEnabled ?? false,
                      onChanged: (_) {
                        // The GET /system/settings contract is read-only
                        // according to the assigned API scope.
                      },
                      materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                ProfileSection(
                  title: 'Info & Support',
                  child: Column(
                    children: [
                      ProfileSettingTile(
                        title: 'Privacy Policy',
                        icon: Icons.privacy_tip_outlined,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PrivacyScreen(
                              content: settings?.privacyPolicy ?? '',
                            ),
                          ),
                        ),
                      ),
                      const Divider(height: 1, indent: 12, endIndent: 12),
                      ProfileSettingTile(
                        title: 'Terms of Service',
                        icon: Icons.description_outlined,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TermsScreen(
                              content: settings?.termsOfService ?? '',
                            ),
                          ),
                        ),
                      ),
                      const Divider(height: 1, indent: 12, endIndent: 12),
                      ProfileSettingTile(
                        title: 'Contact Us',
                        icon: Icons.support_agent_outlined,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SupportScreen(
                              content: settings?.supportContent ?? '',
                              email: settings?.supportEmail ?? '',
                            ),
                          ),
                        ),
                      ),
                      const Divider(height: 1, indent: 12, endIndent: 12),
                      ProfileSettingTile(
                        title: 'About Us',
                        icon: Icons.info_outline,
                        onTap: () => _showAbout(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 46,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Keep logout ownership with the auth feature.
                    },
                    icon: const Icon(Icons.logout, size: 16),
                    label: const Text(
                      'LOGOUT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: .6,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.red,
                      side: const BorderSide(color: AppColors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'App Version 2.4.1',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 8,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'NOVA',
      applicationVersion: '2.4.1',
      applicationIcon: const Icon(
        Icons.shopping_bag_outlined,
        color: AppColors.black,
      ),
    );
  }
}
