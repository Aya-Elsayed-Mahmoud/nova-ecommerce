//Order Confirmation

import 'package:flutter/material.dart';

import '../home/screens/MainScreens.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              // Success Icon Circle
              Container(
                margin: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                  color: Color(0xFF6063EE),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Color(0xFF6063EE),
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title and Subtitle
              Text(
                'Thank you for your order!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Order confirmed.',
                style: TextStyle(color: theme.hintColor, fontSize: 16),
              ),
              const SizedBox(height: 60),

              // Order Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Active Step: Order Placed
                    Row(
                      children: [
                        Container(
                          width: 27,
                          height: 27,
                          decoration: const BoxDecoration(
                            color: Color(0xFF6063EE),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order Placed',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Inactive Steps
                    _buildInactiveStatusStep(context, 'Processing'),
                    const SizedBox(height: 16),
                    _buildInactiveStatusStep(context, 'Shipped'),
                    const SizedBox(height: 16),
                    _buildInactiveStatusStep(context, 'Delivered'),
                  ],
                ),
              ),

              const Spacer(),

              // Back to Home Button
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MainLayout()),
                        (route) => false,
                  );
                },
                child: Text(
                  'Back to Home',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInactiveStatusStep(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          child: CircleAvatar(radius: 3, backgroundColor: theme.hintColor),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            color: theme.hintColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}