// profile_screen.dart
// الشاشة الرئيسية للـ Profile: تعرض بيانات المستخدم + Settings + Logout
// طبقاً للتصميم المرفق (NOVA theme)

import 'package:flutter/material.dart';
import '../models/user_profile_model.dart';
import '../models/system_settings_model.dart';
import '../services/profile_api_service.dart';
import '../services/token_storage.dart';
import '../theme/nova_theme.dart';
import 'edit_profile_screen.dart';
import 'static_settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileApiService _apiService = ProfileApiService();

  UserProfileModel? _profile;
  bool _isLoading = true;
  String? _errorMessage;
  bool _darkModeSwitch = false; // مجرد مؤشر محلي شكلي كما في التصميم

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final profile = await _apiService.getProfile();
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ غير متوقع';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NovaRadius.card),
        ),
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'خروج',
              style: TextStyle(color: NovaColors.logoutRed),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await TokenStorage.clearToken();
      if (!mounted) return;
      // عدّل هذا السطر عند الدمج مع الفريق ليوجه للـ LoginScreen الحقيقية
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تسجيل الخروج بنجاح')),
      );
    }
  }

  void _navigateToEditProfile() async {
    if (_profile == null) return;
    final updated = await Navigator.push<UserProfileModel>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(currentProfile: _profile!),
      ),
    );
    if (updated != null) {
      setState(() => _profile = updated);
    }
  }

  void _navigateToStaticPage(StaticPageType type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StaticSettingsScreen(pageType: type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NovaColors.background,
      appBar: AppBar(
        title: const Text('NOVA'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: NovaColors.secondaryText),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProfile,
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProfile,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          _buildSectionCard(
            title: 'APP SETTINGS',
            children: [
              _buildSwitchTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                value: _darkModeSwitch,
                onChanged: (v) => setState(() => _darkModeSwitch = v),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSectionCard(
            title: 'INFO & SUPPORT',
            children: [
              _buildNavTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () => _navigateToStaticPage(StaticPageType.privacyPolicy),
              ),
              _buildDivider(),
              _buildNavTile(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                onTap: () => _navigateToStaticPage(StaticPageType.termsOfService),
              ),
              _buildDivider(),
              _buildNavTile(
                icon: Icons.support_agent_outlined,
                title: 'Contact Us',
                onTap: () => _navigateToStaticPage(StaticPageType.support),
              ),
              _buildDivider(),
              _buildNavTile(
                icon: Icons.info_outline,
                title: 'About Us',
                onTap: () => _navigateToStaticPage(StaticPageType.aboutUs),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildLogoutButton(),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'App Version 2.4.1',
              style: TextStyle(color: NovaColors.secondaryText, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: NovaColors.cardBackground,
              backgroundImage: (_profile?.profileImageUrl != null)
                  ? NetworkImage(_profile!.profileImageUrl!)
                  : null,
              child: (_profile?.profileImageUrl == null)
                  ? const Icon(Icons.person, size: 44, color: NovaColors.secondaryText)
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(_profile?.fullName ?? '-', style: NovaTextStyles.userName),
        const SizedBox(height: 4),
        Text(_profile?.email ?? '-', style: NovaTextStyles.userEmail),
        if (_profile?.isPremium == true) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: NovaColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.workspace_premium_outlined, size: 14, color: NovaColors.primaryText),
                SizedBox(width: 4),
                Text('Premium Member', style: TextStyle(fontSize: 12, color: NovaColors.primaryText)),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: _navigateToEditProfile,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(NovaRadius.button),
            ),
            side: const BorderSide(color: NovaColors.divider),
          ),
          child: const Text('Edit Profile', style: TextStyle(color: NovaColors.primaryText)),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: NovaTextStyles.sectionHeader),
        ),
        Container(
          decoration: BoxDecoration(
            color: NovaColors.cardBackground,
            borderRadius: BorderRadius.circular(NovaRadius.card),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: NovaColors.iconColor),
      title: Text(title, style: NovaTextStyles.listItem),
      trailing: Switch(value: value, onChanged: onChanged, activeColor: NovaColors.primaryText),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: NovaColors.iconColor),
      title: Text(title, style: NovaTextStyles.listItem),
      trailing: const Icon(Icons.chevron_right, color: NovaColors.secondaryText, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 16, endIndent: 16, color: NovaColors.divider);
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: _handleLogout,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NovaRadius.button),
          ),
          side: const BorderSide(color: NovaColors.logoutRed),
        ),
        icon: const Icon(Icons.logout, color: NovaColors.logoutRed, size: 18),
        label: const Text(
          'LOGOUT',
          style: TextStyle(color: NovaColors.logoutRed, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
