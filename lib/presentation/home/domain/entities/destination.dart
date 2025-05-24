class Destination {
  final String title;
  final String adress;
  final String id;
  final List<String> images;
  final String bannerImage;
  final bool isBestDestination;
  final double latitude;
  final double longitude;
  final double rating;
  final List<String> categoryList;

  Destination(
      {required this.title,
      required this.adress,
      required this.id,
      required this.images,
      required this.bannerImage,
      required this.isBestDestination,
      required this.latitude,
      required this.longitude,
      required this.rating,
      required this.categoryList});

  factory Destination.fromMap(Map<String, dynamic> map) {
    return Destination(
      title: map['title'] ?? '',
      adress: map['adress'] ?? '',
      id: map['id'] ?? '',
      images: List<String>.from(map['detailImages'] ?? []),
      bannerImage: map['bannerImage'] ?? '',
      isBestDestination: map['isBestDestination'] ?? false,
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      rating: map['rating']?.toDouble() ?? 0.0,
      categoryList: List<String>.from(map['categoryList'] ?? ['Tümü']),
    );
  }
}
