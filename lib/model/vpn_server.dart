class VpnServer {
  final String id;
  final String name;
  final String country;
  final String flagIcon;
  final int speed; // in Mbps
  final int ping; // in ms
  final bool isPremium;

  VpnServer({
    required this.id,
    required this.name,
    required this.country,
    required this.flagIcon,
    required this.speed,
    required this.ping,
    this.isPremium = false,
  });

  // Static method to get sample servers
  static List<VpnServer> getSampleServers() {
    return [
      VpnServer(
        id: '1',
        name: 'US East',
        country: 'United States',
        flagIcon: '🇺🇸',
        speed: 95,
        ping: 25,
      ),
      VpnServer(
        id: '2',
        name: 'UK London',
        country: 'United Kingdom',
        flagIcon: '🇬🇧',
        speed: 88,
        ping: 45,
      ),
      VpnServer(
        id: '3',
        name: 'Japan Tokyo',
        country: 'Japan',
        flagIcon: '🇯🇵',
        speed: 92,
        ping: 120,
      ),
      VpnServer(
        id: '4',
        name: 'Germany Frankfurt',
        country: 'Germany',
        flagIcon: '🇩🇪',
        speed: 90,
        ping: 35,
      ),
      VpnServer(
        id: '5',
        name: 'Singapore',
        country: 'Singapore',
        flagIcon: '🇸🇬',
        speed: 85,
        ping: 150,
        isPremium: true,
      ),
      VpnServer(
        id: '6',
        name: 'Australia Sydney',
        country: 'Australia',
        flagIcon: '🇦🇺',
        speed: 78,
        ping: 180,
      ),
      VpnServer(
        id: '7',
        name: 'Canada Toronto',
        country: 'Canada',
        flagIcon: '🇨🇦',
        speed: 87,
        ping: 40,
      ),
      VpnServer(
        id: '8',
        name: 'France Paris',
        country: 'France',
        flagIcon: '🇫🇷',
        speed: 82,
        ping: 50,
        isPremium: true,
      ),
    ];
  }
}
