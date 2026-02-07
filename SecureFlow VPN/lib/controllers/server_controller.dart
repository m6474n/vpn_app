import 'dart:developer' as dev show log;

import 'package:get/get.dart';
import '../models/vpn_server.dart';
import '../services/vpngate_service.dart';

class ServerController extends GetxController {
  final _allServers = <VpnServer>[].obs;
  final _isLoading = false.obs;
  final _searchQuery = "".obs;

  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;

  @override
  void onInit() {
    super.onInit();
    fetchServers();
  }

  Future<void> fetchServers() async {
    _isLoading.value = true;
    try {
      final servers = await VpnGateService.fetchServers();
      _allServers.assignAll(servers);
      if (servers.isEmpty) {
        Get.snackbar("Notice", "No servers available at the moment");
      }
    } catch (e) {
      dev.log("Error fetching VPN servers: $e");
      Get.snackbar("Error", "Failed to load VPN servers: Connection timed out");
    } finally {
      _isLoading.value = false;
    }
  }

  List<VpnServer> get filteredServers {
    if (_searchQuery.value.isEmpty) {
      return _allServers;
    }
    return _allServers
        .where(
          (s) =>
              s.name.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
              s.country.toLowerCase().contains(
                _searchQuery.value.toLowerCase(),
              ),
        )
        .toList();
  }

  void updateSearch(String query) {
    _searchQuery.value = query;
  }
}
