import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../core/app_colors.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.warning.withValues(alpha: 0.2),
                              blurRadius: 40,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          HugeIcons.strokeRoundedCrown,
                          color: AppColors.warning,
                          size: 80,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "GO PREMIUM",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Unlock the full power of SecureFlow",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Features
                    _buildFeatureItem(
                      context,
                      "100+ Premium Locations",
                      HugeIcons.strokeRoundedGlobe,
                    ),
                    _buildFeatureItem(
                      context,
                      "Lightning Fast Speed (10Gbps)",
                      HugeIcons.strokeRoundedZap,
                    ),
                    _buildFeatureItem(
                      context,
                      "Zero Logs Policy",
                      HugeIcons.strokeRoundedView,
                    ),
                    _buildFeatureItem(
                      context,
                      "Connect Up to 5 Devices",
                      HugeIcons.strokeRoundedApple,
                    ),

                    const SizedBox(height: 48),

                    // Pricing Plans
                    _buildPlanItem(
                      context,
                      title: "Monthly",
                      price: "\$9.99",
                      period: "/mo",
                    ),
                    const SizedBox(height: 16),
                    _buildPlanItem(
                      context,
                      title: "Yearly",
                      price: "\$4.99",
                      period: "/mo",
                      isBestValue: true,
                      description: "Save 50% - \$59.88 billed annually",
                    ),
                    const SizedBox(height: 16),
                    _buildPlanItem(
                      context,
                      title: "Lifetime",
                      price: "\$149.99",
                      period: " once",
                    ),

                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: const Size(double.infinity, 60),
                        elevation: 8,
                        shadowColor: AppColors.accent.withValues(alpha: 0.5),
                      ),
                      child: const Text(
                        "START PREMIUM NOW",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Recurring billing. Cancel anytime.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 20),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanItem(
    BuildContext context, {
    required String title,
    required String price,
    required String period,
    bool isBestValue = false,
    String? description,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isBestValue
              ? AppColors.accent
              : Colors.white.withValues(alpha: 0.1),
          width: isBestValue ? 2 : 1,
        ),
        color: isBestValue
            ? AppColors.accent.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.05),
      ),
      child: Stack(
        children: [
          if (isBestValue)
            Positioned(
              top: 0,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: const Text(
                  "BEST VALUE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      if (description != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            description,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: price,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: period,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
