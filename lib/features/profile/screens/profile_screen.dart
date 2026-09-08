// profile_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nova_ecommerce/features/auth/presentation/screens/login_page.dart';
import 'package:nova_ecommerce/features/home/screens/MainScreens.dart';
import '../../../core/theme/app_theme.dart';
import '../../cart/cartScreen.dart';
import '../models/user_profile_model.dart';
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
        _errorMessage = 'Error loading profile';
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
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: NovaColors.logoutRed),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final token = await TokenStorage.getToken();
        final url = Uri.parse('https://accessories-eshop.runasp.net/api/auth/logout');
        await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        );
      } catch (_) {
      } finally {
        await TokenStorage.clearToken();
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
          );
        }
      }
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
      MaterialPageRoute(builder: (_) => StaticSettingsScreen(pageType: type)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('NOVA',style: TextStyle(
          color: theme.textTheme.bodyLarge?.color,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          fontSize: 18,
        ),),
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {
          Scaffold.of(context).openDrawer();
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
            },
          ),
        ],
      ),
      body: SafeArea(child: _buildBody(theme)),
    );
  }

  Widget _buildBody(ThemeData theme) {
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
                style: TextStyle(color: theme.hintColor),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProfile,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeNotifier,
      builder: (context, currentMode, _) {
        final isDarkMode = currentMode == ThemeMode.dark;

        return RefreshIndicator(
          onRefresh: _loadProfile,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              _buildProfileHeader(theme),
              const SizedBox(height: 24),
              _buildSectionCard(
                theme: theme,
                title: 'APP SETTINGS',
                children: [
                  _buildSwitchTile(
                    theme: theme,
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    value: isDarkMode,
                    onChanged: (bool value) {
                      AppTheme.toggleTheme(value);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionCard(
                theme: theme,
                title: 'INFO & SUPPORT',
                children: [
                  _buildNavTile(
                    theme: theme,
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    onTap: () => _navigateToStaticPage(StaticPageType.termsAndConditions),
                  ),
                  _buildDivider(theme),
                  _buildNavTile(
                    theme: theme,
                    icon: Icons.support_agent_outlined,
                    title: 'Support & Help',
                    onTap: () => _navigateToStaticPage(StaticPageType.support),
                  ),
                  _buildDivider(theme),
                  _buildNavTile(
                    theme: theme,
                    icon: Icons.info_outline,
                    title: 'About Us',
                    onTap: () => _navigateToStaticPage(StaticPageType.aboutUs),
                  ),
                  _buildDivider(theme),
                  _buildNavTile(
                    theme: theme,
                    icon: Icons.contact_support_outlined,
                    title: 'Contact Us',
                    onTap: () => _navigateToStaticPage(StaticPageType.contactUs),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildLogoutButton(),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'App Version 2.4.1',
                  style: TextStyle(color: theme.hintColor, fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Column(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: theme.cardColor,
          backgroundImage: (_profile?.profileImageUrl != null)
              ? NetworkImage(_profile!.profileImageUrl!)
              : null,
          child: (_profile?.profileImageUrl == null)
              ? Icon(
            Icons.person,
            size: 44,
            color: theme.hintColor,
          )
              : null,
        ),
        const SizedBox(height: 12),
        Text(
          _profile?.fullName ?? '-',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
        ),
        const SizedBox(height: 4),
        Text(
          _profile?.email ?? '-',
          style: TextStyle(color: theme.hintColor, fontSize: 14),
        ),
        if (_profile?.isPremium == true) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.workspace_premium_outlined,
                  size: 14,
                  color: textColor,
                ),
                const SizedBox(width: 4),
                Text(
                  'Premium Member',
                  style: TextStyle(fontSize: 12, color: textColor),
                ),
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
            side: BorderSide(color: theme.dividerColor),
          ),
          child: Text(
            'Edit Profile',
            style: TextStyle(color: textColor),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required ThemeData theme,
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: theme.hintColor,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(NovaRadius.card),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: theme.iconTheme.color),
      title: Text(
        title,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildNavTile({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: theme.iconTheme.color),
      title: Text(
        title,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.hintColor,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: theme.dividerColor,
    );
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
          style: TextStyle(
            color: NovaColors.logoutRed,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}