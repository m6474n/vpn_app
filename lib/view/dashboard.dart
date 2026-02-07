import 'package:ds_vpn/controller/vpn_controller.dart';
import 'package:ds_vpn/utility/constants.dart';
import 'package:ds_vpn/utility/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ds_vpn/component/custom_drawer.dart';
import 'package:ds_vpn/controller/theme/theme_controller.dart';
import 'package:ds_vpn/main.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final VpnController vpnController = Get.put(VpnController());

  void _showConnectionDialog(server) async {
    final colorController = Get.find<ColorManager>();

    // Determine if we need to switch servers
    final bool needsDisconnect =
        vpnController.isConnected &&
        vpnController.selectedServer.value?.id != server.id;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorController.bgDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          needsDisconnect ? 'Switch Server?' : 'Connect to Server?',
          style: CustomStyles.h4().copyWith(color: colorController.textColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorController.bgLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(server.flagIcon, style: TextStyle(fontSize: 32)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          server.name,
                          style: CustomStyles.h5().copyWith(
                            color: colorController.textColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          server.country,
                          style: CustomStyles.paragraph().copyWith(
                            color: colorController.textColor.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              needsDisconnect
                  ? 'This will disconnect your current connection and connect to this server.'
                  : 'Do you want to connect to this server?',
              style: CustomStyles.paragraph().copyWith(
                color: colorController.textColor.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: colorController.textColor.withOpacity(0.6),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              // First select the server
              vpnController.selectServer(server);

              // If currently connected to a different server, disconnect first
              if (needsDisconnect) {
                await vpnController.disconnect();
              }

              // Then connect to the new server
              await vpnController.connect(server);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorController.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              needsDisconnect ? 'Switch' : 'Connect',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ColorManager>(
      builder: (colorController) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: colorController.bgDark,
          drawer: CustomDrawer(),
          body: CustomScrollView(
            slivers: [
              // SliverAppBar with Connection Button
              Obx(() {
                final isConnected = vpnController.isConnected;
                final isConnecting = vpnController.isConnecting;
                final selectedServer = vpnController.selectedServer.value;

                return SliverAppBar(
                  expandedHeight: 300.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: isConnected
                      ? colorManager.primaryColor
                      : colorController.bgDark,
                  leading: Padding(
                    padding: EdgeInsetsGeometry.only(left: 16, right: 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          toggleDrawer(_scaffoldKey);
                        });
                      },
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedMenu02,
                        color: isConnected
                            ? colorManager.whiteColor
                            : colorManager.primaryColor,
                      ),
                    ),
                  ),
                  // Collapsed state: show country on left side of title
                  title: selectedServer != null
                      ? Row(
                          children: [
                            Text(
                              selectedServer.flagIcon,
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                selectedServer.name,
                                style: TextStyle(
                                  color: isConnected
                                      ? colorManager.whiteColor
                                      : colorController.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'DS VPN',
                          style: TextStyle(
                            color: colorController.textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  // Collapsed state: show small connect button on right
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        isConnected
                            ? 'Connected'
                            : isConnecting
                            ? 'Connecting...'
                            : '',
                        style: CustomStyles.h4().copyWith(
                          color: isConnected
                              ? colorManager.whiteColor
                              : isConnecting
                              ? colorManager.primaryColor
                              : colorController.textColor,
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isConnected
                              ? [
                                  colorController.primaryColor,
                                  colorController.primaryColor,
                                  // colorController.primaryColor.withOpacity(0.4),
                                ]
                              : [
                                  colorController.primaryColor.withOpacity(0.1),
                                  colorController.bgDark,
                                ],
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 8),

                            SizedBox(height: 24),

                            GestureDetector(
                              onTap: () {
                                vpnController.toggleConnection();
                              },
                              child: Container(
                                width: 170,
                                height: 170,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: isConnected
                                        ? [
                                            colorController.whiteColor,
                                            colorController.whiteColor,
                                          ]
                                        : isConnecting
                                        ? [
                                            Colors.orange,
                                            Colors.orange.shade700,
                                          ]
                                        : [
                                            colorController.primaryColor,
                                            colorController.primaryColor
                                                .withOpacity(0.7),
                                          ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          (isConnected
                                                  ? colorController.primaryColor
                                                  : colorController
                                                        .primaryColor)
                                              .withOpacity(0.3),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isConnected
                                          ? HugeIcons.strokeRoundedConnect
                                          : isConnecting
                                          ? HugeIcons.strokeRoundedLoading03
                                          : HugeIcons.strokeRoundedConnect,
                                      size: 60,
                                      color: isConnected
                                          ? colorManager.primaryColor
                                          : Colors.white,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      isConnected
                                          ? 'DISCONNECT'
                                          : isConnecting
                                          ? 'CONNECTING'
                                          : 'CONNECT',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: isConnected
                                            ? colorManager.primaryColor
                                            : Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    if (isConnected)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4.0,
                                        ),
                                        child: Text(
                                          vpnController
                                              .getConnectionTimeFormatted(),
                                          style: TextStyle(
                                            color: isConnected
                                                ? colorManager.primaryColor
                                                : colorController.whiteColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),

              // Available Servers Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Available Servers',
                          style: CustomStyles.h4().copyWith(
                            color: colorController.textColor,
                          ),
                        ),
                        Text(
                          '${vpnController.availableServers.length} servers',
                          style: CustomStyles.paragraph().copyWith(
                            color: colorController.textColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),

              // Server List
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final server = vpnController.availableServers[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 8.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // Allow switching unless currently in the process of connecting
                        if (!vpnController.isConnecting) {
                          // Show confirmation dialog (handles both new connections and switching)
                          _showConnectionDialog(server);
                        }
                      },
                      child: Obx(() {
                        final isSelected =
                            vpnController.selectedServer.value?.id == server.id;

                        return Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorController.primaryColor.withOpacity(0.1)
                                : colorController.bgLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? colorController.primaryColor
                                  : colorController.borderColor,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Flag
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: colorController.bgDark,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    server.flagIcon,
                                    style: TextStyle(fontSize: 28),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),

                              // Server Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          server.name,
                                          style: CustomStyles.h5().copyWith(
                                            color: colorController.textColor,
                                          ),
                                        ),
                                        if (server.isPremium) ...[
                                          SizedBox(width: 8),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              'PRO',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      server.country,
                                      style: CustomStyles.paragraph().copyWith(
                                        color: colorController.textColor
                                            .withOpacity(0.6),
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
                                        HugeIcons.strokeRoundedDashboardSpeed01,
                                        size: 16,
                                        color: Colors.green,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '${server.speed} Mbps',
                                        style: TextStyle(
                                          color: colorController.textColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        HugeIcons.strokeRoundedSignal,
                                        size: 16,
                                        color: server.ping < 50
                                            ? Colors.green
                                            : server.ping < 100
                                            ? Colors.orange
                                            : Colors.red,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '${server.ping} ms',
                                        style: TextStyle(
                                          color: colorController.textColor
                                              .withOpacity(0.7),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              if (isSelected) ...[
                                SizedBox(width: 12),
                                Icon(
                                  HugeIcons.strokeRoundedCheckmarkCircle02,
                                  color: colorController.primaryColor,
                                  size: 24,
                                ),
                              ],
                            ],
                          ),
                        );
                      }),
                    ),
                  );
                }, childCount: vpnController.availableServers.length),
              ),

              // Bottom Padding
              SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        );
      },
    );
  }
}
