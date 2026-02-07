import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../core/app_colors.dart';
import '../models/vpn_server.dart';
import '../widgets/glass_card.dart';
import '../controllers/server_controller.dart';
import '../controllers/vpn_controller.dart';
import '../controllers/navigation_controller.dart';

class ServerSelectionScreen extends StatelessWidget {
  const ServerSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final serverCtrl = Get.put(ServerController());
    final vpnCtrl = Get.find<VpnController>();

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
                      "SELECT SERVER",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  child: TextField(
                    onChanged: serverCtrl.updateSearch,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search location...",
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                      border: InputBorder.none,
                      icon: const Icon(
                        HugeIcons.strokeRoundedSearch01,
                        color: AppColors.accent,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Server List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await serverCtrl.fetchServers();
                  },
                  child: Obx(() {
                    if (serverCtrl.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accent,
                        ),
                      );
                    }

                    if (serverCtrl.filteredServers.isEmpty) {
                      return ListView(
                        children: [
                          const SizedBox(height: 100),
                          Center(
                            child: Column(
                              children: [
                                Icon(
                                  HugeIcons.strokeRoundedDatabase02,
                                  size: 48,
                                  color: AppColors.textSecondary.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "No servers found",
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      itemCount: serverCtrl.filteredServers.length,
                      itemBuilder: (context, index) {
                        final server = serverCtrl.filteredServers[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: GestureDetector(
                            onTap: () =>
                                _handleServerSelect(context, vpnCtrl, server),
                            child: GlassCard(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Flag
                                  Text(
                                    server.flag,
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                  const SizedBox(width: 20),

                                  // Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              server.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            if (server.isPremium) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.warning
                                                      .withValues(alpha: 0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: const Text(
                                                  "PRO",
                                                  style: TextStyle(
                                                    color: AppColors.warning,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          server.country,
                                          style: TextStyle(
                                            color: AppColors.textSecondary
                                                .withValues(alpha: 0.7),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Stats
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            HugeIcons.strokeRoundedSignal,
                                            size: 14,
                                            color: _getSignalColor(server.ping),
                                          ),
                                          const SizedBox(width: 6),
                                          const Text(
                                            "ms", // Label
                                            style: TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 10,
                                            ),
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            "${server.ping}",
                                            style: TextStyle(
                                              color: _getSignalColor(
                                                server.ping,
                                              ),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${server.speed.toStringAsFixed(1)} Mbps",
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.5,
                                          ),
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleServerSelect(
    BuildContext context,
    VpnController vpnCtrl,
    VpnServer server,
  ) {
    final navCtrl = Get.find<NavigationController>();
    if (vpnCtrl.status == AppVpnStatus.connected) {
      Get.dialog(
        _buildReconfirmDialog(
          onConfirm: () {
            Get.back(); // Close dialog
            vpnCtrl.reconnect(server);
            navCtrl.changeIndex(0); // Navigate to Dashboard
          },
        ),
      );
    } else {
      vpnCtrl.setServer(server);
      if (vpnCtrl.status == AppVpnStatus.disconnected) {
        vpnCtrl.toggleConnection();
      }
      navCtrl.changeIndex(0); // Navigate to Dashboard
    }
  }

  Widget _buildReconfirmDialog({required VoidCallback onConfirm}) {
    return Center(
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              HugeIcons.strokeRoundedAlert01,
              size: 48,
              color: AppColors.warning,
            ),
            const SizedBox(height: 16),
            const Text(
              "RECONNECT?",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Selecting a new server requires disconnecting from the current one. Proceed?",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "CANCEL",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "PROCEED",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getSignalColor(int ping) {
    if (ping < 50) return AppColors.success;
    if (ping < 100) return AppColors.warning;
    return AppColors.error;
  }
}
