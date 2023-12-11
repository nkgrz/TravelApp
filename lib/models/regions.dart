class RegionInfo {
  final int id;
  final String name;
  final String description;
  final String imageAsset;
  final double price;

  RegionInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.price,
  });

  factory RegionInfo.fromJson(Map<String, dynamic> json) {
    return RegionInfo(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageAsset: json['imageAsset'],
      price: json['price'].toDouble(),
    );
  }
}