class VpnServer {
  final String id;
  final String name;
  final String country;
  final String flag;
  final int ping;
  final double speed;
  final bool isPremium;
  final bool isFavorite;
  final String? configBase64;
  final String? shortCountry;

  VpnServer({
    required this.id,
    required this.name,
    required this.country,
    required this.flag,
    required this.ping,
    required this.speed,
    this.isPremium = false,
    this.isFavorite = false,
    this.configBase64,
    this.shortCountry,
  });
}
