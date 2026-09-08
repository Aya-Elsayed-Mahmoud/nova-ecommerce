import 'package:flutter/material.dart';

enum StaticPageType {
  contactUs('Contact Us'),
  termsAndConditions('Terms & Conditions'),
  aboutUs('About Us'),
  support('Support & Help');

  final String displayTitle;

  const StaticPageType(this.displayTitle);

  String get content {
    switch (this) {
      case StaticPageType.contactUs:
        return 'We would love to hear from you! If you have any questions, feedback, or inquiries, please reach out to our team at support@nova.com or call us at +1 (800) 123-4567. We are available Monday through Friday from 9 AM to 6 PM.';
      case StaticPageType.termsAndConditions:
        return 'By accessing or using the Nova application, you agree to be bound by these Terms and Conditions. Please read them carefully before using our services. If you do not agree to all of these terms, do not use the app.';
      case StaticPageType.aboutUs:
        return 'Nova is your all-in-one platform designed to deliver seamless experiences and reliable services. Our mission is to simplify daily tasks with intuitive digital solutions tailored to your needs.';
      case StaticPageType.support:
        return 'Need help or have questions? Our support team is available to assist you. Please reach out to us at support@nova.com or call our hotline for assistance with your account, orders, or technical issues.';
    }
  }
}

class StaticSettingsScreen extends StatelessWidget {
  final StaticPageType pageType;

  const StaticSettingsScreen({super.key, required this.pageType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          pageType.displayTitle,
          style: TextStyle(color: textColor, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pageType.displayTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    pageType.content,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}