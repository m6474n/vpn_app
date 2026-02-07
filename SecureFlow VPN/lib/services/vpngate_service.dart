import 'package:csv/csv.dart';
import 'package:secure_flow_vpn/main.dart';
import '../models/vpn_server.dart';
import 'dart:developer' as dev;

class VpnGateService {
  static const String _baseUrl = "https://www.vpngate.net/api/iphone/";

  static Future<List<VpnServer>> fetchServers() async {
    try {
      final response = await api.getStringData(_baseUrl);
      if (response != null) {
        dev.log("VPNGate API response received, length: ${response.length}");
        // The VPNGate API returns a CSV with some prefix/suffix text
        String csvData = response;

        // Find the start of the CSV data (skipping "*vpn_servers" preamble)
        int startIndex = csvData.indexOf("#HostName");
        if (startIndex == -1) {
          dev.log("Could not find CSV header #HostName in response");
          return [];
        }

        // Find the end of the CSV data (before "*")
        int endIndex = csvData.lastIndexOf("*");
        if (endIndex == -1) endIndex = csvData.length;

        String cleanCsv = csvData.substring(startIndex, endIndex).trim();

        List<List<dynamic>> rows = const CsvToListConverter().convert(
          cleanCsv,
          shouldParseNumbers: true,
        );

        if (rows.isEmpty) {
          dev.log("CSV parsing resulted in empty rows");
          return [];
        }

        // Headers: #HostName,IP,Score,Ping,Speed,CountryLong,CountryShort,NumVpnSessions,Uptime,TotalUsers,TotalTraffic,LogType,Operator,Message,OpenVPN_ConfigData_Base64
        List<VpnServer> servers = [];

        // Skip header row
        for (var i = 1; i < rows.length; i++) {
          final row = rows[i];
          if (row.length < 15) continue;

          String country = row[5].toString();
          String shortCountry = row[6].toString().toLowerCase();

          servers.add(
            VpnServer(
              id: row[1].toString(), // IP as ID
              name: row[0].toString(),
              country: country,
              shortCountry: shortCountry,
              flag: _getFlag(shortCountry),
              ping: int.tryParse(row[3].toString()) ?? 0,
              speed:
                  (double.tryParse(row[4].toString()) ?? 0) /
                  1024 /
                  1024, // Convert to Mbps
              configBase64: row[14].toString(),
            ),
          );
        }

        dev.log("Successfully parsed ${servers.length} servers");
        return servers;
      } else {
        dev.log("VPNGate API returned null response");
      }
    } catch (e) {
      dev.log("Error fetching VPN servers: $e");
    }
    return [];
  }

  static String _getFlag(String countryCode) {
    if (countryCode.length != 2) return "🏳️";
    final int firstChar = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondChar = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
  }
}
