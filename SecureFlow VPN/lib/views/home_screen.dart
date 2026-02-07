import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../core/app_colors.dart';
import '../controllers/vpn_controller.dart';
import '../widgets/glass_card.dart';
import '../views/server_selection_screen.dart';
import '../models/vpn_server.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vpnController = Get.put(VpnController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.accentGradient.createShader(bounds),
          child: Text(
            "SECURE FLOW",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ),
        actions: const [SizedBox(width: 8)],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.mainGradient,
          image: DecorationImage(
            image: AssetImage('assets/images/map-bg.png'),
            fit: BoxFit.cover,
            opacity: 0.2,
            colorFilter: ColorFilter.mode(
              AppColors.primary.withValues(alpha: .7),
              BlendMode.luminosity,
            ),
          ),
        ),
        child: Stack(
          children: [
            // Background Glows
            Positioned(
              bottom: 100,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.05),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Connection Status Header
                  Obx(() {
                    String statusText = "SECURE YOUR CONNECTION";
                    Color statusColor = AppColors.textSecondary;
                    if (vpnController.status == AppVpnStatus.connected) {
                      statusText = "SECURED & PROTECTED";
                      statusColor = AppColors.success;
                    } else if (vpnController.status ==
                        AppVpnStatus.connecting) {
                      statusText = "ESTABLISHING CONNECTION...";
                      statusColor = AppColors.accent;
                    }

                    return Column(
                      children: [
                        Text(
                          statusText,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                        ),
                        if (vpnController.status == AppVpnStatus.connected)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              vpnController.connectionTimeFormatted,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontFamily: 'Monospace',
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                      ],
                    );
                  }),

                  const Spacer(),

                  // Main Connect Button
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer animated ring
                      Obx(
                        () => Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  vpnController.status == AppVpnStatus.connected
                                  ? AppColors.success.withValues(alpha: 0.2)
                                  : AppColors.accent.withValues(alpha: 0.1),
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      // Intermediate glow
                      Obx(
                        () => Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    vpnController.status ==
                                        AppVpnStatus.connected
                                    ? AppColors.success.withValues(alpha: 0.15)
                                    : AppColors.accent.withValues(alpha: 0.1),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Main Button
                      GestureDetector(
                        onTap: vpnController.toggleConnection,
                        child: Obx(() {
                          bool isConnected =
                              vpnController.status == AppVpnStatus.connected;
                          bool isConnecting =
                              vpnController.status == AppVpnStatus.connecting ||
                              vpnController.status ==
                                  AppVpnStatus.disconnecting;

                          return Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isConnected
                                    ? [
                                        AppColors.success,
                                        AppColors.success.withValues(
                                          alpha: 0.7,
                                        ),
                                      ]
                                    : [
                                        AppColors.accent,
                                        AppColors.accent.withValues(alpha: 0.7),
                                      ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (isConnected
                                              ? AppColors.success
                                              : AppColors.accent)
                                          .withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isConnecting
                                      ? HugeIcons.strokeRoundedLoading03
                                      : isConnected
                                      ? HugeIcons.strokeRoundedShield02
                                      : HugeIcons.strokeRoundedCircleLock01,
                                  size: 48,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  isConnecting
                                      ? "WAIT..."
                                      : isConnected
                                      ? "SECURE"
                                      : "CONNECT",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Bottom Cards Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        // Server Selector
                        GestureDetector(
                          onTap: () async {
                            final result = await Get.to(
                              () => const ServerSelectionScreen(),
                            );
                            if (result != null && result is VpnServer) {
                              vpnController.setServer(result);
                            }
                          },
                          child: GlassCard(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    HugeIcons.strokeRoundedGlobe,
                                    size: 24,
                                    color: AppColors.accent,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "OPTIMAL LOCATION",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                      ),
                                      Obx(
                                        () => Text(
                                          vpnController.selectedServer?.name ??
                                              "Select Server",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Stats Card
                        Row(
                          children: [
                            Expanded(
                              child: GlassCard(
                                child: Obx(
                                  () => _buildStatItem(
                                    context,
                                    label: "IP ADDRESS",
                                    icon: HugeIcons.strokeRoundedWifi01,
                                    value: vpnController.ipAddress,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GlassCard(
                                child: _buildStatItem(
                                  context,
                                  label: "LATENCY",
                                  icon: HugeIcons.strokeRoundedDashboardSpeed01,
                                  value: "24 ms",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.accent),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 9,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 13,
            fontFamily: 'Monospace',
          ),
        ),
      ],
    );
  }
}
