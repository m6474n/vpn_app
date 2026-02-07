import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../core/app_colors.dart';
import '../widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const SizedBox(height: 20),
              // Profile Header
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.accentGradient,
                          ),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              'https://api.dicebear.com/7.x/avataaars/svg?seed=Felix',
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              HugeIcons.strokeRoundedEdit01,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Alex Rivers",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      "alex.rivers@deversol.com",
                      style: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Membership Card
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        HugeIcons.strokeRoundedCrown,
                        color: AppColors.warning,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "PREMIUM PLAN",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: AppColors.warning,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            "Renews on Aug 12, 2026",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "MANAGE",
                        style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              _buildSectionTitle("ACCOUNT MANAGEMENT"),
              _buildProfileItem(
                context,
                title: "Personal Information",
                icon: HugeIcons.strokeRoundedUser,
              ),
              _buildProfileItem(
                context,
                title: "Login Activity",
                icon: HugeIcons.strokeRoundedShield02,
              ),
              _buildProfileItem(
                context,
                title: "Devices",
                icon: HugeIcons.strokeRoundedSmartPhone01,
                trailing: "3 Active",
              ),

              const SizedBox(height: 24),
              _buildSectionTitle("PREFERENCES"),
              _buildProfileItem(
                context,
                title: "Notification Settings",
                icon: HugeIcons.strokeRoundedNotification03,
              ),
              _buildProfileItem(
                context,
                title: "Payment Methods",
                icon: HugeIcons.strokeRoundedCreditCard,
              ),

              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error.withValues(alpha: 0.1),
                  foregroundColor: AppColors.error,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: AppColors.error.withValues(alpha: 0.2),
                    ),
                  ),
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(HugeIcons.strokeRoundedLogout01, size: 20),
                    SizedBox(width: 12),
                    Text(
                      "LOG OUT",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Delete Account",
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.4),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.accent.withValues(alpha: 0.7),
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    String? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: AppColors.accent),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing,
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              )
            else
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
