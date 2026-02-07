import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:get/get.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import '../models/vpn_server.dart';

enum AppVpnStatus { disconnected, connecting, connected, disconnecting, error }

class VpnController extends GetxController {
  late OpenVPN _engine;
  final _status = AppVpnStatus.disconnected.obs;
  AppVpnStatus get status => _status.value;

  final _selectedServer = Rxn<VpnServer>();
  VpnServer? get selectedServer => _selectedServer.value;

  final _ipAddress = "192.168.1.1".obs;
  String get ipAddress => _ipAddress.value;

  final _connectionTime = 0.obs;
  int get connectionTime => _connectionTime.value;

  final _byteIn = "0 B".obs;
  String get byteIn => _byteIn.value;

  final _byteOut = "0 B".obs;
  String get byteOut => _byteOut.value;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _engine = OpenVPN(
      onVpnStatusChanged: (status) => _onVpnStatusChanged(status),
      onVpnStageChanged: _onVpnStageChanged,
    );
    _engine.initialize(
      groupIdentifier: "group.com.deversol.secureFlowVpn",
      providerBundleIdentifier: "com.deversol.secureFlowVpn.VPNExtension",
      localizedDescription: "SecureFlow VPN Connection",
    );
  }

  void _onVpnStatusChanged(dynamic vpnStatus) {
    if (vpnStatus != null) {
      // Map plugin status to our internal AppVpnStatus if needed
      // For now, tracking primarily via Stage
    }
  }

  void _onVpnStageChanged(VPNStage? stage, String? message) {
    dev.log("VPN Stage Changed: $stage, Message: $message");
    switch (stage) {
      case VPNStage.disconnected:
        _status.value = AppVpnStatus.disconnected;
        _stopTimer();
        _ipAddress.value = "192.168.1.1";
        break;
      case VPNStage.connecting:
      case VPNStage.prepare:
      case VPNStage.authenticating:
        _status.value = AppVpnStatus.connecting;
        break;
      case VPNStage.connected:
        _status.value = AppVpnStatus.connected;
        _startTimer();
        // Here you would ideally fetch the real public IP
        break;
      case VPNStage.disconnecting:
        _status.value = AppVpnStatus.disconnecting;
        break;
      case VPNStage.error:
        _status.value = AppVpnStatus.error;
        Get.snackbar("Connection Error", message ?? "Unknown error");
        break;
      default:
        break;
    }
  }

  void toggleConnection() async {
    if (_status.value == AppVpnStatus.disconnected ||
        _status.value == AppVpnStatus.error) {
      _connect();
    } else {
      _disconnect();
    }
  }

  void _connect() async {
    if (_selectedServer.value?.configBase64 == null) {
      Get.snackbar("Error", "Please select a server first");
      return;
    }

    try {
      final config = utf8.decode(
        base64.decode(_selectedServer.value!.configBase64!),
      );
      _engine.connect(
        config,
        _selectedServer.value!.name,
        username: "", // VPNGate typically doesn't need these
        password: "",
        certIsRequired: false,
      );
    } catch (e) {
      _status.value = AppVpnStatus.error;
      Get.snackbar("Config Error", "Failed to parse VPN configuration");
    }
  }

  void _disconnect() {
    _engine.disconnect();
  }

  void _startTimer() {
    _connectionTime.value = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _connectionTime.value++;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _connectionTime.value = 0;
  }

  String get connectionTimeFormatted {
    int minutes = (_connectionTime.value / 60).floor();
    int seconds = _connectionTime.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void setServer(VpnServer server) {
    _selectedServer.value = server;
  }

  void reconnect(VpnServer server) {
    _disconnect();
    Future.delayed(const Duration(milliseconds: 500), () {
      _selectedServer.value = server;
      _connect();
    });
  }
}
