// static_settings_screen.dart
// شاشة ذكية واحدة تُستخدم لعرض Privacy Policy / Terms / Support / About Us
// حسب الـ pageType اللي بيتبعت لها، والمحتوى بييجي ديناميكياً من
// GET /system/settings?type=...

import 'package:flutter/material.dart';
import '../models/system_settings_model.dart';
import '../services/profile_api_service.dart';
import '../theme/nova_theme.dart';

class StaticSettingsScreen extends StatefulWidget {
  final StaticPageType pageType;
  const StaticSettingsScreen({super.key, required this.pageType});

  @override
  State<StaticSettingsScreen> createState() => _StaticSettingsScreenState();
}

class _StaticSettingsScreenState extends State<StaticSettingsScreen> {
  final ProfileApiService _apiService = ProfileApiService();

  SystemSettingsModel? _settings;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _apiService.getSystemSettings(widget.pageType.apiValue);
      setState(() {
        _settings = result;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'تعذر تحميل المحتوى';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NovaColors.background,
      appBar: AppBar(
        title: Text(
          widget.pageType.displayTitle,
          style: const TextStyle(color: NovaColors.primaryText, fontSize: 18),
        ),
      ),
      body: SafeArea(child: _buildBody()),
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
              const Icon(Icons.error_outline, color: NovaColors.secondaryText, size: 40),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: NovaColors.secondaryText),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadContent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: NovaColors.primaryText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(NovaRadius.button),
                  ),
                ),
                child: const Text('إعادة المحاولة', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadContent,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: NovaColors.cardBackground,
              borderRadius: BorderRadius.circular(NovaRadius.card),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _settings?.title ?? widget.pageType.displayTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: NovaColors.primaryText,
                  ),
                ),
                if (_settings?.lastUpdated != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'آخر تحديث: ${_settings!.lastUpdated}',
                    style: const TextStyle(fontSize: 12, color: NovaColors.secondaryText),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  _settings?.content ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: NovaColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
