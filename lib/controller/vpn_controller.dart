import 'package:ds_vpn/model/vpn_server.dart';
import 'package:ds_vpn/utility/toasts.dart';
import 'package:get/get.dart';

enum VpnConnectionStatus { disconnected, connecting, connected, disconnecting }

class VpnController extends GetxController {
  // Observable state
  var connectionStatus = VpnConnectionStatus.disconnected.obs;
  var selectedServer = Rx<VpnServer?>(null);
  var availableServers = <VpnServer>[].obs;
  var connectionTime = 0.obs; // in seconds

  @override
  void onInit() {
    super.onInit();
    loadServers();
  }

  void loadServers() {
    availableServers.value = VpnServer.getSampleServers();
  }

  bool get isConnected =>
      connectionStatus.value == VpnConnectionStatus.connected;
  bool get isConnecting =>
      connectionStatus.value == VpnConnectionStatus.connecting;
  bool get isDisconnected =>
      connectionStatus.value == VpnConnectionStatus.disconnected;

  Future<void> toggleConnection() async {
    if (isConnected) {
      await disconnect();
    } else {
      if (selectedServer.value != null) {
        await connect(selectedServer.value!);
      } else {
        // Auto-select first server if none selected
        if (availableServers.isNotEmpty) {
          await connect(availableServers.first);
        }
      }
    }
  }

  Future<void> connect(VpnServer server) async {
    // Only prevent connecting when actively in the process of connecting
    if (isConnecting) return;

    selectedServer.value = server;
    connectionStatus.value = VpnConnectionStatus.connecting;

    // Simulate connection process
    await Future.delayed(Duration(seconds: 2));

    connectionStatus.value = VpnConnectionStatus.connected;
    connectionTime.value = 0;

    // Start connection timer
    _startConnectionTimer();
    showToast(message: "Connected to ${server.name}");
  }

  Future<void> disconnect() async {
    if (isDisconnected) return;

    connectionStatus.value = VpnConnectionStatus.disconnecting;

    // Simulate disconnection process
    await Future.delayed(Duration(seconds: 1));

    connectionStatus.value = VpnConnectionStatus.disconnected;
    connectionTime.value = 0;
  }

  void selectServer(VpnServer server) {
    selectedServer.value = server;
  }

  void _startConnectionTimer() {
    Future.doWhile(() async {
      if (isConnected) {
        await Future.delayed(Duration(seconds: 1));
        connectionTime.value++;
        return true;
      }
      return false;
    });
  }

  String getConnectionTimeFormatted() {
    int hours = connectionTime.value ~/ 3600;
    int minutes = (connectionTime.value % 3600) ~/ 60;
    int seconds = connectionTime.value % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
