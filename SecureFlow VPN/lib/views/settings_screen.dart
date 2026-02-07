import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../core/app_colors.dart';
import '../widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      "SETTINGS",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    _buildSection(context, "GENERAL SECURITY"),
                    _buildSettingToggle(
                      context,
                      title: "Kill Switch",
                      description: "Block internet if VPN disconnects",
                      icon: HugeIcons.strokeRoundedShield01,
                      value: true,
                    ),
                    _buildSettingToggle(
                      context,
                      title: "Auto-Connect",
                      description: "Secure unprotected networks automatically",
                      icon: HugeIcons.strokeRoundedWifi01,
                      value: false,
                    ),

                    const SizedBox(height: 24),
                    _buildSection(context, "CONNECTION PROTOCOL"),
                    _buildSettingItem(
                      context,
                      title: "Protocol",
                      value: "WireGuard (Recommended)",
                      icon: HugeIcons.strokeRoundedZap,
                    ),
                    _buildSettingToggle(
                      context,
                      title: "Split Tunneling",
                      description: "Choose which apps use the VPN",
                      icon: HugeIcons.strokeRoundedFolder01,
                      value: false,
                    ),

                    const SizedBox(height: 24),
                    _buildSection(context, "NETWORK SETTINGS"),
                    _buildSettingItem(
                      context,
                      title: "DNS Configuration",
                      value: "SecureFlow DNS (Auto)",
                      icon: HugeIcons.strokeRoundedWifi02,
                    ),
                    _buildSettingToggle(
                      context,
                      title: "IPv6 Leak Protection",
                      description: "Prevent IP leaks on IPv6 networks",
                      icon: HugeIcons.strokeRoundedShield02,
                      value: true,
                    ),

                    const SizedBox(height: 24),
                    _buildSection(context, "APP PREFERENCES"),
                    _buildSettingToggle(
                      context,
                      title: "Dark Mode",
                      description: "Cybersecurity aesthetics",
                      icon: HugeIcons.strokeRoundedMoon01,
                      value: true,
                    ),
                    _buildSettingItem(
                      context,
                      title: "Language",
                      value: "English (US)",
                      icon: HugeIcons.strokeRoundedGlobe,
                    ),

                    const SizedBox(height: 24),
                    _buildSection(context, "LEGAL & SUPPORT"),
                    _buildSettingItem(
                      context,
                      title: "Privacy Policy",
                      value: "View how we protect you",
                      icon: HugeIcons.strokeRoundedNote01,
                    ),
                    _buildSettingItem(
                      context,
                      title: "Terms of Service",
                      value: "Our agreement with you",
                      icon: HugeIcons.strokeRoundedAlignLeft,
                    ),
                    _buildSettingItem(
                      context,
                      title: "Support Center",
                      value: "Get help from our experts",
                      icon: HugeIcons.strokeRoundedMessageQuestion,
                    ),

                    const SizedBox(height: 40),

                    // Subscription Prompt
                    GlassCard(
                      child: Column(
                        children: [
                          const Icon(
                            HugeIcons.strokeRoundedCrown,
                            color: AppColors.warning,
                            size: 40,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "UNLIMITED PROTECTION",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Unlock 100+ servers and lightning speed",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text(
                              "GO PREMIUM",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        "SecureFlow VPN v1.0.0",
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                          fontSize: 10,
                        ),
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

  Widget _buildSection(BuildContext context, String title) {
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

  Widget _buildSettingToggle(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required bool value,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: (v) {},
              activeColor: AppColors.accent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
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
